import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_record.freezed.dart';
part 'post_record.g.dart';

@freezed
abstract class PostRecord with _$PostRecord {
  const factory PostRecord({
    @JsonKey(name: '\$type') @Default('app.bsky.feed.post') String type,
    required String text,
    required DateTime createdAt,
    List<String>? langs,
  }) = _PostRecord;

  factory PostRecord.fromJson(Map<String, dynamic> json) =>
      _$PostRecordFromJson(json);
}
