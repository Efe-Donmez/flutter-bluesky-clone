// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bluesky_reply.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlueskyReply {

 BlueskyPostView get root; BlueskyPostView get parent; BlueskyAuthor? get grandparentAuthor;
/// Create a copy of BlueskyReply
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlueskyReplyCopyWith<BlueskyReply> get copyWith => _$BlueskyReplyCopyWithImpl<BlueskyReply>(this as BlueskyReply, _$identity);

  /// Serializes this BlueskyReply to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlueskyReply&&(identical(other.root, root) || other.root == root)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.grandparentAuthor, grandparentAuthor) || other.grandparentAuthor == grandparentAuthor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,root,parent,grandparentAuthor);

@override
String toString() {
  return 'BlueskyReply(root: $root, parent: $parent, grandparentAuthor: $grandparentAuthor)';
}


}

/// @nodoc
abstract mixin class $BlueskyReplyCopyWith<$Res>  {
  factory $BlueskyReplyCopyWith(BlueskyReply value, $Res Function(BlueskyReply) _then) = _$BlueskyReplyCopyWithImpl;
@useResult
$Res call({
 BlueskyPostView root, BlueskyPostView parent, BlueskyAuthor? grandparentAuthor
});


$BlueskyPostViewCopyWith<$Res> get root;$BlueskyPostViewCopyWith<$Res> get parent;$BlueskyAuthorCopyWith<$Res>? get grandparentAuthor;

}
/// @nodoc
class _$BlueskyReplyCopyWithImpl<$Res>
    implements $BlueskyReplyCopyWith<$Res> {
  _$BlueskyReplyCopyWithImpl(this._self, this._then);

  final BlueskyReply _self;
  final $Res Function(BlueskyReply) _then;

/// Create a copy of BlueskyReply
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? root = null,Object? parent = null,Object? grandparentAuthor = freezed,}) {
  return _then(_self.copyWith(
root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as BlueskyPostView,parent: null == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as BlueskyPostView,grandparentAuthor: freezed == grandparentAuthor ? _self.grandparentAuthor : grandparentAuthor // ignore: cast_nullable_to_non_nullable
as BlueskyAuthor?,
  ));
}
/// Create a copy of BlueskyReply
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlueskyPostViewCopyWith<$Res> get root {
  
  return $BlueskyPostViewCopyWith<$Res>(_self.root, (value) {
    return _then(_self.copyWith(root: value));
  });
}/// Create a copy of BlueskyReply
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlueskyPostViewCopyWith<$Res> get parent {
  
  return $BlueskyPostViewCopyWith<$Res>(_self.parent, (value) {
    return _then(_self.copyWith(parent: value));
  });
}/// Create a copy of BlueskyReply
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlueskyAuthorCopyWith<$Res>? get grandparentAuthor {
    if (_self.grandparentAuthor == null) {
    return null;
  }

  return $BlueskyAuthorCopyWith<$Res>(_self.grandparentAuthor!, (value) {
    return _then(_self.copyWith(grandparentAuthor: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _BlueskyReply implements BlueskyReply {
  const _BlueskyReply({required this.root, required this.parent, this.grandparentAuthor});
  factory _BlueskyReply.fromJson(Map<String, dynamic> json) => _$BlueskyReplyFromJson(json);

@override final  BlueskyPostView root;
@override final  BlueskyPostView parent;
@override final  BlueskyAuthor? grandparentAuthor;

/// Create a copy of BlueskyReply
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlueskyReplyCopyWith<_BlueskyReply> get copyWith => __$BlueskyReplyCopyWithImpl<_BlueskyReply>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlueskyReplyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlueskyReply&&(identical(other.root, root) || other.root == root)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.grandparentAuthor, grandparentAuthor) || other.grandparentAuthor == grandparentAuthor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,root,parent,grandparentAuthor);

@override
String toString() {
  return 'BlueskyReply(root: $root, parent: $parent, grandparentAuthor: $grandparentAuthor)';
}


}

/// @nodoc
abstract mixin class _$BlueskyReplyCopyWith<$Res> implements $BlueskyReplyCopyWith<$Res> {
  factory _$BlueskyReplyCopyWith(_BlueskyReply value, $Res Function(_BlueskyReply) _then) = __$BlueskyReplyCopyWithImpl;
@override @useResult
$Res call({
 BlueskyPostView root, BlueskyPostView parent, BlueskyAuthor? grandparentAuthor
});


@override $BlueskyPostViewCopyWith<$Res> get root;@override $BlueskyPostViewCopyWith<$Res> get parent;@override $BlueskyAuthorCopyWith<$Res>? get grandparentAuthor;

}
/// @nodoc
class __$BlueskyReplyCopyWithImpl<$Res>
    implements _$BlueskyReplyCopyWith<$Res> {
  __$BlueskyReplyCopyWithImpl(this._self, this._then);

  final _BlueskyReply _self;
  final $Res Function(_BlueskyReply) _then;

/// Create a copy of BlueskyReply
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? root = null,Object? parent = null,Object? grandparentAuthor = freezed,}) {
  return _then(_BlueskyReply(
root: null == root ? _self.root : root // ignore: cast_nullable_to_non_nullable
as BlueskyPostView,parent: null == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as BlueskyPostView,grandparentAuthor: freezed == grandparentAuthor ? _self.grandparentAuthor : grandparentAuthor // ignore: cast_nullable_to_non_nullable
as BlueskyAuthor?,
  ));
}

/// Create a copy of BlueskyReply
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlueskyPostViewCopyWith<$Res> get root {
  
  return $BlueskyPostViewCopyWith<$Res>(_self.root, (value) {
    return _then(_self.copyWith(root: value));
  });
}/// Create a copy of BlueskyReply
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlueskyPostViewCopyWith<$Res> get parent {
  
  return $BlueskyPostViewCopyWith<$Res>(_self.parent, (value) {
    return _then(_self.copyWith(parent: value));
  });
}/// Create a copy of BlueskyReply
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlueskyAuthorCopyWith<$Res>? get grandparentAuthor {
    if (_self.grandparentAuthor == null) {
    return null;
  }

  return $BlueskyAuthorCopyWith<$Res>(_self.grandparentAuthor!, (value) {
    return _then(_self.copyWith(grandparentAuthor: value));
  });
}
}


/// @nodoc
mixin _$BlueskyPostView {

 String get uri; String get cid; BlueskyAuthor get author; PostRecord get record; int get replyCount; int get repostCount; int get likeCount; int get quoteCount; DateTime get indexedAt; String? get type;
/// Create a copy of BlueskyPostView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlueskyPostViewCopyWith<BlueskyPostView> get copyWith => _$BlueskyPostViewCopyWithImpl<BlueskyPostView>(this as BlueskyPostView, _$identity);

  /// Serializes this BlueskyPostView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlueskyPostView&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.cid, cid) || other.cid == cid)&&(identical(other.author, author) || other.author == author)&&(identical(other.record, record) || other.record == record)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.repostCount, repostCount) || other.repostCount == repostCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.quoteCount, quoteCount) || other.quoteCount == quoteCount)&&(identical(other.indexedAt, indexedAt) || other.indexedAt == indexedAt)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uri,cid,author,record,replyCount,repostCount,likeCount,quoteCount,indexedAt,type);

@override
String toString() {
  return 'BlueskyPostView(uri: $uri, cid: $cid, author: $author, record: $record, replyCount: $replyCount, repostCount: $repostCount, likeCount: $likeCount, quoteCount: $quoteCount, indexedAt: $indexedAt, type: $type)';
}


}

/// @nodoc
abstract mixin class $BlueskyPostViewCopyWith<$Res>  {
  factory $BlueskyPostViewCopyWith(BlueskyPostView value, $Res Function(BlueskyPostView) _then) = _$BlueskyPostViewCopyWithImpl;
@useResult
$Res call({
 String uri, String cid, BlueskyAuthor author, PostRecord record, int replyCount, int repostCount, int likeCount, int quoteCount, DateTime indexedAt, String? type
});


$BlueskyAuthorCopyWith<$Res> get author;$PostRecordCopyWith<$Res> get record;

}
/// @nodoc
class _$BlueskyPostViewCopyWithImpl<$Res>
    implements $BlueskyPostViewCopyWith<$Res> {
  _$BlueskyPostViewCopyWithImpl(this._self, this._then);

  final BlueskyPostView _self;
  final $Res Function(BlueskyPostView) _then;

/// Create a copy of BlueskyPostView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uri = null,Object? cid = null,Object? author = null,Object? record = null,Object? replyCount = null,Object? repostCount = null,Object? likeCount = null,Object? quoteCount = null,Object? indexedAt = null,Object? type = freezed,}) {
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
as DateTime,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of BlueskyPostView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlueskyAuthorCopyWith<$Res> get author {
  
  return $BlueskyAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of BlueskyPostView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostRecordCopyWith<$Res> get record {
  
  return $PostRecordCopyWith<$Res>(_self.record, (value) {
    return _then(_self.copyWith(record: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _BlueskyPostView implements BlueskyPostView {
  const _BlueskyPostView({required this.uri, required this.cid, required this.author, required this.record, this.replyCount = 0, this.repostCount = 0, this.likeCount = 0, this.quoteCount = 0, required this.indexedAt, this.type = "app.bsky.feed.defs#postView"});
  factory _BlueskyPostView.fromJson(Map<String, dynamic> json) => _$BlueskyPostViewFromJson(json);

@override final  String uri;
@override final  String cid;
@override final  BlueskyAuthor author;
@override final  PostRecord record;
@override@JsonKey() final  int replyCount;
@override@JsonKey() final  int repostCount;
@override@JsonKey() final  int likeCount;
@override@JsonKey() final  int quoteCount;
@override final  DateTime indexedAt;
@override@JsonKey() final  String? type;

/// Create a copy of BlueskyPostView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlueskyPostViewCopyWith<_BlueskyPostView> get copyWith => __$BlueskyPostViewCopyWithImpl<_BlueskyPostView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlueskyPostViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlueskyPostView&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.cid, cid) || other.cid == cid)&&(identical(other.author, author) || other.author == author)&&(identical(other.record, record) || other.record == record)&&(identical(other.replyCount, replyCount) || other.replyCount == replyCount)&&(identical(other.repostCount, repostCount) || other.repostCount == repostCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.quoteCount, quoteCount) || other.quoteCount == quoteCount)&&(identical(other.indexedAt, indexedAt) || other.indexedAt == indexedAt)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uri,cid,author,record,replyCount,repostCount,likeCount,quoteCount,indexedAt,type);

@override
String toString() {
  return 'BlueskyPostView(uri: $uri, cid: $cid, author: $author, record: $record, replyCount: $replyCount, repostCount: $repostCount, likeCount: $likeCount, quoteCount: $quoteCount, indexedAt: $indexedAt, type: $type)';
}


}

/// @nodoc
abstract mixin class _$BlueskyPostViewCopyWith<$Res> implements $BlueskyPostViewCopyWith<$Res> {
  factory _$BlueskyPostViewCopyWith(_BlueskyPostView value, $Res Function(_BlueskyPostView) _then) = __$BlueskyPostViewCopyWithImpl;
@override @useResult
$Res call({
 String uri, String cid, BlueskyAuthor author, PostRecord record, int replyCount, int repostCount, int likeCount, int quoteCount, DateTime indexedAt, String? type
});


@override $BlueskyAuthorCopyWith<$Res> get author;@override $PostRecordCopyWith<$Res> get record;

}
/// @nodoc
class __$BlueskyPostViewCopyWithImpl<$Res>
    implements _$BlueskyPostViewCopyWith<$Res> {
  __$BlueskyPostViewCopyWithImpl(this._self, this._then);

  final _BlueskyPostView _self;
  final $Res Function(_BlueskyPostView) _then;

/// Create a copy of BlueskyPostView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uri = null,Object? cid = null,Object? author = null,Object? record = null,Object? replyCount = null,Object? repostCount = null,Object? likeCount = null,Object? quoteCount = null,Object? indexedAt = null,Object? type = freezed,}) {
  return _then(_BlueskyPostView(
uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,cid: null == cid ? _self.cid : cid // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as BlueskyAuthor,record: null == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as PostRecord,replyCount: null == replyCount ? _self.replyCount : replyCount // ignore: cast_nullable_to_non_nullable
as int,repostCount: null == repostCount ? _self.repostCount : repostCount // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,quoteCount: null == quoteCount ? _self.quoteCount : quoteCount // ignore: cast_nullable_to_non_nullable
as int,indexedAt: null == indexedAt ? _self.indexedAt : indexedAt // ignore: cast_nullable_to_non_nullable
as DateTime,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of BlueskyPostView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlueskyAuthorCopyWith<$Res> get author {
  
  return $BlueskyAuthorCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}/// Create a copy of BlueskyPostView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostRecordCopyWith<$Res> get record {
  
  return $PostRecordCopyWith<$Res>(_self.record, (value) {
    return _then(_self.copyWith(record: value));
  });
}
}

// dart format on
