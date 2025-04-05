import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/post/bluesky_post.dart';

class BlueskyApiService {
  static const String baseUrl = 'https://bsky.social';
  static const String apiUrl = 'https://api.bsky.app';
  String? _accessJwt;
  String? _refreshJwt;
  String? _currentUsername;
  
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    contentType: 'application/json',
  ));
  
  String? get currentUsername => _currentUsername;
  bool get isLoggedIn => _accessJwt != null;

  Future<List<BlueskyPost>> getPostsByHandle(String handle) async {
    try {
      handle = _validateAndFormatHandle(handle);
      
      String apiHandle = handle.startsWith('@') ? handle.substring(1) : handle;
      
      Response? resolveResponse;
      String? resolveError;
      
      try {
        final Uri resolveUri = Uri.parse('$baseUrl/xrpc/com.atproto.identity.resolveHandle?handle=${Uri.encodeComponent(apiHandle)}');
        print('Resolving handle with URL: ${resolveUri.toString()}');
        resolveResponse = await _dio.getUri(resolveUri, options: Options(headers: _getHeaders()));
      } catch (e) {
        resolveError = e.toString();
        try {
          final Uri resolveUri = Uri.parse('$apiUrl/xrpc/com.atproto.identity.resolveHandle?handle=${Uri.encodeComponent(apiHandle)}');
          print('Trying fallback URL for handle resolution: ${resolveUri.toString()}');
          resolveResponse = await _dio.getUri(resolveUri, options: Options(headers: _getHeaders()));
          resolveError = null;
        } catch (fallbackError) {
          throw 'Failed to resolve handle on both endpoints: $resolveError, $fallbackError';
        }
      }
      
      if (resolveResponse.statusCode != 200) {
        _logApiError('Resolve Handle', resolveResponse);
        throw _handleErrorResponse(resolveResponse);
      }

      final resolveData = resolveResponse.data;
      final did = resolveData['did'];

      try {
        final feedResponse = await _dio.get(
          '$baseUrl/xrpc/app.bsky.feed.getAuthorFeed',
          queryParameters: {'actor': did},
          options: Options(headers: _getHeaders()),
        );

        if (feedResponse.statusCode != 200) {
          throw _handleErrorResponse(feedResponse);
        }

        final feedData = feedResponse.data;
        
        List<BlueskyPost> posts = [];
        if (feedData.containsKey('feed') && feedData['feed'] is List) {
          for (var feedItem in feedData['feed']) {
            try {
              posts.add(BlueskyPost.fromJson(feedItem));
            } catch (e) {
              print('Error parsing post: $e');
              print('Problematic JSON: $feedItem');
            }
          }
        }
        
        return posts;
      } catch (e) {
        print('Error fetching feed: $e');
        rethrow;
      }
    } catch (e) {
      print('Error in getPostsByHandle: $e');
      if (e.toString().contains('authmissing') && _refreshJwt == null) {
        throw 'Authentication required to view this content. Please log in.';
      }
      rethrow;
    }
  }

  String _validateAndFormatHandle(String handle) {
    handle = handle.trim();
    
    if (!handle.startsWith('@')) {
      handle = '@$handle';
    }
    
    if (!handle.contains('.')) {
      throw 'Invalid handle format. Handle must include a domain (like @username.bsky.social)';
    }
    
    final RegExp validHandlePattern = RegExp(r'^@[a-zA-Z0-9-_.]+(\.[a-zA-Z0-9-]+)+$');
    
    if (!validHandlePattern.hasMatch(handle)) {
      throw 'Invalid handle format. Please use a format like @username.bsky.social';
    }
    
    return handle;
  }

  Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final response = await _attemptLogin(baseUrl, identifier, password);
      return response;
    } catch (e) {
      if (e.toString().contains('404')) {
        print('Primary login endpoint failed with 404, trying fallback endpoint');
        try {
          final response = await _attemptLogin(apiUrl, identifier, password);
          return response;
        } catch (fallbackError) {
          throw 'Login failed on both endpoints: ${fallbackError.toString()}';
        }
      }
      throw 'Login failed: ${e.toString()}';
    }
  }

  Future<Map<String, dynamic>> _attemptLogin(String baseEndpoint, String identifier, String password) async {
    try {
      final response = await _dio.post(
        '$baseEndpoint/xrpc/com.atproto.server.createSession',
        data: {
          'identifier': identifier,
          'password': password,
        },
      );

      if (response.statusCode == 404) {
        throw 'API endpoint not found (404). The Bluesky API may have changed.';
      }
      
      if (response.statusCode != 200) {
        throw _handleErrorResponse(response);
      }

      final data = response.data;
      _accessJwt = data['accessJwt'];
      _refreshJwt = data['refreshJwt'];
      _currentUsername = data['handle'] ?? identifier;
      
      return data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw 'API endpoint not found (404). The Bluesky API may have changed.';
      }
      throw _handleDioException(e);
    }
  }
  
  void logout() {
    _accessJwt = null;
    _refreshJwt = null;
    _currentUsername = null;
  }

  Future<Map<String, dynamic>?> getProfile() async {
    if (!isLoggedIn) return null;
    
    try {
      final response = await _dio.get(
        '$baseUrl/xrpc/app.bsky.actor.getProfile',
        queryParameters: {'actor': _currentUsername},
        options: Options(headers: _getHeaders()),
      );
      
      if (response.statusCode != 200) {
        return null;
      }
      
      return response.data;
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  Map<String, dynamic> _getHeaders() {
    Map<String, dynamic> headers = {};
    if (_accessJwt != null) {
      headers['Authorization'] = 'Bearer $_accessJwt';
    }
    return headers;
  }
  
  void _logApiError(String operation, Response response, [dynamic error]) {
    print('==== Bluesky API Error ====');
    print('Operation: $operation');
    print('Status Code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    
    try {
      print('Body: ${response.data}');
    } catch (e) {
      print('Could not parse error response: $e');
    }
    
    if (error != null) {
      print('Exception: $error');
    }
    print('=========================');
  }

  String _handleDioException(DioException e) {
    if (e.response != null) {
      return _handleErrorResponse(e.response!);
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'Server is taking too long to respond. Please try again later.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'Connection error. Please check your internet connection.';
    }
    return 'Network error: ${e.message}';
  }

  String _handleErrorResponse(Response response) {
    try {
      _logApiError('Handle Error Response', response);
      
      if (response.statusCode == 404) {
        return 'API endpoint not found (404). The Bluesky API may have changed.';
      }
      
      final errorData = response.data;
      if (errorData is Map && errorData.containsKey('error')) {
        if (errorData['error'] == 'InvalidRequest' && 
            errorData.containsKey('message') && 
            errorData['message'].toString().contains('handle')) {
          return 'Invalid handle format. Please use a valid Bluesky handle like @username.bsky.social';
        } else if (errorData['error'] == 'InvalidLogin') {
          return 'Invalid username or password';
        } else if (errorData['error'] == 'AuthenticationRequired' || 
                  errorData['error'] == 'authmissing') {
          return 'Authentication required';
        }
        return errorData['error'] + (errorData.containsKey('message') ? ': ${errorData['message']}' : '');
      }
      return 'Error ${response.statusCode}';
    } catch (e) {
      return 'Error ${response.statusCode}';
    }
  }
}