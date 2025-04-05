// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostRecord _$PostRecordFromJson(Map<String, dynamic> json) => _PostRecord(
  type: json[r'$type'] as String? ?? 'app.bsky.feed.post',
  text: json['text'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  langs: (json['langs'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$PostRecordToJson(_PostRecord instance) =>
    <String, dynamic>{
      r'$type': instance.type,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
      'langs': instance.langs,
    };
