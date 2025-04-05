// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bluesky_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlueskyReply _$BlueskyReplyFromJson(Map<String, dynamic> json) =>
    _BlueskyReply(
      root: BlueskyPostView.fromJson(json['root'] as Map<String, dynamic>),
      parent: BlueskyPostView.fromJson(json['parent'] as Map<String, dynamic>),
      grandparentAuthor:
          json['grandparentAuthor'] == null
              ? null
              : BlueskyAuthor.fromJson(
                json['grandparentAuthor'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$BlueskyReplyToJson(_BlueskyReply instance) =>
    <String, dynamic>{
      'root': instance.root,
      'parent': instance.parent,
      'grandparentAuthor': instance.grandparentAuthor,
    };

_BlueskyPostView _$BlueskyPostViewFromJson(Map<String, dynamic> json) =>
    _BlueskyPostView(
      uri: json['uri'] as String,
      cid: json['cid'] as String,
      author: BlueskyAuthor.fromJson(json['author'] as Map<String, dynamic>),
      record: PostRecord.fromJson(json['record'] as Map<String, dynamic>),
      replyCount: (json['replyCount'] as num?)?.toInt() ?? 0,
      repostCount: (json['repostCount'] as num?)?.toInt() ?? 0,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      quoteCount: (json['quoteCount'] as num?)?.toInt() ?? 0,
      indexedAt: DateTime.parse(json['indexedAt'] as String),
      type: json['type'] as String? ?? "app.bsky.feed.defs#postView",
    );

Map<String, dynamic> _$BlueskyPostViewToJson(_BlueskyPostView instance) =>
    <String, dynamic>{
      'uri': instance.uri,
      'cid': instance.cid,
      'author': instance.author,
      'record': instance.record,
      'replyCount': instance.replyCount,
      'repostCount': instance.repostCount,
      'likeCount': instance.likeCount,
      'quoteCount': instance.quoteCount,
      'indexedAt': instance.indexedAt.toIso8601String(),
      'type': instance.type,
    };
