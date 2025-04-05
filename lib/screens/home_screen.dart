import 'package:bluesky_viewer/screens/post_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluesky_viewer/models/post/bluesky_post.dart';
import 'package:bluesky_viewer/providers/bluesky_provider.dart';
import 'package:bluesky_viewer/widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    
    // Check for saved credentials and try to load timeline
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BlueskyProvider>(context, listen: false);
      // Load likes and timeline if authenticated
      if (provider.isAuthenticated) {
        provider.loadUserLikes().then((_) => provider.fetchTimeline());
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Use timeline fetching instead of home feed
              context.read<BlueskyProvider>().fetchTimeline();
            },
          ),
        ],
      ),
      body: Consumer<BlueskyProvider>(
        builder: (context, provider, child) {
          // Show loading state
          if (provider.state == LoadingState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // Show login form if not authenticated
          if (!provider.isAuthenticated) {
            return _buildLoginForm(provider);
          }
          
          // Show error if there is one
          if (provider.state == LoadingState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchTimeline(),
                    child: const Text('Retry'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => provider.logout(),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          }
          
          // Show posts
          final posts = provider.posts;
          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No posts to display'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchTimeline(),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () => provider.fetchTimeline(),
            child: ListView.separated(
              itemCount: posts.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return PostCard(
                  post: posts[index],
                  onTap: () {
                    // Navigate to post detail screen
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
        },
      ),
    );
  }

  Widget _buildLoginForm(BlueskyProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Sign in to Bluesky',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username or Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: provider.state == LoadingState.loading
                ? null
                : () async {
                    // Use the direct login method instead
                    final success = await provider.login(
                      _usernameController.text,
                      _passwordController.text,
                    );
                    
                    if (!success && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(provider.error)),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: provider.state == LoadingState.loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : const Text('Sign In'),
          ),
          
          // Show error message if there is one
          if (provider.error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                provider.error,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}