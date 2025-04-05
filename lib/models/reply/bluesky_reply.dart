import 'package:bluesky_viewer/models/author/bluesky_author.dart';
import 'package:bluesky_viewer/models/record/post_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../post/bluesky_post.dart';

part 'bluesky_reply.freezed.dart';
part 'bluesky_reply.g.dart';

@freezed
abstract class BlueskyReply with _$BlueskyReply {
  const factory BlueskyReply({
    required BlueskyPostView root,
    required BlueskyPostView parent,
    BlueskyAuthor? grandparentAuthor,
  }) = _BlueskyReply;

  factory BlueskyReply.fromJson(Map<String, dynamic> json) => 
      _$BlueskyReplyFromJson(json);
}

@freezed
abstract class BlueskyPostView with _$BlueskyPostView {
  const factory BlueskyPostView({
    required String uri,
    required String cid,
    required BlueskyAuthor author,
    required PostRecord record,
    @Default(0) int replyCount,
    @Default(0) int repostCount,
    @Default(0) int likeCount,
    @Default(0) int quoteCount,
    required DateTime indexedAt,
    @Default("app.bsky.feed.defs#postView") String? type,
  }) = _BlueskyPostView;

  factory BlueskyPostView.fromJson(Map<String, dynamic> json) => 
      _$BlueskyPostViewFromJson(json);
}
