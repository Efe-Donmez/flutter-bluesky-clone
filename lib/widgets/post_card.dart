import 'package:bluesky_viewer/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:bluesky_viewer/models/post/bluesky_post.dart';
import 'package:provider/provider.dart';
import 'package:bluesky_viewer/providers/bluesky_provider.dart';

class PostCard extends StatelessWidget {
  final BlueskyPost post;
  final Function()? onTap;

  const PostCard({
    Key? key,
    required this.post,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<BlueskyProvider>(context);
    final isLiked = provider.isPostLiked(post.uri);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
      elevation: 0,
      color: theme.colorScheme.background, // Use background color from the theme
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Make avatar tappable to open user profile
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(handle: post.author.handle),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: post.author.avatar != null 
                          ? NetworkImage(post.author.avatar!) 
                          : null,
                      backgroundColor: theme.colorScheme.surface,
                      child: post.author.avatar == null
                          ? Icon(Icons.person, color: theme.colorScheme.onSurface)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(handle: post.author.handle),
                                    ),
                                  );
                                },
                                child: Text(
                                  post.author.displayName ?? post.author.handle,
                                  style: theme.textTheme.titleSmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(handle: post.author.handle),
                                  ),
                                );
                              },
                              child: Text(
                                '@${post.author.handle}',
                                style: theme.textTheme.labelMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '· ${post.formattedDate}',
                              style: theme.textTheme.labelMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          post.record.text,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildActionButton(
                              icon: Icons.chat_bubble_outline,
                              count: post.replyCount,
                              theme: theme,
                            ),
                            _buildActionButton(
                              icon: Icons.repeat,
                              count: post.repostCount,
                              theme: theme,
                            ),
                            _buildActionButton(
                              icon: isLiked ? Icons.favorite : Icons.favorite_border,
                              count: post.likeCount,
                              theme: theme,
                              color: isLiked ? Colors.red : null,
                              onTap: () async {
                                await provider.togglePostLike(post);
                              },
                            ),
                            _buildActionButton(
                              icon: Icons.bar_chart,
                              theme: theme,
                            ),
                            _buildActionButton(
                              icon: Icons.share_outlined,
                              theme: theme,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    int? count,
    required ThemeData theme,
    Color? color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: color ?? theme.textTheme.labelMedium?.color,
            ),
            if (count != null)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  count.toString(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: color,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
