import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluesky_viewer/models/post/bluesky_post.dart';
import 'package:bluesky_viewer/providers/bluesky_provider.dart';
import 'package:bluesky_viewer/widgets/post_card.dart';

class PostDetailScreen extends StatefulWidget {
  final BlueskyPost post;

  const PostDetailScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool _isLoadingReplies = false;
  List<BlueskyPost> _replies = [];
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadReplies();
    
    // Load user likes when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BlueskyProvider>(context, listen: false);
      provider.loadUserLikes();
    });
  }

  Future<void> _loadReplies() async {
    if (!mounted) return;
    
    setState(() {
      _isLoadingReplies = true;
      _error = '';
    });
    
    try {
      final provider = Provider.of<BlueskyProvider>(context, listen: false);
      
      // Load replies to this post
      final replies = await provider.getPostReplies(widget.post.uri);
      
      if (mounted) {
        setState(() {
          _replies = replies;
          _isLoadingReplies = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load replies: $e';
          _isLoadingReplies = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Main post with extra detail
          _buildMainPost(),
          
          // Divider between post and replies
          const Divider(height: 1, thickness: 1),
          
          // Replies section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Replies',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                if (_isLoadingReplies)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
          
          // Error message if any
          if (_error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _error,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          
          // Replies list
          Expanded(
            child: _isLoadingReplies
                ? const Center(child: CircularProgressIndicator())
                : _replies.isEmpty
                    ? const Center(child: Text('No replies yet'))
                    : ListView.separated(
                        itemCount: _replies.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          return PostCard(
                            post: _replies[index],
                            onTap: () {
                              // Navigate to this reply's detail
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetailScreen(post: _replies[index]),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }

  Widget _buildMainPost() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: widget.post.author.avatar != null
                    ? NetworkImage(widget.post.author.avatar!)
                    : null,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: widget.post.author.avatar == null
                    ? Icon(Icons.person, color: Theme.of(context).colorScheme.onSurface)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.author.displayName ?? widget.post.author.handle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '@${widget.post.author.handle}',
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Post content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              widget.post.record.text,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          
          // Date and app info
          Text(
            widget.post.formattedDate,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          
          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                _buildStat('${widget.post.replyCount}', 'Replies',Icons.subdirectory_arrow_left_rounded),
                const SizedBox(width: 24),
                _buildStat('${widget.post.repostCount}', 'Reposts',Icons.post_add_rounded),
                const SizedBox(width: 24),
                _buildStat('${widget.post.likeCount}', 'Likes',Icons.favorite_border_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String count, String label,IconData icon) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Icon(
            icon,
            size: 18,
            color: Colors.grey[500],
          ),
        ),
        Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    final provider = Provider.of<BlueskyProvider>(context);
    final isLiked = provider.isPostLiked(widget.post.uri);
    
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[800]!, width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              icon: Icons.chat_bubble_outline,
              label: 'Reply',
              onTap: () {
                // Show reply dialog
                _showReplyDialog();
              },
            ),
            _buildActionButton(
              icon: Icons.repeat,
              label: 'Repost',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Repost functionality coming soon')),
                );
              },
            ),
            _buildActionButton(
              icon: isLiked ? Icons.favorite : Icons.favorite_border,
              label: 'Like',
              color: isLiked ? Colors.red : null,
              onTap: () {
                _toggleLike();
              },
            ),
            _buildActionButton(
              icon: Icons.share_outlined,
              label: 'Share',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share functionality coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(
              label, 
              style: TextStyle(
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Add this new method to handle like toggling
  Future<void> _toggleLike() async {
    try {
      final provider = Provider.of<BlueskyProvider>(context, listen: false);
      final success = await provider.togglePostLike(widget.post);
      
      if (!success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to toggle like status')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showReplyDialog() {
    final TextEditingController _replyController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reply',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _replyController,
                decoration: const InputDecoration(
                  hintText: 'Type your reply...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                autofocus: true,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Send reply
                      // provider.replyToPost(widget.post.uri, _replyController.text);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reply functionality coming soon')),
                      );
                    },
                    child: const Text('Reply'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
