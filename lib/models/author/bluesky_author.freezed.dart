// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bluesky_author.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlueskyAuthor {

 String get did; String get handle; String get displayName; String? get avatar;
/// Create a copy of BlueskyAuthor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlueskyAuthorCopyWith<BlueskyAuthor> get copyWith => _$BlueskyAuthorCopyWithImpl<BlueskyAuthor>(this as BlueskyAuthor, _$identity);

  /// Serializes this BlueskyAuthor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlueskyAuthor&&(identical(other.did, did) || other.did == did)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,did,handle,displayName,avatar);

@override
String toString() {
  return 'BlueskyAuthor(did: $did, handle: $handle, displayName: $displayName, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class $BlueskyAuthorCopyWith<$Res>  {
  factory $BlueskyAuthorCopyWith(BlueskyAuthor value, $Res Function(BlueskyAuthor) _then) = _$BlueskyAuthorCopyWithImpl;
@useResult
$Res call({
 String did, String handle, String displayName, String? avatar
});




}
/// @nodoc
class _$BlueskyAuthorCopyWithImpl<$Res>
    implements $BlueskyAuthorCopyWith<$Res> {
  _$BlueskyAuthorCopyWithImpl(this._self, this._then);

  final BlueskyAuthor _self;
  final $Res Function(BlueskyAuthor) _then;

/// Create a copy of BlueskyAuthor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? did = null,Object? handle = null,Object? displayName = null,Object? avatar = freezed,}) {
  return _then(_self.copyWith(
did: null == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String,handle: null == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _BlueskyAuthor implements BlueskyAuthor {
  const _BlueskyAuthor({required this.did, required this.handle, this.displayName = 'Unknown User', this.avatar});
  factory _BlueskyAuthor.fromJson(Map<String, dynamic> json) => _$BlueskyAuthorFromJson(json);

@override final  String did;
@override final  String handle;
@override@JsonKey() final  String displayName;
@override final  String? avatar;

/// Create a copy of BlueskyAuthor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlueskyAuthorCopyWith<_BlueskyAuthor> get copyWith => __$BlueskyAuthorCopyWithImpl<_BlueskyAuthor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlueskyAuthorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlueskyAuthor&&(identical(other.did, did) || other.did == did)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,did,handle,displayName,avatar);

@override
String toString() {
  return 'BlueskyAuthor(did: $did, handle: $handle, displayName: $displayName, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class _$BlueskyAuthorCopyWith<$Res> implements $BlueskyAuthorCopyWith<$Res> {
  factory _$BlueskyAuthorCopyWith(_BlueskyAuthor value, $Res Function(_BlueskyAuthor) _then) = __$BlueskyAuthorCopyWithImpl;
@override @useResult
$Res call({
 String did, String handle, String displayName, String? avatar
});




}
/// @nodoc
class __$BlueskyAuthorCopyWithImpl<$Res>
    implements _$BlueskyAuthorCopyWith<$Res> {
  __$BlueskyAuthorCopyWithImpl(this._self, this._then);

  final _BlueskyAuthor _self;
  final $Res Function(_BlueskyAuthor) _then;

/// Create a copy of BlueskyAuthor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? did = null,Object? handle = null,Object? displayName = null,Object? avatar = freezed,}) {
  return _then(_BlueskyAuthor(
did: null == did ? _self.did : did // ignore: cast_nullable_to_non_nullable
as String,handle: null == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
