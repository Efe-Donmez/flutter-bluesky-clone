import 'package:bluesky_viewer/models/author/bluesky_author.dart';
import 'package:bluesky_viewer/models/record/post_record.dart';
import 'package:bluesky_viewer/models/reply/bluesky_reply.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'bluesky_post.freezed.dart';
part 'bluesky_post.g.dart';

/// Represents a post on Bluesky social network
@freezed
abstract class BlueskyPost with _$BlueskyPost {
  const factory BlueskyPost({
    required String uri,
    required String cid,
    required BlueskyAuthor author,
    required PostRecord record,
    @Default(0) int replyCount,
    @Default(0) int repostCount,
    @Default(0) int likeCount,
    @Default(0) int quoteCount,
    required DateTime indexedAt,
    BlueskyReply? reply,
  }) = _BlueskyPost;

  /// Creates a BlueskyPost from JSON data
  factory BlueskyPost.fromJson(Map<String, dynamic> json) => 
      _$BlueskyPostFromJson(_preprocessJson(json));
  
  /// Preprocesses the JSON to handle different incoming formats
  static Map<String, dynamic> _preprocessJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('post') && json['post'] is Map<String, dynamic>) {
        return json['post'] as Map<String, dynamic>;
      }
      return json;
    } catch (e) {
      print('Error preprocessing BlueskyPost JSON: $e');
      return _createErrorPost();
    }
  }
  
  /// Creates a fallback post when there's an error
  static Map<String, dynamic> _createErrorPost() {
    final now = DateTime.now().toIso8601String();
    return {
      'uri': "",
      'cid': "",
      'author': const {'did': "", 'handle': ""},
      'record': {'text': "Error loading post", 'createdAt': now},
      'indexedAt': now,
    };
  }
}

/// Extension for formatting post dates in a human-readable way
extension BlueskyPostDate on BlueskyPost {
  /// Returns a formatted relative date string 
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(indexedAt);

    if (difference.inDays > 365) {
      return DateFormat('MMM d, y').format(indexedAt);
    } else if (difference.inDays > 30) {
      return DateFormat('MMM d').format(indexedAt);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'just now';
    }
  }
}
