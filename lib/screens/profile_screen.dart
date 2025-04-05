import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluesky_viewer/providers/bluesky_provider.dart';
import 'package:bluesky_viewer/models/post/bluesky_post.dart';
import 'package:bluesky_viewer/widgets/post_card.dart';
import 'package:bluesky_viewer/screens/post_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? handle; // Add handle parameter to view other profiles

  const ProfileScreen({
    Key? key, 
    this.handle,  // null means show current user's profile
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _profileData;
  bool _isLoading = false;
  String? _error;
  late TabController _tabController;
  
  // Posts for each tab
  List<BlueskyPost> _posts = [];
  List<BlueskyPost> _replies = [];
  List<BlueskyPost> _media = [];
  List<BlueskyPost> _likes = [];
  
  // Loading states for each tab
  bool _isLoadingPosts = false;
  bool _isLoadingReplies = false;
  bool _isLoadingMedia = false;
  bool _isLoadingLikes = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadProfile();
    
    // Listen to tab changes to load data when tab is selected
    _tabController.addListener(_handleTabChange);
  }
  
  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }
  
  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      // Load data for the selected tab if it hasn't been loaded yet
      switch (_tabController.index) {
        case 0:
          if (_posts.isEmpty && !_isLoadingPosts) {
            _loadUserPosts();
          }
          break;
        case 1:
          if (_replies.isEmpty && !_isLoadingReplies) {
            _loadUserReplies();
          }
          break;
        case 2:
          if (_media.isEmpty && !_isLoadingMedia) {
            _loadUserMedia();
          }
          break;
        case 3:
          if (_likes.isEmpty && !_isLoadingLikes) {
            _loadUserLikes();
          }
          break;
      }
    }
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final provider = Provider.of<BlueskyProvider>(context, listen: false);
      if (!provider.isAuthenticated) {
        setState(() {
          _isLoading = false;
          _error = 'You need to log in to view profiles';
        });
        return;
      }
      
      // Make sure likes are loaded
      await provider.loadUserLikes();
      
      // If handle is provided, load that user's profile, otherwise load current user's profile
      final profileData = widget.handle != null
          ? await provider.getProfileDataByHandle(widget.handle!)
          : await provider.getProfileData();
          
      if (mounted) {
        setState(() {
          _profileData = profileData;
          _isLoading = false;
        });
        
        // Load posts for the first tab
        _loadUserPosts();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load profile: $e';
        });
      }
    }
  }
  
  // Load user's posts - Modified to work with any profile
  Future<void> _loadUserPosts() async {
    if (!mounted || _profileData == null) return;
    
    setState(() {
      _isLoadingPosts = true;
    });
    
    try {
      final provider = Provider.of<BlueskyProvider>(context, listen: false);
      final handle = _profileData!['handle'];
      final posts = await provider.fetchPostsByHandleForProfile(handle);
      
      if (mounted) {
        setState(() {
          _posts = posts;
          _isLoadingPosts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingPosts = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load posts: $e')),
        );
      }
    }
  }
  
  // Load user's replies
  Future<void> _loadUserReplies() async {
    if (!mounted || _profileData == null) return;
    
    setState(() {
      _isLoadingReplies = true;
    });
    
    try {
      final provider = Provider.of<BlueskyProvider>(context, listen: false);
      // For now, we'll simulate replies with a filtered set of posts
      // In a real implementation, you would use a specific API endpoint for replies
      final posts = await provider.fetchPostsByHandleForProfile(_profileData!['handle']);
      final replies = posts.where((post) => post.reply != null).toList();
      
      if (mounted) {
        setState(() {
          _replies = replies;
          _isLoadingReplies = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingReplies = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load replies: $e')),
        );
      }
    }
  }
  
  // Load user's media posts
  Future<void> _loadUserMedia() async {
    if (!mounted || _profileData == null) return;
    
    setState(() {
      _isLoadingMedia = true;
    });
    
    try {
      final provider = Provider.of<BlueskyProvider>(context, listen: false);
      // For now, we'll simulate media posts
      // In a real implementation, you would filter for posts with media
      final posts = await provider.fetchPostsByHandleForProfile(_profileData!['handle']);
      
      if (mounted) {
        setState(() {
          _media = posts; // In a real app, filter for posts with images
          _isLoadingMedia = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMedia = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load media: $e')),
        );
      }
    }
  }
  
  // Load user's liked posts
  Future<void> _loadUserLikes() async {
    if (!mounted) return;
    
    setState(() {
      _isLoadingLikes = true;
    });
    
    try {
      final provider = Provider.of<BlueskyProvider>(context, listen: false);
      final likes = await provider.getUserLikedPosts();
      
      if (mounted) {
        setState(() {
          _likes = likes;
          _isLoadingLikes = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLikes = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load likes: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BlueskyProvider>(context);
    final bool isCurrentUser = widget.handle == null || widget.handle == provider.currentHandle;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isCurrentUser ? 'My Profile' : 'Profile'),
        actions: [
          if (isCurrentUser)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                provider.logout();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: !provider.isAuthenticated
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You need to log in to view your profile'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Return to home to login
                    },
                    child: const Text('Go to Login'),
                  ),
                ],
              ),
            )
          : _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadProfile,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _buildProfileWithTabs(),
    );
  }

  Widget _buildProfileWithTabs() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 60), // Space for avatar overflow
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      _buildStatItem('Posts', _profileData?['postsCount'] ?? 0),
                      const SizedBox(width: 24),
                      _buildStatItem('Following', _profileData?['followsCount'] ?? 0),
                      const SizedBox(width: 24),
                      _buildStatItem('Followers', _profileData?['followersCount'] ?? 0),
                    ],
                  ),
                ),
                if (_profileData?['description'] != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(_profileData!['description']),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Posts'),
                  Tab(text: 'Replies'),
                  Tab(text: 'Media'),
                  Tab(text: 'Likes'),
                ],
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).primaryColor,
              ),
            ),
            pinned: true,
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          // Posts Tab
          _buildPostsList(_posts, _isLoadingPosts, _loadUserPosts),
          
          // Replies Tab
          _buildPostsList(_replies, _isLoadingReplies, _loadUserReplies),
          
          // Media Tab
          _buildPostsList(_media, _isLoadingMedia, _loadUserMedia),
          
          // Likes Tab
          _buildPostsList(_likes, _isLoadingLikes, _loadUserLikes),
        ],
      ),
    );
  }

  Widget _buildPostsList(List<BlueskyPost> posts, bool isLoading, Function() onRefresh) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No posts to display'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRefresh,
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: posts.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return PostCard(
            post: posts[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailScreen(post: posts[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Banner image
        Container(
          height: 150,
          width: double.infinity,
          color: Colors.blueGrey[800],
          child: _profileData?['banner'] != null
              ? Image.network(
                  _profileData!['banner'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(),
                )
              : null,
        ),
        
        // Profile image
        Positioned(
          bottom: -50,
          left: 16,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 4),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: _profileData?['avatar'] != null
                  ? NetworkImage(_profileData!['avatar'])
                  : null,
              child: _profileData?['avatar'] == null
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
          ),
        ),
        
        // Profile name and handle
        Positioned(
          top: 160,
          left: 130,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _profileData?['displayName'] ?? 'No Name',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '@${_profileData?['handle'] ?? 'unknown'}',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}

// Helper class for the persistent tab bar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
