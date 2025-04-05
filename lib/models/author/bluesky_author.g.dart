// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bluesky_author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlueskyAuthor _$BlueskyAuthorFromJson(Map<String, dynamic> json) =>
    _BlueskyAuthor(
      did: json['did'] as String,
      handle: json['handle'] as String,
      displayName: json['displayName'] as String? ?? 'Unknown User',
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$BlueskyAuthorToJson(_BlueskyAuthor instance) =>
    <String, dynamic>{
      'did': instance.did,
      'handle': instance.handle,
      'displayName': instance.displayName,
      'avatar': instance.avatar,
    };
