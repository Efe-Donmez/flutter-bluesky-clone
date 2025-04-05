// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostRecord {

@JsonKey(name: '\$type') String get type; String get text; DateTime get createdAt; List<String>? get langs;
/// Create a copy of PostRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostRecordCopyWith<PostRecord> get copyWith => _$PostRecordCopyWithImpl<PostRecord>(this as PostRecord, _$identity);

  /// Serializes this PostRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostRecord&&(identical(other.type, type) || other.type == type)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.langs, langs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,text,createdAt,const DeepCollectionEquality().hash(langs));

@override
String toString() {
  return 'PostRecord(type: $type, text: $text, createdAt: $createdAt, langs: $langs)';
}


}

/// @nodoc
abstract mixin class $PostRecordCopyWith<$Res>  {
  factory $PostRecordCopyWith(PostRecord value, $Res Function(PostRecord) _then) = _$PostRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '\$type') String type, String text, DateTime createdAt, List<String>? langs
});




}
/// @nodoc
class _$PostRecordCopyWithImpl<$Res>
    implements $PostRecordCopyWith<$Res> {
  _$PostRecordCopyWithImpl(this._self, this._then);

  final PostRecord _self;
  final $Res Function(PostRecord) _then;

/// Create a copy of PostRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? text = null,Object? createdAt = null,Object? langs = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,langs: freezed == langs ? _self.langs : langs // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PostRecord implements PostRecord {
  const _PostRecord({@JsonKey(name: '\$type') this.type = 'app.bsky.feed.post', required this.text, required this.createdAt, final  List<String>? langs}): _langs = langs;
  factory _PostRecord.fromJson(Map<String, dynamic> json) => _$PostRecordFromJson(json);

@override@JsonKey(name: '\$type') final  String type;
@override final  String text;
@override final  DateTime createdAt;
 final  List<String>? _langs;
@override List<String>? get langs {
  final value = _langs;
  if (value == null) return null;
  if (_langs is EqualUnmodifiableListView) return _langs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of PostRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostRecordCopyWith<_PostRecord> get copyWith => __$PostRecordCopyWithImpl<_PostRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostRecord&&(identical(other.type, type) || other.type == type)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._langs, _langs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,text,createdAt,const DeepCollectionEquality().hash(_langs));

@override
String toString() {
  return 'PostRecord(type: $type, text: $text, createdAt: $createdAt, langs: $langs)';
}


}

/// @nodoc
abstract mixin class _$PostRecordCopyWith<$Res> implements $PostRecordCopyWith<$Res> {
  factory _$PostRecordCopyWith(_PostRecord value, $Res Function(_PostRecord) _then) = __$PostRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '\$type') String type, String text, DateTime createdAt, List<String>? langs
});




}
/// @nodoc
class __$PostRecordCopyWithImpl<$Res>
    implements _$PostRecordCopyWith<$Res> {
  __$PostRecordCopyWithImpl(this._self, this._then);

  final _PostRecord _self;
  final $Res Function(_PostRecord) _then;

/// Create a copy of PostRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? text = null,Object? createdAt = null,Object? langs = freezed,}) {
  return _then(_PostRecord(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,langs: freezed == langs ? _self._langs : langs // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
