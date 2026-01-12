// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'canvas_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CanvasState _$CanvasStateFromJson(Map<String, dynamic> json) {
  return _CanvasState.fromJson(json);
}

/// @nodoc
mixin _$CanvasState {
  /// Schema version for migration support
  int get version => throw _privateConstructorUsedError;

  /// Viewport center position
  Position get viewportCenter => throw _privateConstructorUsedError;

  /// Zoom level (1.0 = 100%)
  double get zoom => throw _privateConstructorUsedError;

  /// Last modified timestamp
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CanvasState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CanvasStateCopyWith<CanvasState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CanvasStateCopyWith<$Res> {
  factory $CanvasStateCopyWith(
    CanvasState value,
    $Res Function(CanvasState) then,
  ) = _$CanvasStateCopyWithImpl<$Res, CanvasState>;
  @useResult
  $Res call({
    int version,
    Position viewportCenter,
    double zoom,
    DateTime updatedAt,
  });

  $PositionCopyWith<$Res> get viewportCenter;
}

/// @nodoc
class _$CanvasStateCopyWithImpl<$Res, $Val extends CanvasState>
    implements $CanvasStateCopyWith<$Res> {
  _$CanvasStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? viewportCenter = null,
    Object? zoom = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as int,
            viewportCenter: null == viewportCenter
                ? _value.viewportCenter
                : viewportCenter // ignore: cast_nullable_to_non_nullable
                      as Position,
            zoom: null == zoom
                ? _value.zoom
                : zoom // ignore: cast_nullable_to_non_nullable
                      as double,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PositionCopyWith<$Res> get viewportCenter {
    return $PositionCopyWith<$Res>(_value.viewportCenter, (value) {
      return _then(_value.copyWith(viewportCenter: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CanvasStateImplCopyWith<$Res>
    implements $CanvasStateCopyWith<$Res> {
  factory _$$CanvasStateImplCopyWith(
    _$CanvasStateImpl value,
    $Res Function(_$CanvasStateImpl) then,
  ) = __$$CanvasStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int version,
    Position viewportCenter,
    double zoom,
    DateTime updatedAt,
  });

  @override
  $PositionCopyWith<$Res> get viewportCenter;
}

/// @nodoc
class __$$CanvasStateImplCopyWithImpl<$Res>
    extends _$CanvasStateCopyWithImpl<$Res, _$CanvasStateImpl>
    implements _$$CanvasStateImplCopyWith<$Res> {
  __$$CanvasStateImplCopyWithImpl(
    _$CanvasStateImpl _value,
    $Res Function(_$CanvasStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? viewportCenter = null,
    Object? zoom = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$CanvasStateImpl(
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as int,
        viewportCenter: null == viewportCenter
            ? _value.viewportCenter
            : viewportCenter // ignore: cast_nullable_to_non_nullable
                  as Position,
        zoom: null == zoom
            ? _value.zoom
            : zoom // ignore: cast_nullable_to_non_nullable
                  as double,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CanvasStateImpl implements _CanvasState {
  const _$CanvasStateImpl({
    this.version = 1,
    this.viewportCenter = const Position(),
    this.zoom = 1.0,
    required this.updatedAt,
  });

  factory _$CanvasStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CanvasStateImplFromJson(json);

  /// Schema version for migration support
  @override
  @JsonKey()
  final int version;

  /// Viewport center position
  @override
  @JsonKey()
  final Position viewportCenter;

  /// Zoom level (1.0 = 100%)
  @override
  @JsonKey()
  final double zoom;

  /// Last modified timestamp
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'CanvasState(version: $version, viewportCenter: $viewportCenter, zoom: $zoom, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CanvasStateImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.viewportCenter, viewportCenter) ||
                other.viewportCenter == viewportCenter) &&
            (identical(other.zoom, zoom) || other.zoom == zoom) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, version, viewportCenter, zoom, updatedAt);

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CanvasStateImplCopyWith<_$CanvasStateImpl> get copyWith =>
      __$$CanvasStateImplCopyWithImpl<_$CanvasStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CanvasStateImplToJson(this);
  }
}

abstract class _CanvasState implements CanvasState {
  const factory _CanvasState({
    final int version,
    final Position viewportCenter,
    final double zoom,
    required final DateTime updatedAt,
  }) = _$CanvasStateImpl;

  factory _CanvasState.fromJson(Map<String, dynamic> json) =
      _$CanvasStateImpl.fromJson;

  /// Schema version for migration support
  @override
  int get version;

  /// Viewport center position
  @override
  Position get viewportCenter;

  /// Zoom level (1.0 = 100%)
  @override
  double get zoom;

  /// Last modified timestamp
  @override
  DateTime get updatedAt;

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CanvasStateImplCopyWith<_$CanvasStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
