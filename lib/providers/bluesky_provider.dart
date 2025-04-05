import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post/bluesky_post.dart';
import 'package:flutter/foundation.dart';
import 'package:bluesky_viewer/services/bluesky_service.dart';

enum LoadingState { initial, loading, loaded, error }

class BlueskyProvider extends ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://bsky.social/xrpc/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  
  final BlueskyService _service = BlueskyService();
  
  List<BlueskyPost> _posts = [];
  LoadingState _state = LoadingState.initial;
  bool _isAuthenticated = false;
  String _error = '';  // Changed from String? to String with default empty value
  
  // User info
  String? _accessJwt;
  String? _refreshJwt;
  String? _did;
  String _currentHandle = '';
  String _currentUsername = '';  // Changed from String? to String with default empty value
  
  bool get isAuthenticated => _isAuthenticated;
  LoadingState get state => _state;
  List<BlueskyPost> get posts => _posts;
  String get error => _error;  // No need for null check now
  String get currentHandle => _currentHandle;
  String get currentUsername => _currentUsername;  // No null check needed
  
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;
  List<BlueskyPost> _homePosts = [];
  Map<String, dynamic>? _profileData;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<BlueskyPost> get homePosts => _homePosts;
  Map<String, dynamic>? get profileData => _profileData;
  
  BlueskyProvider() {
    _loadSavedCredentials();
  }
  
  // Load saved credentials from SharedPreferences
  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _accessJwt = prefs.getString('accessJwt');
      _refreshJwt = prefs.getString('refreshJwt');
      _did = prefs.getString('did');
      _currentUsername = prefs.getString('username') ?? '';
      _currentHandle = prefs.getString('handle') ?? '';
      
      if (_accessJwt != null && _did != null) {
        _isAuthenticated = true;
        debugPrint('Loaded saved credentials for $_currentUsername');
        
        // Load user likes immediately after restoring credentials
        await loadUserLikes();
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading credentials: $e');
    }
  }
  
  // Save credentials to SharedPreferences
  Future<void> _saveCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_accessJwt != null) await prefs.setString('accessJwt', _accessJwt!);
      if (_refreshJwt != null) await prefs.setString('refreshJwt', _refreshJwt!);
      if (_did != null) await prefs.setString('did', _did!);
      await prefs.setString('username', _currentUsername);
      await prefs.setString('handle', _currentHandle);
      debugPrint('Saved credentials for $_currentUsername');
    } catch (e) {
      debugPrint('Error saving credentials: $e');
    }
  }
  
  // Clear credentials on logout
  Future<void> _clearCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessJwt');
      await prefs.remove('refreshJwt');
      await prefs.remove('did');
      await prefs.remove('username');
      await prefs.remove('handle');
      debugPrint('Cleared credentials');
    } catch (e) {
      debugPrint('Error clearing credentials: $e');
    }
  }
  
  // Login to Bluesky
  Future<bool> login(String identifier, String password) async {
    _state = LoadingState.loading;
    _error = '';  // Use empty string instead of null
    notifyListeners();
    
    try {
      final response = await _dio.post('com.atproto.server.createSession', data: {
        'identifier': identifier,
        'password': password,
      });
      
      _accessJwt = response.data['accessJwt'];
      _refreshJwt = response.data['refreshJwt'];
      _did = response.data['did'];
      _currentUsername = identifier;
      _currentHandle = response.data['handle'] ?? '';  // Provide default empty string
      
      _isAuthenticated = true;
      await _saveCredentials();
      await loadUserLikes(); // Load user's existing likes
      
      // Fetch timeline immediately after login
      await fetchTimeline();
      
      _state = LoadingState.loaded;
      notifyListeners();
      
      return true;
    } on DioException catch (e) {
      _state = LoadingState.error;
      if (e.response?.statusCode == 401) {
        _error = 'Invalid username or password';
      } else {
        _error = 'Network error: ${e.message ?? "Unknown error"}';  // Handle possible null message
      }
      notifyListeners();
      return false;
    } catch (e) {
      _state = LoadingState.error;
      _error = 'Error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  // Refresh token if expired
  Future<bool> _refreshToken() async {
    if (_refreshJwt == null) return false;
    
    try {
      final response = await _dio.post('com.atproto.server.refreshSession', 
        options: Options(headers: {'Authorization': 'Bearer $_refreshJwt'}));
      
      _accessJwt = response.data['accessJwt'];
      _refreshJwt = response.data['refreshJwt'];
      await _saveCredentials();
      return true;
    } catch (e) {
      _isAuthenticated = false;
      _error = 'Session expired. Please log in again.';
      return false;
    }
  }
  
  // Logout from Bluesky
  Future<void> logout() async {
    _isAuthenticated = false;
    _accessJwt = null;
    _refreshJwt = null;
    _did = null;
    _currentUsername = "";
    _currentHandle = '';
    _posts = [];
    _state = LoadingState.initial;
    await _clearCredentials();
    notifyListeners();
  }
  
  // Reset state (for error recovery)
  void reset() {
    _state = LoadingState.initial;
    _error = '';  // Use empty string instead of null
    notifyListeners();
  }
  
  // Fetch posts by handle
  Future<void> fetchPostsByHandle(String handle) async {
    if (handle.isEmpty) return;
    
    // Format handle if needed
    if (!handle.startsWith('@') && !handle.startsWith('did:')) {
      handle = '@$handle';
    }
    
    _currentHandle = handle;
    _state = LoadingState.loading;
    _error = '';  // Use empty string instead of null
    notifyListeners();
    
    try {
      // First, resolve the handle to get the DID
      String? targetDid;
      
      if (handle.startsWith('@')) {
        final resolveResp = await _dio.get(
          'com.atproto.identity.resolveHandle',
          queryParameters: {'handle': handle.substring(1)},
          options: _isAuthenticated && _accessJwt != null
              ? Options(headers: {'Authorization': 'Bearer $_accessJwt'})
              : null,
        );
        targetDid = resolveResp.data['did'];
      } else {
        targetDid = handle; // Already a DID
      }
      
      // Then fetch the author's posts
      final response = await _dio.get(
        'app.bsky.feed.getAuthorFeed',
        queryParameters: {'actor': targetDid},
        options: _isAuthenticated && _accessJwt != null
            ? Options(headers: {'Authorization': 'Bearer $_accessJwt'})
            : null,
      );
      
      final List<dynamic> feedItems = response.data['feed'];
      _posts = feedItems.map((item) => BlueskyPost.fromJson(item)).toList();
      
      _state = LoadingState.loaded;
      notifyListeners();
    } on DioException catch (e) {
      _state = LoadingState.error;
      if (e.response?.statusCode == 401) {
        _error = 'AuthMissing: Authentication required to view this content.';
      } else {
        _error = 'Failed to fetch posts: ${e.message ?? "Unknown error"}';  // Handle possible null message
      }
      notifyListeners();
    } catch (e) {
      _state = LoadingState.error;
      _error = 'Error: ${e.toString()}';
      notifyListeners();
    }
  }
  
  // Fetch timeline posts (for authenticated users)
  Future<void> fetchTimeline() async {
    if (!_isAuthenticated || _accessJwt == null) {
      _state = LoadingState.error;
      _error = 'AuthMissing: Not authenticated';
      notifyListeners();
      return;
    }
    
    _state = LoadingState.loading;
    _error = "";
    _currentHandle = '';
    notifyListeners();
    
    try {
      // First, make sure we have up-to-date likes data
      await loadUserLikes();
      
      final response = await _dio.get(
        'app.bsky.feed.getTimeline',
        options: Options(
          headers: {'Authorization': 'Bearer $_accessJwt'},
        ),
      );
      
      final List<dynamic> feedItems = response.data['feed'];
      _posts = feedItems.map((item) {
        try {
          return BlueskyPost.fromJson(item);
        } catch (e) {
          debugPrint('Error parsing post: $e');
          return null;
        }
      }).whereType<BlueskyPost>().toList();
      
      _state = LoadingState.loaded;
      notifyListeners();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Try to refresh the token
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Try again with the new token
          await fetchTimeline();
          return;
        } else {
          _state = LoadingState.error;
          _error = 'Authentication expired. Please log in again.';
          _isAuthenticated = false;
        }
      } else {
        _state = LoadingState.error;
        _error = 'Network error: ${e.message ?? "Unknown error"}';
      }
      notifyListeners();
    } catch (e) {
      _state = LoadingState.error;
      _error = 'Error: ${e.toString()}';
      notifyListeners();
    }
  }

  // Renamed method to avoid duplicate definition
  Future<bool> loginWithService(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _isLoggedIn = await _service.login(username, password);
      if (_isLoggedIn) {
        await fetchHomeFeed();
      } else {
        _errorMessage = 'Login failed. Check your credentials.';
      }
      return _isLoggedIn;
    } catch (e) {
      _errorMessage = 'Error during login: $e';
      _isLoggedIn = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Fetch home feed
  Future<void> fetchHomeFeed() async {
    if (!_isLoggedIn) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _homePosts = await _service.getHomeFeed();
    } catch (e) {
      _errorMessage = 'Failed to load home feed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Fetch profile data
  Future<void> fetchProfile() async {
    if (!_isLoggedIn) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _profileData = await _service.getProfile();
    } catch (e) {
      _errorMessage = 'Failed to load profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Search posts
  Future<List<BlueskyPost>> searchPosts(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final results = await _service.searchPosts(query);
      return results;
    } catch (e) {
      _errorMessage = 'Search failed: $e';
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Get profile data with the user's DID
  Future<Map<String, dynamic>> getProfileData() async {
    if (!_isAuthenticated || _accessJwt == null || _did == null) {
      throw Exception('Not authenticated');
    }
    
    try {
      final response = await _dio.get(
        'app.bsky.actor.getProfile',
        queryParameters: {'actor': _did},
        options: Options(headers: {'Authorization': 'Bearer $_accessJwt'}),
      );
      
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Try to refresh the token
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Try again with the new token
          return getProfileData();
        }
      }
      throw Exception('Failed to get profile: ${e.message}');
    }
  }

  // Add this new method for searching posts
  Future<List<BlueskyPost>> searchPostsWithQuery(String query) async {
    if (!_isAuthenticated || _accessJwt == null) {
      throw Exception('Not authenticated');
    }
    
    try {
      // Bluesky currently doesn't have a dedicated search endpoint
      // We can use the searchPosts endpoint when it becomes available
      // For now, we'll use a workaround to search for posts containing the query
      final response = await _dio.get(
        'app.bsky.feed.getTimeline',
        queryParameters: {'limit': 100},
        options: Options(headers: {'Authorization': 'Bearer $_accessJwt'}),
      );
      
      final List<dynamic> feedItems = response.data['feed'];
      
      // Filter posts that contain the search query
      final List<BlueskyPost> posts = [];
      
      for (var item in feedItems) {
        try {
          final post = BlueskyPost.fromJson(item);
          if (post.record.text.toLowerCase().contains(query.toLowerCase())) {
            posts.add(post);
          }
        } catch (e) {
          debugPrint('Error parsing post: $e');
        }
      }
      
      return posts;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Try to refresh the token
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Try again with the new token
          return searchPostsWithQuery(query);
        }
      }
      throw Exception('Search failed: ${e.message}');
    }
  }

  // Add this new method to get replies to a post
  Future<List<BlueskyPost>> getPostReplies(String postUri) async {
    if (!_isAuthenticated || _accessJwt == null) {
      throw Exception('Not authenticated');
    }
    
    try {
      final response = await _dio.get(
        'app.bsky.feed.getPostThread',
        queryParameters: {'uri': postUri},
        options: Options(headers: {'Authorization': 'Bearer $_accessJwt'}),
      );
      
      final thread = response.data['thread'];
      
      // Extract replies from the thread
      final List<BlueskyPost> replies = [];
      
      if (thread['replies'] != null && thread['replies'] is List) {
        for (var reply in thread['replies']) {
          try {
            // The post is nested in the 'post' field of each reply
            if (reply['post'] != null) {
              final post = BlueskyPost.fromJson(reply['post']);
              replies.add(post);
            }
          } catch (e) {
            debugPrint('Error parsing reply: $e');
          }
        }
      }
      
      return replies;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Try to refresh the token
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Try again with the new token
          return getPostReplies(postUri);
        }
      }
      throw Exception('Failed to get replies: ${e.message}');
    }
  }

  // Track liked posts
  final Set<String> _likedPosts = {};
  
  // Check if a post is liked
  bool isPostLiked(String postUri) {
    return _likedPosts.contains(postUri);
  }
  
  // Like a post
  Future<bool> likePost(BlueskyPost post) async {
    if (!_isAuthenticated || _accessJwt == null) {
      throw Exception('Not authenticated');
    }
    
    try {
      debugPrint('Attempting to like post: ${post.uri}');
      
      // Create a like record
      final response = await _dio.post(
        'com.atproto.repo.createRecord',
        options: Options(headers: {'Authorization': 'Bearer $_accessJwt'}),
        data: {
          'repo': _did,
          'collection': 'app.bsky.feed.like',
          'record': {
            'subject': {
              'uri': post.uri,
              'cid': post.cid,
            },
            'createdAt': DateTime.now().toUtc().toIso8601String(),
          },
        },
      );
      
      debugPrint('Like response status: ${response.statusCode}');
      
      // Add to local liked posts cache
      _likedPosts.add(post.uri);
      
      // Update the like count locally
      _updatePostLikeCount(post.uri, 1);
      
      notifyListeners();
      return true;
    } on DioException catch (e) {
      debugPrint('DioException in likePost: ${e.toString()}');
      
      if (e.response?.statusCode == 401) {
        // Try to refresh token
        final refreshed = await _refreshToken();
        if (refreshed) {
          return likePost(post);
        }
      }
      throw Exception('Failed to like post: ${e.message}');
    }
  }

  // Unlike a post - completely rewritten implementation 
  Future<bool> unlikePost(BlueskyPost post) async {
    if (!_isAuthenticated || _accessJwt == null) {
      throw Exception('Not authenticated');
    }
    
    try {
      debugPrint('Attempting to unlike post: ${post.uri}');
      
      // Try direct approach - generate the rkey from the post URI
      String directRkey = '';
      try {
        final postUriParts = post.uri.split('/');
        if (postUriParts.length >= 4) {
          directRkey = postUriParts.last; // Extract rkey from post URI
          debugPrint('Generated rkey from post URI: $directRkey');
        }
      } catch (e) {
        debugPrint('Error extracting rkey from post URI: $e');
      }
            
      // First approach: Try finding the like record from likes list
      final findResponse = await _dio.get(
        'app.bsky.feed.getLikes',
        queryParameters: {'uri': post.uri},
        options: Options(headers: {'Authorization': 'Bearer $_accessJwt'}),
      );
      
      final likes = findResponse.data['likes'] as List;
      String? rkey;
      
      debugPrint('Found ${likes.length} likes for post, looking for user like');
      
      // Dump first few likes for debugging
      if (likes.isNotEmpty) {
        debugPrint('Sample like data structure: ${likes[0]}');
      }
      
      // Find the user's like and extract the rkey with null checks
      for (final like in likes) {
        if (like['creator'] != null && 
            like['creator']['did'] != null && 
            like['creator']['did'] == _did) {
          
          if (like['uri'] != null) {
            final uri = like['uri'] as String;
            debugPrint('Found matching like URI: $uri');
            final parts = uri.split('/');
            if (parts.length >= 3) {
              rkey = parts.last;
              debugPrint('Found user like with rkey: $rkey');
            }
          }
          break;
        }
      }
      
      // If we couldn't find the like through the API, try a more direct approach
      if (rkey == null && directRkey.isNotEmpty) {
        debugPrint('Using generated rkey as fallback: $directRkey');
        rkey = directRkey;
      }
      
      if (rkey == null) {
        debugPrint('No like found to unlike for post: ${post.uri}');
        _likedPosts.remove(post.uri); // Ensure it's not in our local cache
        notifyListeners();
        return false;
      }
      
      // Try to delete the like record - first with standard endpoint
      try {
        debugPrint('Deleting like record with rkey: $rkey');
        
        final deleteResponse = await _dio.post(
          'com.atproto.repo.deleteRecord',
          options: Options(headers: {'Authorization': 'Bearer $_accessJwt'}),
          data: {
            'repo': _did,
            'collection': 'app.bsky.feed.like',
            'rkey': rkey
          },
        );
        
        debugPrint('Delete response status: ${deleteResponse.statusCode}');
        
        // Remove from local liked posts cache
        _likedPosts.remove(post.uri);
        
        // Update post like counts
        _updatePostLikeCount(post.uri, -1);
        
        notifyListeners();
        return true;
      } catch (deleteError) {
        debugPrint('First delete attempt failed: $deleteError');
        
        // Try an alternative approach if the first one fails
        try {
          // Some APIs use alternative formats, try this as a backup
          final alternativeResponse = await _dio.post(
            'com.atproto.repo.deleteRecord',
            options: Options(headers: {'Authorization': 'Bearer $_accessJwt'}),
            data: {
              'did': _did,
              'collection': 'app.bsky.feed.like',
              'rkey': rkey
            },
          );
          
          debugPrint('Alternative delete response: ${alternativeResponse.statusCode}');
          
          // Remove from local liked posts cache
          _likedPosts.remove(post.uri);
          
          // Update post like counts
          _updatePostLikeCount(post.uri, -1);
          
          notifyListeners();
          return true;
        } catch (altError) {
          debugPrint('Alternative delete also failed: $altError');
          throw altError;
        }
      }
    } on DioException catch (e) {
      debugPrint('DioException in unlikePost: ${e.toString()}');
      debugPrint('Response: ${e.response?.data}');
      
      if (e.response?.statusCode == 401) {
        // Try to refresh token
        final refreshed = await _refreshToken();
        if (refreshed) {
          return unlikePost(post);
        }
      }
      throw Exception('Failed to unlike post: ${e.message}');
    } catch (e) {
      debugPrint('Error in unlikePost: ${e.toString()}');
      throw Exception('Error in unlikePost: $e');
    }
  }
  
  // Helper method to update post like count across all lists
  void _updatePostLikeCount(String postUri, int change) {
    // Update in main posts list
    for (int i = 0; i < _posts.length; i++) {
      if (_posts[i].uri == postUri) {
        final currentCount = _posts[i].likeCount;
        final newCount = (currentCount + change) < 0 ? 0 : currentCount + change;
        _posts[i] = _posts[i].copyWith(likeCount: newCount);
      }
    }
    
    // Update in home posts
    for (int i = 0; i < _homePosts.length; i++) {
      if (_homePosts[i].uri == postUri) {
        final currentCount = _homePosts[i].likeCount;
        final newCount = (currentCount + change) < 0 ? 0 : currentCount + change;
        _homePosts[i] = _homePosts[i].copyWith(likeCount: newCount);
      }
    }
  }
  
  // Toggle like status of a post with improved error handling
  Future<bool> togglePostLike(BlueskyPost post) async {
    try {
      final isLiked = isPostLiked(post.uri);
      debugPrint('Toggling like for post ${post.uri} - current status: ${isLiked ? 'liked' : 'not liked'}');
      
      if (isLiked) {
        final result = await unlikePost(post);
        debugPrint('Unlike result: $result');
        return result;
      } else {
        final result = await likePost(post);
        debugPrint('Like result: $result');
        return result;
      }
    } catch (e) {
      debugPrint('Error toggling like: $e');
      return false;
    }
  }
  
  // Improved load user's likes to initialize the liked posts cache
  Future<void> loadUserLikes() async {
    if (!_isAuthenticated || _accessJwt == null || _did == null) {
      return;
    }
    
    try {
      debugPrint('Loading likes for user: $_did');
      final response = await _dio.get(
        'app.bsky.feed.getActorLikes',
        queryParameters: {'actor': _did, 'limit': 100},  // Increased limit to get more likes
        options: Options(headers: {'Authorization': 'Bearer $_accessJwt'}),
      );
      
      final likes = response.data['feed'] as List;
      
      // Clear existing likes
      _likedPosts.clear();
      
      // Add all liked post URIs to the cache
      int likeCount = 0;
      for (final like in likes) {
        try {
          if (like['post'] != null && like['post']['uri'] != null) {
            final uri = like['post']['uri'] as String;
            _likedPosts.add(uri);
            likeCount++;
            
            // Also update any matching posts in our current list
            for (int i = 0; i < _posts.length; i++) {
              if (_posts[i].uri == uri) {
                // Make sure the like count is updated
                if (_posts[i].likeCount == 0) {
                  final updatedPost = _posts[i].copyWith(likeCount: _posts[i].likeCount + 1);
                  _posts[i] = updatedPost;
                }
              }
            }
          }
        } catch (e) {
          debugPrint('Error processing like: $e');
        }
      }
      
      debugPrint('Loaded $likeCount liked posts');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user likes: $e');
    }
  }

  // Fetch posts by handle specifically for profile
  Future<List<BlueskyPost>> fetchPostsByHandleForProfile(String handle) async {
    if (!_isAuthenticated || _accessJwt == null) {
      throw Exception('Not authenticated');
    }
    
    try {
      // Make sure likes are loaded before fetching posts
      await loadUserLikes();
      
      // First, resolve the handle to get the DID if needed
      String targetDid;
      
      if (!handle.startsWith('did:')) {
        final resolveResp = await _dio.get(
          'com.atproto.identity.resolveHandle',
          queryParameters: {'handle': handle},
          options: Options(headers: {'Authorization': 'Bearer $_accessJwt'}),
        );
        targetDid = resolveResp.data['did'];
      } else {
        targetDid = handle; // Already a DID
      }
      
      // Then fetch the author's posts
      final response = await _dio.get(
        'app.bsky.feed.getAuthorFeed',
        queryParameters: {'actor': targetDid},
        options: Options(headers: {'Authorization': 'Bearer $_accessJwt'}),
      );
      
      final List<dynamic> feedItems = response.data['feed'];
      return feedItems.map((item) {
        try {
          return BlueskyPost.fromJson(item);
        } catch (e) {
          debugPrint('Error parsing post: $e');
          return null;
        }
      }).whereType<BlueskyPost>().toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Try to refresh the token
        final refreshed = await _refreshToken();
        if (refreshed) {
          return fetchPostsByHandleForProfile(handle);
        }
      }
      throw Exception('Failed to fetch profile posts: ${e.message}');
    }
  }
  
  // Get user's liked posts
  Future<List<BlueskyPost>> getUserLikedPosts() async {
    if (!_isAuthenticated || _accessJwt == null || _did == null) {
      throw Exception('Not authenticated');
    }
    
    try {
      final response = await _dio.get(
        'app.bsky.feed.getActorLikes',
        queryParameters: {'actor': _did},
        options: Options(headers: {'Authorization': 'Bearer $_accessJwt'}),
      );
      
      final likes = response.data['feed'] as List;
      
      // Extract posts from the likes feed
      final List<BlueskyPost> likedPosts = [];
      
      for (final like in likes) {
        try {
          if (like['post'] != null) {
            final post = BlueskyPost.fromJson(like['post']);
            likedPosts.add(post);
          }
        } catch (e) {
          debugPrint('Error parsing liked post: $e');
        }
      }
      
      return likedPosts;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Try to refresh the token
        final refreshed = await _refreshToken();
        if (refreshed) {
          return getUserLikedPosts();
        }
      }
      throw Exception('Failed to get liked posts: ${e.message}');
    }
  }

  // Add method to get profile data by handle
  Future<Map<String, dynamic>> getProfileDataByHandle(String handle) async {
    if (!_isAuthenticated || _accessJwt == null) {
      throw Exception('Not authenticated');
    }
    
    try {
      final response = await _dio.get(
        'app.bsky.actor.getProfile',
        queryParameters: {'actor': handle},
        options: Options(headers: {'Authorization': 'Bearer $_accessJwt'}),
      );
      
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Try to refresh the token
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Try again with the new token
          return getProfileDataByHandle(handle);
        }
      }
      throw Exception('Failed to get profile: ${e.message}');
    }
  }

  // Search for users by handle or name
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    if (!_isAuthenticated || _accessJwt == null) {
      throw Exception('Not authenticated');
    }
    
    try {
      final response = await _dio.get(
        'app.bsky.actor.searchActors',
        queryParameters: {
          'term': query,
          'limit': 20
        },
        options: Options(headers: {'Authorization': 'Bearer $_accessJwt'}),
      );
      
      final actors = response.data['actors'] as List;
      return actors.map((actor) => actor as Map<String, dynamic>).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Try to refresh the token
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Try again with the new token
          return searchUsers(query);
        }
      }
      throw Exception('Failed to search users: ${e.message}');
    }
  }

  // Add method to discover trending content or suggested users
  Future<Map<String, dynamic>> getDiscoverContent() async {
    if (!_isAuthenticated || _accessJwt == null) {
      throw Exception('Not authenticated');
    }
    
    try {
      // Get suggested feeds (curated content)
      final feedsResponse = await _dio.get(
        'app.bsky.feed.getSuggestedFeeds',
        options: Options(headers: {'Authorization': 'Bearer $_accessJwt'}),
      );
      
      // Get suggested follows (users)
      final followsResponse = await _dio.get(
        'app.bsky.actor.getSuggestions',
        options: Options(headers: {'Authorization': 'Bearer $_accessJwt'}),
      );
      
      // Get popular (trending) posts - we'll use timeline for now as a placeholder
      // since there's no dedicated trending endpoint yet
      final postsResponse = await _dio.get(
        'app.bsky.feed.getTimeline',
        queryParameters: {'limit': 20},
        options: Options(headers: {'Authorization': 'Bearer $_accessJwt'}),
      );
      
      // Parse the results
      final feeds = feedsResponse.data['feeds'] as List;
      final users = followsResponse.data['actors'] as List;
      
      // Process feed items to BlueskyPost objects
      final List<BlueskyPost> trendingPosts = [];
      for (var item in postsResponse.data['feed']) {
        try {
          final post = BlueskyPost.fromJson(item);
          trendingPosts.add(post);
        } catch (e) {
          debugPrint('Error parsing trending post: $e');
        }
      }
      
      // Return combined discovery data
      return {
        'suggestedFeeds': feeds,
        'suggestedUsers': users,
        'trendingPosts': trendingPosts,
      };
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Try to refresh the token
        final refreshed = await _refreshToken();
        if (refreshed) {
          return getDiscoverContent();
        }
      }
      throw Exception('Failed to get discover content: ${e.message}');
    }
  }
}