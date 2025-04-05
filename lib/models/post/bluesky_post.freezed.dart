// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bluesky_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlueskyPost {

 String get uri; String get cid; BlueskyAuthor get author; PostRecord get record; int get replyCount; int get repostCount; int get likeCount; int get quoteCount; DateTime get indexedAt; BlueskyReply? get reply;
/// Create a copy of BlueskyPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlueskyPostCopyWith<BlueskyPost> get copyWith => _$BlueskyPostCopyWithImpl<BlueskyPost>(this as BlueskyPost, _$identity);

  /// Serializes this BlueskyPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlueskyPost&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.cid, cid) || other.cid == cid)&&(identical(other.author, author) || other.author == author)&&(identical(other.record, record) || other.record == record)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.repostCount, repostCount) || other.repostCount == repostCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.quoteCount, quoteCount) || other.quoteCount == quoteCount)&&(identical(other.indexedAt, indexedAt) || other.indexedAt == indexedAt)&&(identical(other.reply, reply) || other.reply == reply));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uri,cid,author,record,replyCount,repostCount,likeCount,quoteCount,indexedAt,reply);

@override
String toString() {
  return 'BlueskyPost(uri: $uri, cid: $cid, author: $author, record: $record, replyCount: $replyCount, repostCount: $repostCount, likeCount: $likeCount, quoteCount: $quoteCount, indexedAt: $indexedAt, reply: $reply)';
}


}

/// @nodoc
abstract mixin class $BlueskyPostCopyWith<$Res>  {
  factory $BlueskyPostCopyWith(BlueskyPost value, $Res Function(BlueskyPost) _then) = _$BlueskyPostCopyWithImpl;
@useResult
$Res call({
 String uri, String cid, BlueskyAuthor author, PostRecord record, int replyCount, int repostCount, int likeCount, int quoteCount, DateTime indexedAt, BlueskyReply? reply
});


$BlueskyAuthorCopyWith<$Res> get author;$PostRecordCopyWith<$Res> get record;$BlueskyReplyCopyWith<$Res>? get reply;

}
/// @nodoc
class _$BlueskyPostCopyWithImpl<$Res>
    implements $BlueskyPostCopyWith<$Res> {
  _$BlueskyPostCopyWithImpl(this._self, this._then);

  final BlueskyPost _self;
  final $Res Function(BlueskyPost) _then;

/// Create a copy of BlueskyPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uri = null,Object? cid = null,Object? author = null,Object? record = null,Object? replyCount = null,Object? repostCount = null,Object? likeCount = null,Object? quoteCount = null,Object? indexedAt = null,Object? reply = freezed,}) {
  return _then(_self.copyWith(
uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,cid: null == cid ? _self.cid : cid // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as BlueskyAuthor,record: null == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as PostRecord,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,repostCount: null == repostCount ? _self.repostCount : repostCount // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,quoteCount: null == quoteCount ? _self.quoteCount : quoteCount // ignore: cast_nullable_to_non_nullable
as int,indexedAt: null == indexedAt ? _self.indexedAt : indexedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reply: freezed == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as BlueskyReply?,
  ));
}
/// Create a copy of BlueskyPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlueskyAuthorCopyWith<$Res> get author {
  
  return $BlueskyAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of BlueskyPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostRecordCopyWith<$Res> get record {
  
  return $PostRecordCopyWith<$Res>(_self.record, (value) {
    return _then(_self.copyWith(record: value));
  });
}/// Create a copy of BlueskyPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlueskyReplyCopyWith<$Res>? get reply {
    if (_self.reply == null) {
    return null;
  }

  return $BlueskyReplyCopyWith<$Res>(_self.reply!, (value) {
    return _then(_self.copyWith(reply: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _BlueskyPost implements BlueskyPost {
  const _BlueskyPost({required this.uri, required this.cid, required this.author, required this.record, this.replyCount = 0, this.repostCount = 0, this.likeCount = 0, this.quoteCount = 0, required this.indexedAt, this.reply});
  factory _BlueskyPost.fromJson(Map<String, dynamic> json) => _$BlueskyPostFromJson(json);

@override final  String uri;
@override final  String cid;
@override final  BlueskyAuthor author;
@override final  PostRecord record;
@override@JsonKey() final  int replyCount;
@override@JsonKey() final  int repostCount;
@override@JsonKey() final  int likeCount;
@override@JsonKey() final  int quoteCount;
@override final  DateTime indexedAt;
@override final  BlueskyReply? reply;

/// Create a copy of BlueskyPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlueskyPostCopyWith<_BlueskyPost> get copyWith => __$BlueskyPostCopyWithImpl<_BlueskyPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlueskyPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlueskyPost&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.cid, cid) || other.cid == cid)&&(identical(other.author, author) || other.author == author)&&(identical(other.record, record) || other.record == record)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.repostCount, repostCount) || other.repostCount == repostCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.quoteCount, quoteCount) || other.quoteCount == quoteCount)&&(identical(other.indexedAt, indexedAt) || other.indexedAt == indexedAt)&&(identical(other.reply, reply) || other.reply == reply));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uri,cid,author,record,replyCount,repostCount,likeCount,quoteCount,indexedAt,reply);

@override
String toString() {
  return 'BlueskyPost(uri: $uri, cid: $cid, author: $author, record: $record, replyCount: $replyCount, repostCount: $repostCount, likeCount: $likeCount, quoteCount: $quoteCount, indexedAt: $indexedAt, reply: $reply)';
}


}

/// @nodoc
abstract mixin class _$BlueskyPostCopyWith<$Res> implements $BlueskyPostCopyWith<$Res> {
  factory _$BlueskyPostCopyWith(_BlueskyPost value, $Res Function(_BlueskyPost) _then) = __$BlueskyPostCopyWithImpl;
@override @useResult
$Res call({
 String uri, String cid, BlueskyAuthor author, PostRecord record, int replyCount, int repostCount, int likeCount, int quoteCount, DateTime indexedAt, BlueskyReply? reply
});


@override $BlueskyAuthorCopyWith<$Res> get author;@override $PostRecordCopyWith<$Res> get record;@override $BlueskyReplyCopyWith<$Res>? get reply;

}
/// @nodoc
class __$BlueskyPostCopyWithImpl<$Res>
    implements _$BlueskyPostCopyWith<$Res> {
  __$BlueskyPostCopyWithImpl(this._self, this._then);

  final _BlueskyPost _self;
  final $Res Function(_BlueskyPost) _then;

/// Create a copy of BlueskyPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uri = null,Object? cid = null,Object? author = null,Object? record = null,Object? replyCount = null,Object? repostCount = null,Object? likeCount = null,Object? quoteCount = null,Object? indexedAt = null,Object? reply = freezed,}) {
  return _then(_BlueskyPost(
uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,cid: null == cid ? _self.cid : cid // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as BlueskyAuthor,record: null == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as PostRecord,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,repostCount: null == repostCount ? _self.repostCount : repostCount // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,quoteCount: null == quoteCount ? _self.quoteCount : quoteCount // ignore: cast_nullable_to_non_nullable
as int,indexedAt: null == indexedAt ? _self.indexedAt : indexedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reply: freezed == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as BlueskyReply?,
  ));
}

/// Create a copy of BlueskyPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlueskyAuthorCopyWith<$Res> get author {
  
  return $BlueskyAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of BlueskyPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostRecordCopyWith<$Res> get record {
  
  return $PostRecordCopyWith<$Res>(_self.record, (value) {
    return _then(_self.copyWith(record: value));
  });
}/// Create a copy of BlueskyPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlueskyReplyCopyWith<$Res>? get reply {
    if (_self.reply == null) {
    return null;
  }

  return $BlueskyReplyCopyWith<$Res>(_self.reply!, (value) {
    return _then(_self.copyWith(reply: value));
  });
}
}

// dart format on
