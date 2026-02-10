// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maths.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MathsObject _$MathsObjectFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'matrix':
      return MatrixObject.fromJson(json);
    case 'graph':
      return GraphObject.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'MathsObject',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$MathsObject {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  Object get data => throw _privateConstructorUsedError;
  List<MathsOperation> get operations => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      String name,
      String workspaceId,
      MatrixData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )
    matrix,
    required TResult Function(
      String id,
      String name,
      String workspaceId,
      GraphData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )
    graph,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      String name,
      String workspaceId,
      MatrixData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )?
    matrix,
    TResult? Function(
      String id,
      String name,
      String workspaceId,
      GraphData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )?
    graph,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      String name,
      String workspaceId,
      MatrixData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )?
    matrix,
    TResult Function(
      String id,
      String name,
      String workspaceId,
      GraphData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )?
    graph,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MatrixObject value) matrix,
    required TResult Function(GraphObject value) graph,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MatrixObject value)? matrix,
    TResult? Function(GraphObject value)? graph,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MatrixObject value)? matrix,
    TResult Function(GraphObject value)? graph,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this MathsObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MathsObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MathsObjectCopyWith<MathsObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MathsObjectCopyWith<$Res> {
  factory $MathsObjectCopyWith(
    MathsObject value,
    $Res Function(MathsObject) then,
  ) = _$MathsObjectCopyWithImpl<$Res, MathsObject>;
  @useResult
  $Res call({
    String id,
    String name,
    String workspaceId,
    List<MathsOperation> operations,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$MathsObjectCopyWithImpl<$Res, $Val extends MathsObject>
    implements $MathsObjectCopyWith<$Res> {
  _$MathsObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MathsObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? workspaceId = null,
    Object? operations = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            workspaceId: null == workspaceId
                ? _value.workspaceId
                : workspaceId // ignore: cast_nullable_to_non_nullable
                      as String,
            operations: null == operations
                ? _value.operations
                : operations // ignore: cast_nullable_to_non_nullable
                      as List<MathsOperation>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatrixObjectImplCopyWith<$Res>
    implements $MathsObjectCopyWith<$Res> {
  factory _$$MatrixObjectImplCopyWith(
    _$MatrixObjectImpl value,
    $Res Function(_$MatrixObjectImpl) then,
  ) = __$$MatrixObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String workspaceId,
    MatrixData data,
    List<MathsOperation> operations,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $MatrixDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$MatrixObjectImplCopyWithImpl<$Res>
    extends _$MathsObjectCopyWithImpl<$Res, _$MatrixObjectImpl>
    implements _$$MatrixObjectImplCopyWith<$Res> {
  __$$MatrixObjectImplCopyWithImpl(
    _$MatrixObjectImpl _value,
    $Res Function(_$MatrixObjectImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MathsObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? workspaceId = null,
    Object? data = null,
    Object? operations = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$MatrixObjectImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        workspaceId: null == workspaceId
            ? _value.workspaceId
            : workspaceId // ignore: cast_nullable_to_non_nullable
                  as String,
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as MatrixData,
        operations: null == operations
            ? _value._operations
            : operations // ignore: cast_nullable_to_non_nullable
                  as List<MathsOperation>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }

  /// Create a copy of MathsObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MatrixDataCopyWith<$Res> get data {
    return $MatrixDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$MatrixObjectImpl extends MatrixObject {
  const _$MatrixObjectImpl({
    required this.id,
    required this.name,
    required this.workspaceId,
    required this.data,
    final List<MathsOperation> operations = const [],
    required this.createdAt,
    required this.updatedAt,
    final String? $type,
  }) : _operations = operations,
       $type = $type ?? 'matrix',
       super._();

  factory _$MatrixObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatrixObjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String workspaceId;
  @override
  final MatrixData data;
  final List<MathsOperation> _operations;
  @override
  @JsonKey()
  List<MathsOperation> get operations {
    if (_operations is EqualUnmodifiableListView) return _operations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_operations);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MathsObject.matrix(id: $id, name: $name, workspaceId: $workspaceId, data: $data, operations: $operations, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatrixObjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.data, data) || other.data == data) &&
            const DeepCollectionEquality().equals(
              other._operations,
              _operations,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    workspaceId,
    data,
    const DeepCollectionEquality().hash(_operations),
    createdAt,
    updatedAt,
  );

  /// Create a copy of MathsObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatrixObjectImplCopyWith<_$MatrixObjectImpl> get copyWith =>
      __$$MatrixObjectImplCopyWithImpl<_$MatrixObjectImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      String name,
      String workspaceId,
      MatrixData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )
    matrix,
    required TResult Function(
      String id,
      String name,
      String workspaceId,
      GraphData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )
    graph,
  }) {
    return matrix(
      id,
      name,
      workspaceId,
      data,
      operations,
      createdAt,
      updatedAt,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      String name,
      String workspaceId,
      MatrixData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )?
    matrix,
    TResult? Function(
      String id,
      String name,
      String workspaceId,
      GraphData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )?
    graph,
  }) {
    return matrix?.call(
      id,
      name,
      workspaceId,
      data,
      operations,
      createdAt,
      updatedAt,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      String name,
      String workspaceId,
      MatrixData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )?
    matrix,
    TResult Function(
      String id,
      String name,
      String workspaceId,
      GraphData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )?
    graph,
    required TResult orElse(),
  }) {
    if (matrix != null) {
      return matrix(
        id,
        name,
        workspaceId,
        data,
        operations,
        createdAt,
        updatedAt,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MatrixObject value) matrix,
    required TResult Function(GraphObject value) graph,
  }) {
    return matrix(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MatrixObject value)? matrix,
    TResult? Function(GraphObject value)? graph,
  }) {
    return matrix?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MatrixObject value)? matrix,
    TResult Function(GraphObject value)? graph,
    required TResult orElse(),
  }) {
    if (matrix != null) {
      return matrix(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MatrixObjectImplToJson(this);
  }
}

abstract class MatrixObject extends MathsObject {
  const factory MatrixObject({
    required final String id,
    required final String name,
    required final String workspaceId,
    required final MatrixData data,
    final List<MathsOperation> operations,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$MatrixObjectImpl;
  const MatrixObject._() : super._();

  factory MatrixObject.fromJson(Map<String, dynamic> json) =
      _$MatrixObjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get workspaceId;
  @override
  MatrixData get data;
  @override
  List<MathsOperation> get operations;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of MathsObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatrixObjectImplCopyWith<_$MatrixObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GraphObjectImplCopyWith<$Res>
    implements $MathsObjectCopyWith<$Res> {
  factory _$$GraphObjectImplCopyWith(
    _$GraphObjectImpl value,
    $Res Function(_$GraphObjectImpl) then,
  ) = __$$GraphObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String workspaceId,
    GraphData data,
    List<MathsOperation> operations,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $GraphDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$GraphObjectImplCopyWithImpl<$Res>
    extends _$MathsObjectCopyWithImpl<$Res, _$GraphObjectImpl>
    implements _$$GraphObjectImplCopyWith<$Res> {
  __$$GraphObjectImplCopyWithImpl(
    _$GraphObjectImpl _value,
    $Res Function(_$GraphObjectImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MathsObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? workspaceId = null,
    Object? data = null,
    Object? operations = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$GraphObjectImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        workspaceId: null == workspaceId
            ? _value.workspaceId
            : workspaceId // ignore: cast_nullable_to_non_nullable
                  as String,
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as GraphData,
        operations: null == operations
            ? _value._operations
            : operations // ignore: cast_nullable_to_non_nullable
                  as List<MathsOperation>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }

  /// Create a copy of MathsObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GraphDataCopyWith<$Res> get data {
    return $GraphDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$GraphObjectImpl extends GraphObject {
  const _$GraphObjectImpl({
    required this.id,
    required this.name,
    required this.workspaceId,
    required this.data,
    final List<MathsOperation> operations = const [],
    required this.createdAt,
    required this.updatedAt,
    final String? $type,
  }) : _operations = operations,
       $type = $type ?? 'graph',
       super._();

  factory _$GraphObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraphObjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String workspaceId;
  @override
  final GraphData data;
  final List<MathsOperation> _operations;
  @override
  @JsonKey()
  List<MathsOperation> get operations {
    if (_operations is EqualUnmodifiableListView) return _operations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_operations);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MathsObject.graph(id: $id, name: $name, workspaceId: $workspaceId, data: $data, operations: $operations, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphObjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.data, data) || other.data == data) &&
            const DeepCollectionEquality().equals(
              other._operations,
              _operations,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    workspaceId,
    data,
    const DeepCollectionEquality().hash(_operations),
    createdAt,
    updatedAt,
  );

  /// Create a copy of MathsObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphObjectImplCopyWith<_$GraphObjectImpl> get copyWith =>
      __$$GraphObjectImplCopyWithImpl<_$GraphObjectImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      String name,
      String workspaceId,
      MatrixData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )
    matrix,
    required TResult Function(
      String id,
      String name,
      String workspaceId,
      GraphData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )
    graph,
  }) {
    return graph(id, name, workspaceId, data, operations, createdAt, updatedAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      String name,
      String workspaceId,
      MatrixData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )?
    matrix,
    TResult? Function(
      String id,
      String name,
      String workspaceId,
      GraphData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )?
    graph,
  }) {
    return graph?.call(
      id,
      name,
      workspaceId,
      data,
      operations,
      createdAt,
      updatedAt,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      String name,
      String workspaceId,
      MatrixData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )?
    matrix,
    TResult Function(
      String id,
      String name,
      String workspaceId,
      GraphData data,
      List<MathsOperation> operations,
      DateTime createdAt,
      DateTime updatedAt,
    )?
    graph,
    required TResult orElse(),
  }) {
    if (graph != null) {
      return graph(
        id,
        name,
        workspaceId,
        data,
        operations,
        createdAt,
        updatedAt,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MatrixObject value) matrix,
    required TResult Function(GraphObject value) graph,
  }) {
    return graph(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MatrixObject value)? matrix,
    TResult? Function(GraphObject value)? graph,
  }) {
    return graph?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MatrixObject value)? matrix,
    TResult Function(GraphObject value)? graph,
    required TResult orElse(),
  }) {
    if (graph != null) {
      return graph(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$GraphObjectImplToJson(this);
  }
}

abstract class GraphObject extends MathsObject {
  const factory GraphObject({
    required final String id,
    required final String name,
    required final String workspaceId,
    required final GraphData data,
    final List<MathsOperation> operations,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$GraphObjectImpl;
  const GraphObject._() : super._();

  factory GraphObject.fromJson(Map<String, dynamic> json) =
      _$GraphObjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get workspaceId;
  @override
  GraphData get data;
  @override
  List<MathsOperation> get operations;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of MathsObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GraphObjectImplCopyWith<_$GraphObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatrixData _$MatrixDataFromJson(Map<String, dynamic> json) {
  return _MatrixData.fromJson(json);
}

/// @nodoc
mixin _$MatrixData {
  int get rows => throw _privateConstructorUsedError;
  int get cols => throw _privateConstructorUsedError;
  List<List<double>> get values => throw _privateConstructorUsedError;
  Map<String, dynamic>? get cachedResults => throw _privateConstructorUsedError;

  /// Serializes this MatrixData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatrixData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatrixDataCopyWith<MatrixData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatrixDataCopyWith<$Res> {
  factory $MatrixDataCopyWith(
    MatrixData value,
    $Res Function(MatrixData) then,
  ) = _$MatrixDataCopyWithImpl<$Res, MatrixData>;
  @useResult
  $Res call({
    int rows,
    int cols,
    List<List<double>> values,
    Map<String, dynamic>? cachedResults,
  });
}

/// @nodoc
class _$MatrixDataCopyWithImpl<$Res, $Val extends MatrixData>
    implements $MatrixDataCopyWith<$Res> {
  _$MatrixDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatrixData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rows = null,
    Object? cols = null,
    Object? values = null,
    Object? cachedResults = freezed,
  }) {
    return _then(
      _value.copyWith(
            rows: null == rows
                ? _value.rows
                : rows // ignore: cast_nullable_to_non_nullable
                      as int,
            cols: null == cols
                ? _value.cols
                : cols // ignore: cast_nullable_to_non_nullable
                      as int,
            values: null == values
                ? _value.values
                : values // ignore: cast_nullable_to_non_nullable
                      as List<List<double>>,
            cachedResults: freezed == cachedResults
                ? _value.cachedResults
                : cachedResults // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatrixDataImplCopyWith<$Res>
    implements $MatrixDataCopyWith<$Res> {
  factory _$$MatrixDataImplCopyWith(
    _$MatrixDataImpl value,
    $Res Function(_$MatrixDataImpl) then,
  ) = __$$MatrixDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int rows,
    int cols,
    List<List<double>> values,
    Map<String, dynamic>? cachedResults,
  });
}

/// @nodoc
class __$$MatrixDataImplCopyWithImpl<$Res>
    extends _$MatrixDataCopyWithImpl<$Res, _$MatrixDataImpl>
    implements _$$MatrixDataImplCopyWith<$Res> {
  __$$MatrixDataImplCopyWithImpl(
    _$MatrixDataImpl _value,
    $Res Function(_$MatrixDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatrixData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rows = null,
    Object? cols = null,
    Object? values = null,
    Object? cachedResults = freezed,
  }) {
    return _then(
      _$MatrixDataImpl(
        rows: null == rows
            ? _value.rows
            : rows // ignore: cast_nullable_to_non_nullable
                  as int,
        cols: null == cols
            ? _value.cols
            : cols // ignore: cast_nullable_to_non_nullable
                  as int,
        values: null == values
            ? _value._values
            : values // ignore: cast_nullable_to_non_nullable
                  as List<List<double>>,
        cachedResults: freezed == cachedResults
            ? _value._cachedResults
            : cachedResults // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatrixDataImpl implements _MatrixData {
  const _$MatrixDataImpl({
    required this.rows,
    required this.cols,
    required final List<List<double>> values,
    final Map<String, dynamic>? cachedResults,
  }) : _values = values,
       _cachedResults = cachedResults;

  factory _$MatrixDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatrixDataImplFromJson(json);

  @override
  final int rows;
  @override
  final int cols;
  final List<List<double>> _values;
  @override
  List<List<double>> get values {
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_values);
  }

  final Map<String, dynamic>? _cachedResults;
  @override
  Map<String, dynamic>? get cachedResults {
    final value = _cachedResults;
    if (value == null) return null;
    if (_cachedResults is EqualUnmodifiableMapView) return _cachedResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'MatrixData(rows: $rows, cols: $cols, values: $values, cachedResults: $cachedResults)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatrixDataImpl &&
            (identical(other.rows, rows) || other.rows == rows) &&
            (identical(other.cols, cols) || other.cols == cols) &&
            const DeepCollectionEquality().equals(other._values, _values) &&
            const DeepCollectionEquality().equals(
              other._cachedResults,
              _cachedResults,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    rows,
    cols,
    const DeepCollectionEquality().hash(_values),
    const DeepCollectionEquality().hash(_cachedResults),
  );

  /// Create a copy of MatrixData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatrixDataImplCopyWith<_$MatrixDataImpl> get copyWith =>
      __$$MatrixDataImplCopyWithImpl<_$MatrixDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatrixDataImplToJson(this);
  }
}

abstract class _MatrixData implements MatrixData {
  const factory _MatrixData({
    required final int rows,
    required final int cols,
    required final List<List<double>> values,
    final Map<String, dynamic>? cachedResults,
  }) = _$MatrixDataImpl;

  factory _MatrixData.fromJson(Map<String, dynamic> json) =
      _$MatrixDataImpl.fromJson;

  @override
  int get rows;
  @override
  int get cols;
  @override
  List<List<double>> get values;
  @override
  Map<String, dynamic>? get cachedResults;

  /// Create a copy of MatrixData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatrixDataImplCopyWith<_$MatrixDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GraphData _$GraphDataFromJson(Map<String, dynamic> json) {
  return _GraphData.fromJson(json);
}

/// @nodoc
mixin _$GraphData {
  List<String> get equations => throw _privateConstructorUsedError;
  double get domainMin => throw _privateConstructorUsedError;
  double get domainMax => throw _privateConstructorUsedError;
  double get rangeMin => throw _privateConstructorUsedError;
  double get rangeMax => throw _privateConstructorUsedError;
  int get plotPoints => throw _privateConstructorUsedError;
  Map<String, String> get colors => throw _privateConstructorUsedError;

  /// Serializes this GraphData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GraphData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GraphDataCopyWith<GraphData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphDataCopyWith<$Res> {
  factory $GraphDataCopyWith(GraphData value, $Res Function(GraphData) then) =
      _$GraphDataCopyWithImpl<$Res, GraphData>;
  @useResult
  $Res call({
    List<String> equations,
    double domainMin,
    double domainMax,
    double rangeMin,
    double rangeMax,
    int plotPoints,
    Map<String, String> colors,
  });
}

/// @nodoc
class _$GraphDataCopyWithImpl<$Res, $Val extends GraphData>
    implements $GraphDataCopyWith<$Res> {
  _$GraphDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GraphData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? equations = null,
    Object? domainMin = null,
    Object? domainMax = null,
    Object? rangeMin = null,
    Object? rangeMax = null,
    Object? plotPoints = null,
    Object? colors = null,
  }) {
    return _then(
      _value.copyWith(
            equations: null == equations
                ? _value.equations
                : equations // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            domainMin: null == domainMin
                ? _value.domainMin
                : domainMin // ignore: cast_nullable_to_non_nullable
                      as double,
            domainMax: null == domainMax
                ? _value.domainMax
                : domainMax // ignore: cast_nullable_to_non_nullable
                      as double,
            rangeMin: null == rangeMin
                ? _value.rangeMin
                : rangeMin // ignore: cast_nullable_to_non_nullable
                      as double,
            rangeMax: null == rangeMax
                ? _value.rangeMax
                : rangeMax // ignore: cast_nullable_to_non_nullable
                      as double,
            plotPoints: null == plotPoints
                ? _value.plotPoints
                : plotPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            colors: null == colors
                ? _value.colors
                : colors // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GraphDataImplCopyWith<$Res>
    implements $GraphDataCopyWith<$Res> {
  factory _$$GraphDataImplCopyWith(
    _$GraphDataImpl value,
    $Res Function(_$GraphDataImpl) then,
  ) = __$$GraphDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String> equations,
    double domainMin,
    double domainMax,
    double rangeMin,
    double rangeMax,
    int plotPoints,
    Map<String, String> colors,
  });
}

/// @nodoc
class __$$GraphDataImplCopyWithImpl<$Res>
    extends _$GraphDataCopyWithImpl<$Res, _$GraphDataImpl>
    implements _$$GraphDataImplCopyWith<$Res> {
  __$$GraphDataImplCopyWithImpl(
    _$GraphDataImpl _value,
    $Res Function(_$GraphDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GraphData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? equations = null,
    Object? domainMin = null,
    Object? domainMax = null,
    Object? rangeMin = null,
    Object? rangeMax = null,
    Object? plotPoints = null,
    Object? colors = null,
  }) {
    return _then(
      _$GraphDataImpl(
        equations: null == equations
            ? _value._equations
            : equations // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        domainMin: null == domainMin
            ? _value.domainMin
            : domainMin // ignore: cast_nullable_to_non_nullable
                  as double,
        domainMax: null == domainMax
            ? _value.domainMax
            : domainMax // ignore: cast_nullable_to_non_nullable
                  as double,
        rangeMin: null == rangeMin
            ? _value.rangeMin
            : rangeMin // ignore: cast_nullable_to_non_nullable
                  as double,
        rangeMax: null == rangeMax
            ? _value.rangeMax
            : rangeMax // ignore: cast_nullable_to_non_nullable
                  as double,
        plotPoints: null == plotPoints
            ? _value.plotPoints
            : plotPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        colors: null == colors
            ? _value._colors
            : colors // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GraphDataImpl implements _GraphData {
  const _$GraphDataImpl({
    required final List<String> equations,
    this.domainMin = -10.0,
    this.domainMax = 10.0,
    this.rangeMin = -10.0,
    this.rangeMax = 10.0,
    this.plotPoints = 200,
    final Map<String, String> colors = const {},
  }) : _equations = equations,
       _colors = colors;

  factory _$GraphDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraphDataImplFromJson(json);

  final List<String> _equations;
  @override
  List<String> get equations {
    if (_equations is EqualUnmodifiableListView) return _equations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equations);
  }

  @override
  @JsonKey()
  final double domainMin;
  @override
  @JsonKey()
  final double domainMax;
  @override
  @JsonKey()
  final double rangeMin;
  @override
  @JsonKey()
  final double rangeMax;
  @override
  @JsonKey()
  final int plotPoints;
  final Map<String, String> _colors;
  @override
  @JsonKey()
  Map<String, String> get colors {
    if (_colors is EqualUnmodifiableMapView) return _colors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_colors);
  }

  @override
  String toString() {
    return 'GraphData(equations: $equations, domainMin: $domainMin, domainMax: $domainMax, rangeMin: $rangeMin, rangeMax: $rangeMax, plotPoints: $plotPoints, colors: $colors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphDataImpl &&
            const DeepCollectionEquality().equals(
              other._equations,
              _equations,
            ) &&
            (identical(other.domainMin, domainMin) ||
                other.domainMin == domainMin) &&
            (identical(other.domainMax, domainMax) ||
                other.domainMax == domainMax) &&
            (identical(other.rangeMin, rangeMin) ||
                other.rangeMin == rangeMin) &&
            (identical(other.rangeMax, rangeMax) ||
                other.rangeMax == rangeMax) &&
            (identical(other.plotPoints, plotPoints) ||
                other.plotPoints == plotPoints) &&
            const DeepCollectionEquality().equals(other._colors, _colors));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_equations),
    domainMin,
    domainMax,
    rangeMin,
    rangeMax,
    plotPoints,
    const DeepCollectionEquality().hash(_colors),
  );

  /// Create a copy of GraphData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphDataImplCopyWith<_$GraphDataImpl> get copyWith =>
      __$$GraphDataImplCopyWithImpl<_$GraphDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraphDataImplToJson(this);
  }
}

abstract class _GraphData implements GraphData {
  const factory _GraphData({
    required final List<String> equations,
    final double domainMin,
    final double domainMax,
    final double rangeMin,
    final double rangeMax,
    final int plotPoints,
    final Map<String, String> colors,
  }) = _$GraphDataImpl;

  factory _GraphData.fromJson(Map<String, dynamic> json) =
      _$GraphDataImpl.fromJson;

  @override
  List<String> get equations;
  @override
  double get domainMin;
  @override
  double get domainMax;
  @override
  double get rangeMin;
  @override
  double get rangeMax;
  @override
  int get plotPoints;
  @override
  Map<String, String> get colors;

  /// Create a copy of GraphData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GraphDataImplCopyWith<_$GraphDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MathsOperation _$MathsOperationFromJson(Map<String, dynamic> json) {
  return _MathsOperation.fromJson(json);
}

/// @nodoc
mixin _$MathsOperation {
  String get id => throw _privateConstructorUsedError;
  MathsOperationType get type => throw _privateConstructorUsedError;
  Map<String, dynamic> get inputs => throw _privateConstructorUsedError;
  Map<String, dynamic> get result => throw _privateConstructorUsedError;
  List<String> get steps => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this MathsOperation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MathsOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MathsOperationCopyWith<MathsOperation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MathsOperationCopyWith<$Res> {
  factory $MathsOperationCopyWith(
    MathsOperation value,
    $Res Function(MathsOperation) then,
  ) = _$MathsOperationCopyWithImpl<$Res, MathsOperation>;
  @useResult
  $Res call({
    String id,
    MathsOperationType type,
    Map<String, dynamic> inputs,
    Map<String, dynamic> result,
    List<String> steps,
    DateTime timestamp,
  });
}

/// @nodoc
class _$MathsOperationCopyWithImpl<$Res, $Val extends MathsOperation>
    implements $MathsOperationCopyWith<$Res> {
  _$MathsOperationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MathsOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? inputs = null,
    Object? result = null,
    Object? steps = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as MathsOperationType,
            inputs: null == inputs
                ? _value.inputs
                : inputs // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            result: null == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            steps: null == steps
                ? _value.steps
                : steps // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MathsOperationImplCopyWith<$Res>
    implements $MathsOperationCopyWith<$Res> {
  factory _$$MathsOperationImplCopyWith(
    _$MathsOperationImpl value,
    $Res Function(_$MathsOperationImpl) then,
  ) = __$$MathsOperationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    MathsOperationType type,
    Map<String, dynamic> inputs,
    Map<String, dynamic> result,
    List<String> steps,
    DateTime timestamp,
  });
}

/// @nodoc
class __$$MathsOperationImplCopyWithImpl<$Res>
    extends _$MathsOperationCopyWithImpl<$Res, _$MathsOperationImpl>
    implements _$$MathsOperationImplCopyWith<$Res> {
  __$$MathsOperationImplCopyWithImpl(
    _$MathsOperationImpl _value,
    $Res Function(_$MathsOperationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MathsOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? inputs = null,
    Object? result = null,
    Object? steps = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$MathsOperationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as MathsOperationType,
        inputs: null == inputs
            ? _value._inputs
            : inputs // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        result: null == result
            ? _value._result
            : result // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        steps: null == steps
            ? _value._steps
            : steps // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MathsOperationImpl implements _MathsOperation {
  const _$MathsOperationImpl({
    required this.id,
    required this.type,
    required final Map<String, dynamic> inputs,
    required final Map<String, dynamic> result,
    final List<String> steps = const [],
    required this.timestamp,
  }) : _inputs = inputs,
       _result = result,
       _steps = steps;

  factory _$MathsOperationImpl.fromJson(Map<String, dynamic> json) =>
      _$$MathsOperationImplFromJson(json);

  @override
  final String id;
  @override
  final MathsOperationType type;
  final Map<String, dynamic> _inputs;
  @override
  Map<String, dynamic> get inputs {
    if (_inputs is EqualUnmodifiableMapView) return _inputs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_inputs);
  }

  final Map<String, dynamic> _result;
  @override
  Map<String, dynamic> get result {
    if (_result is EqualUnmodifiableMapView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_result);
  }

  final List<String> _steps;
  @override
  @JsonKey()
  List<String> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'MathsOperation(id: $id, type: $type, inputs: $inputs, result: $result, steps: $steps, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MathsOperationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._inputs, _inputs) &&
            const DeepCollectionEquality().equals(other._result, _result) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    const DeepCollectionEquality().hash(_inputs),
    const DeepCollectionEquality().hash(_result),
    const DeepCollectionEquality().hash(_steps),
    timestamp,
  );

  /// Create a copy of MathsOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MathsOperationImplCopyWith<_$MathsOperationImpl> get copyWith =>
      __$$MathsOperationImplCopyWithImpl<_$MathsOperationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MathsOperationImplToJson(this);
  }
}

abstract class _MathsOperation implements MathsOperation {
  const factory _MathsOperation({
    required final String id,
    required final MathsOperationType type,
    required final Map<String, dynamic> inputs,
    required final Map<String, dynamic> result,
    final List<String> steps,
    required final DateTime timestamp,
  }) = _$MathsOperationImpl;

  factory _MathsOperation.fromJson(Map<String, dynamic> json) =
      _$MathsOperationImpl.fromJson;

  @override
  String get id;
  @override
  MathsOperationType get type;
  @override
  Map<String, dynamic> get inputs;
  @override
  Map<String, dynamic> get result;
  @override
  List<String> get steps;
  @override
  DateTime get timestamp;

  /// Create a copy of MathsOperation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MathsOperationImplCopyWith<_$MathsOperationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
