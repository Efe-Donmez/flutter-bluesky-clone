import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluesky_viewer/models/post/bluesky_post.dart';
import 'package:bluesky_viewer/providers/bluesky_provider.dart';
import 'package:bluesky_viewer/widgets/post_card.dart';
import 'package:bluesky_viewer/screens/post_detail_screen.dart';
import 'package:bluesky_viewer/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  
  List<BlueskyPost> _searchResults = [];
  List<Map<String, dynamic>> _userResults = [];
  Map<String, dynamic> _discoverContent = {};
  
  bool _isSearching = false;
  bool _hasSearched = false;
  bool _isLoadingDiscover = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Load discover content when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDiscoverContent();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDiscoverContent() async {
    final provider = Provider.of<BlueskyProvider>(context, listen: false);
    
    if (!provider.isAuthenticated) {
      setState(() {
        _error = 'You need to log in to view discover content';
      });
      return;
    }
    
    setState(() {
      _isLoadingDiscover = true;
      _error = '';
    });
    
    try {
      final content = await provider.getDiscoverContent();
      
      setState(() {
        _discoverContent = content;
        _isLoadingDiscover = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load discover content: $e';
        _isLoadingDiscover = false;
      });
    }
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    
    final provider = Provider.of<BlueskyProvider>(context, listen: false);
    
    // Check if user is authenticated
    if (!provider.isAuthenticated) {
      setState(() {
        _error = 'You need to log in to search';
        _isSearching = false;
      });
      return;
    }
    
    setState(() {
      _isSearching = true;
      _hasSearched = true;
      _error = '';
    });
    
    try {
      // Set the appropriate tab based on current selection
      if (_tabController.index == 0) {
        // Search for posts
        final results = await provider.searchPostsWithQuery(query);
        
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      } else if (_tabController.index == 1) {
        // Search for users
        final results = await provider.searchUsers(query);
        
        setState(() {
          _userResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Search failed: $e';
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BlueskyProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        elevation: 0,
      ),
      body: !provider.isAuthenticated
          ? _buildLoginPrompt()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Bluesky',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onSubmitted: _search,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                
                // Tab Bar
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Posts'),
                    Tab(text: 'Users'),
                    Tab(text: 'Keşfet'), // This is the new "Discover" tab
                  ],
                  onTap: (_) {
                    // Reset search state when changing tabs
                    setState(() {
                      _hasSearched = false;
                    });
                  },
                ),
                
                if (_error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      _error,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  
                // Tab Bar View
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Posts Tab
                      _isSearching
                          ? const Center(child: CircularProgressIndicator())
                          : !_hasSearched
                              ? const Center(child: Text('Search for posts'))
                              : _buildPostResults(),
                      
                      // Users Tab
                      _isSearching
                          ? const Center(child: CircularProgressIndicator())
                          : !_hasSearched
                              ? const Center(child: Text('Search for users'))
                              : _buildUserResults(),
                      
                      // Discover Tab (Keşfet)
                      _isLoadingDiscover
                          ? const Center(child: CircularProgressIndicator())
                          : _buildDiscoverContent(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDiscoverContent() {
    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDiscoverContent,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (_discoverContent.isEmpty) {
      return const Center(child: Text('No discover content available'));
    }
    
    // Get data from content
    final List<Map<String, dynamic>> suggestedFeeds = 
        List<Map<String, dynamic>>.from(_discoverContent['suggestedFeeds'] ?? []);
    final List<Map<String, dynamic>> suggestedUsers = 
        List<Map<String, dynamic>>.from(_discoverContent['suggestedUsers'] ?? []);
    final List<BlueskyPost> trendingPosts = 
        List<BlueskyPost>.from(_discoverContent['trendingPosts'] ?? []);
    
    return RefreshIndicator(
      onRefresh: _loadDiscoverContent,
      child: ListView(
        children: [
          // Suggested feeds section
          if (suggestedFeeds.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Önerilen İçerikler',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: suggestedFeeds.length,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  final feed = suggestedFeeds[index];
                  return _buildFeedCard(feed);
                },
              ),
            ),
          ],
          
          // Suggested users section
          if (suggestedUsers.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Önerilen Kullanıcılar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: suggestedUsers.length,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  final user = suggestedUsers[index];
                  return _buildUserCard(user);
                },
              ),
            ),
          ],
          
          // Trending posts section
          if (trendingPosts.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Popüler Gönderiler',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...trendingPosts.take(5).map((post) => PostCard(
              post: post,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(post: post),
                  ),
                );
              },
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildFeedCard(Map<String, dynamic> feed) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          // Navigate to feed
        },
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: feed['avatar'] != null
                    ? NetworkImage(feed['avatar'])
                    : null,
                child: feed['avatar'] == null
                    ? const Icon(Icons.rss_feed, size: 30)
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                feed['displayName'] ?? 'Feed',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                feed['description'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(handle: user['handle']),
            ),
          );
        },
        child: Container(
          width: 100,
          height: 100, // Add fixed height to prevent overflow
          padding: const EdgeInsets.all(6), // Reduce padding
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use minimum space needed
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22, // Slightly smaller avatar
                backgroundImage: user['avatar'] != null
                    ? NetworkImage(user['avatar'])
                    : null,
                child: user['avatar'] == null
                    ? const Icon(Icons.person, size: 22)
                    : null,
              ),
              const SizedBox(height: 4),
              Flexible( // Wrap in Flexible to handle text overflow
                child: Text(
                  user['displayName'] ?? 'User',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              Flexible( // Wrap in Flexible to handle text overflow
                child: Text(
                  '@${user['handle'] ?? ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostResults() {
    if (_searchResults.isEmpty) {
      return const Center(child: Text('No posts found'));
    }
    
    return ListView.separated(
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return PostCard(
          post: _searchResults[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailScreen(post: _searchResults[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUserResults() {
    if (_userResults.isEmpty) {
      return const Center(child: Text('No users found'));
    }
    
    return ListView.separated(
      itemCount: _userResults.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final user = _userResults[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: user['avatar'] != null
                ? NetworkImage(user['avatar'])
                : null,
            child: user['avatar'] == null
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text(user['displayName'] ?? 'No Name'),
          subtitle: Text('@${user['handle']}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(handle: user['handle']),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'You need to log in to search',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to home screen for login
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Go to Login'),
          ),
        ],
      ),
    );
  }
}
