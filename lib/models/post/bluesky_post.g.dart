// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bluesky_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlueskyPost _$BlueskyPostFromJson(Map<String, dynamic> json) => _BlueskyPost(
  uri: json['uri'] as String,
  cid: json['cid'] as String,
  author: BlueskyAuthor.fromJson(json['author'] as Map<String, dynamic>),
  record: PostRecord.fromJson(json['record'] as Map<String, dynamic>),
  replyCount: (json['replyCount'] as num?)?.toInt() ?? 0,
  repostCount: (json['repostCount'] as num?)?.toInt() ?? 0,
  likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
  quoteCount: (json['quoteCount'] as num?)?.toInt() ?? 0,
  indexedAt: DateTime.parse(json['indexedAt'] as String),
  reply:
      json['reply'] == null
          ? null
          : BlueskyReply.fromJson(json['reply'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BlueskyPostToJson(_BlueskyPost instance) =>
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
      'reply': instance.reply,
    };
