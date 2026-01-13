// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workspace_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WorkspaceSession _$WorkspaceSessionFromJson(Map<String, dynamic> json) {
  return _WorkspaceSession.fromJson(json);
}

/// @nodoc
mixin _$WorkspaceSession {
  /// Unique identifier for this session
  String get id => throw _privateConstructorUsedError;

  /// Type of workspace (matrix_calculator, pdf_viewer, graph_plotter, etc.)
  String get workspaceType => throw _privateConstructorUsedError;

  /// When this session was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// When this session was last modified
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Parent session ID if this is a fork (null for original sessions)
  String? get parentSessionId => throw _privateConstructorUsedError;

  /// Workspace-specific data (serialized as JSON)
  Map<String, dynamic> get data => throw _privateConstructorUsedError;

  /// Optional label/title for the session
  String get label => throw _privateConstructorUsedError;

  /// Serializes this WorkspaceSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkspaceSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkspaceSessionCopyWith<WorkspaceSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkspaceSessionCopyWith<$Res> {
  factory $WorkspaceSessionCopyWith(
    WorkspaceSession value,
    $Res Function(WorkspaceSession) then,
  ) = _$WorkspaceSessionCopyWithImpl<$Res, WorkspaceSession>;
  @useResult
  $Res call({
    String id,
    String workspaceType,
    DateTime createdAt,
    DateTime updatedAt,
    String? parentSessionId,
    Map<String, dynamic> data,
    String label,
  });
}

/// @nodoc
class _$WorkspaceSessionCopyWithImpl<$Res, $Val extends WorkspaceSession>
    implements $WorkspaceSessionCopyWith<$Res> {
  _$WorkspaceSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkspaceSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workspaceType = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? parentSessionId = freezed,
    Object? data = null,
    Object? label = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            workspaceType: null == workspaceType
                ? _value.workspaceType
                : workspaceType // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            parentSessionId: freezed == parentSessionId
                ? _value.parentSessionId
                : parentSessionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkspaceSessionImplCopyWith<$Res>
    implements $WorkspaceSessionCopyWith<$Res> {
  factory _$$WorkspaceSessionImplCopyWith(
    _$WorkspaceSessionImpl value,
    $Res Function(_$WorkspaceSessionImpl) then,
  ) = __$$WorkspaceSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String workspaceType,
    DateTime createdAt,
    DateTime updatedAt,
    String? parentSessionId,
    Map<String, dynamic> data,
    String label,
  });
}

/// @nodoc
class __$$WorkspaceSessionImplCopyWithImpl<$Res>
    extends _$WorkspaceSessionCopyWithImpl<$Res, _$WorkspaceSessionImpl>
    implements _$$WorkspaceSessionImplCopyWith<$Res> {
  __$$WorkspaceSessionImplCopyWithImpl(
    _$WorkspaceSessionImpl _value,
    $Res Function(_$WorkspaceSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkspaceSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workspaceType = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? parentSessionId = freezed,
    Object? data = null,
    Object? label = null,
  }) {
    return _then(
      _$WorkspaceSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        workspaceType: null == workspaceType
            ? _value.workspaceType
            : workspaceType // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        parentSessionId: freezed == parentSessionId
            ? _value.parentSessionId
            : parentSessionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkspaceSessionImpl extends _WorkspaceSession {
  const _$WorkspaceSessionImpl({
    required this.id,
    required this.workspaceType,
    required this.createdAt,
    required this.updatedAt,
    this.parentSessionId,
    required final Map<String, dynamic> data,
    this.label = '',
  }) : _data = data,
       super._();

  factory _$WorkspaceSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkspaceSessionImplFromJson(json);

  /// Unique identifier for this session
  @override
  final String id;

  /// Type of workspace (matrix_calculator, pdf_viewer, graph_plotter, etc.)
  @override
  final String workspaceType;

  /// When this session was created
  @override
  final DateTime createdAt;

  /// When this session was last modified
  @override
  final DateTime updatedAt;

  /// Parent session ID if this is a fork (null for original sessions)
  @override
  final String? parentSessionId;

  /// Workspace-specific data (serialized as JSON)
  final Map<String, dynamic> _data;

  /// Workspace-specific data (serialized as JSON)
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  /// Optional label/title for the session
  @override
  @JsonKey()
  final String label;

  @override
  String toString() {
    return 'WorkspaceSession(id: $id, workspaceType: $workspaceType, createdAt: $createdAt, updatedAt: $updatedAt, parentSessionId: $parentSessionId, data: $data, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkspaceSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workspaceType, workspaceType) ||
                other.workspaceType == workspaceType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.parentSessionId, parentSessionId) ||
                other.parentSessionId == parentSessionId) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    workspaceType,
    createdAt,
    updatedAt,
    parentSessionId,
    const DeepCollectionEquality().hash(_data),
    label,
  );

  /// Create a copy of WorkspaceSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkspaceSessionImplCopyWith<_$WorkspaceSessionImpl> get copyWith =>
      __$$WorkspaceSessionImplCopyWithImpl<_$WorkspaceSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkspaceSessionImplToJson(this);
  }
}

abstract class _WorkspaceSession extends WorkspaceSession {
  const factory _WorkspaceSession({
    required final String id,
    required final String workspaceType,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? parentSessionId,
    required final Map<String, dynamic> data,
    final String label,
  }) = _$WorkspaceSessionImpl;
  const _WorkspaceSession._() : super._();

  factory _WorkspaceSession.fromJson(Map<String, dynamic> json) =
      _$WorkspaceSessionImpl.fromJson;

  /// Unique identifier for this session
  @override
  String get id;

  /// Type of workspace (matrix_calculator, pdf_viewer, graph_plotter, etc.)
  @override
  String get workspaceType;

  /// When this session was created
  @override
  DateTime get createdAt;

  /// When this session was last modified
  @override
  DateTime get updatedAt;

  /// Parent session ID if this is a fork (null for original sessions)
  @override
  String? get parentSessionId;

  /// Workspace-specific data (serialized as JSON)
  @override
  Map<String, dynamic> get data;

  /// Optional label/title for the session
  @override
  String get label;

  /// Create a copy of WorkspaceSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkspaceSessionImplCopyWith<_$WorkspaceSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
