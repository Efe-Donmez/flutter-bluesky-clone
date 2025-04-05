import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post/bluesky_post.dart';
import '../models/reply/bluesky_reply.dart';

class PostWidget extends StatelessWidget {
  final BlueskyPost post;
  final bool showReplyContext;

  const PostWidget({
    super.key, 
    required this.post, 
    this.showReplyContext = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show reply context if available and requested
          if (showReplyContext && post.reply != null)
            _buildReplyContext(context),
          
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: post.author.avatar != null
                          ? CachedNetworkImageProvider(post.author.avatar!)
                          : null,
                      child: post.author.avatar == null
                          ? Text(
                              post.author.displayName.isNotEmpty
                                  ? post.author.displayName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    // Author name and handle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.author.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '@${post.author.handle}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Post time
                    Text(
                      post.formattedDate,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Post content
                Text(
                  post.record.text,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                // Post stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStat(Icons.chat_bubble_outline, post.replyCount),
                    _buildStat(Icons.repeat, post.repostCount),
                    _buildStat(Icons.favorite_border, post.likeCount),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share_outlined, size: 18),
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildReplyContext(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.reply,
            size: 16,
            color: Colors.grey,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
                children: [
                  TextSpan(
                    text: 'Replying to ',
                  ),
                  TextSpan(
                    text: '@${post.reply?.parent.author.handle ?? ""}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, int count) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(icon, size: 18),
          color: Colors.grey,
        ),
        if (count > 0)
          Text(
            count.toString(),
            style: const TextStyle(color: Colors.grey),
          ),
      ],
    );
  }
}