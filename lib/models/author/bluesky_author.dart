import 'package:freezed_annotation/freezed_annotation.dart';

part 'bluesky_author.freezed.dart';
part 'bluesky_author.g.dart';

@freezed
abstract class BlueskyAuthor with _$BlueskyAuthor {
  const factory BlueskyAuthor({
    required String did,
    required String handle,
    @Default('Unknown User') String displayName,
    String? avatar,
  }) = _BlueskyAuthor;

  factory BlueskyAuthor.fromJson(Map<String, dynamic> json) =>
      _$BlueskyAuthorFromJson(json);
}
