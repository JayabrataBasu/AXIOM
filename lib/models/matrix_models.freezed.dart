// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'matrix_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Matrix _$MatrixFromJson(Map<String, dynamic> json) {
  return _Matrix.fromJson(json);
}

/// @nodoc
mixin _$Matrix {
  String get id => throw _privateConstructorUsedError;
  List<List<double>> get data => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this Matrix to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Matrix
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatrixCopyWith<Matrix> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatrixCopyWith<$Res> {
  factory $MatrixCopyWith(Matrix value, $Res Function(Matrix) then) =
      _$MatrixCopyWithImpl<$Res, Matrix>;
  @useResult
  $Res call({String id, List<List<double>> data, String name});
}

/// @nodoc
class _$MatrixCopyWithImpl<$Res, $Val extends Matrix>
    implements $MatrixCopyWith<$Res> {
  _$MatrixCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Matrix
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? data = null, Object? name = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<List<double>>,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatrixImplCopyWith<$Res> implements $MatrixCopyWith<$Res> {
  factory _$$MatrixImplCopyWith(
    _$MatrixImpl value,
    $Res Function(_$MatrixImpl) then,
  ) = __$$MatrixImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, List<List<double>> data, String name});
}

/// @nodoc
class __$$MatrixImplCopyWithImpl<$Res>
    extends _$MatrixCopyWithImpl<$Res, _$MatrixImpl>
    implements _$$MatrixImplCopyWith<$Res> {
  __$$MatrixImplCopyWithImpl(
    _$MatrixImpl _value,
    $Res Function(_$MatrixImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Matrix
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? data = null, Object? name = null}) {
    return _then(
      _$MatrixImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<List<double>>,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatrixImpl extends _Matrix {
  const _$MatrixImpl({
    required this.id,
    required final List<List<double>> data,
    this.name = '',
  }) : _data = data,
       super._();

  factory _$MatrixImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatrixImplFromJson(json);

  @override
  final String id;
  final List<List<double>> _data;
  @override
  List<List<double>> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  @JsonKey()
  final String name;

  @override
  String toString() {
    return 'Matrix(id: $id, data: $data, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatrixImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    const DeepCollectionEquality().hash(_data),
    name,
  );

  /// Create a copy of Matrix
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatrixImplCopyWith<_$MatrixImpl> get copyWith =>
      __$$MatrixImplCopyWithImpl<_$MatrixImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatrixImplToJson(this);
  }
}

abstract class _Matrix extends Matrix {
  const factory _Matrix({
    required final String id,
    required final List<List<double>> data,
    final String name,
  }) = _$MatrixImpl;
  const _Matrix._() : super._();

  factory _Matrix.fromJson(Map<String, dynamic> json) = _$MatrixImpl.fromJson;

  @override
  String get id;
  @override
  List<List<double>> get data;
  @override
  String get name;

  /// Create a copy of Matrix
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatrixImplCopyWith<_$MatrixImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatrixOperation _$MatrixOperationFromJson(Map<String, dynamic> json) {
  return _MatrixOperation.fromJson(json);
}

/// @nodoc
mixin _$MatrixOperation {
  String get id => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'multiply', 'invert', 'transpose', 'determinant', etc.
  List<String> get inputMatrixIds => throw _privateConstructorUsedError;
  String get outputMatrixId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MatrixOperation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatrixOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatrixOperationCopyWith<MatrixOperation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatrixOperationCopyWith<$Res> {
  factory $MatrixOperationCopyWith(
    MatrixOperation value,
    $Res Function(MatrixOperation) then,
  ) = _$MatrixOperationCopyWithImpl<$Res, MatrixOperation>;
  @useResult
  $Res call({
    String id,
    String type,
    List<String> inputMatrixIds,
    String outputMatrixId,
    String description,
    DateTime createdAt,
  });
}

/// @nodoc
class _$MatrixOperationCopyWithImpl<$Res, $Val extends MatrixOperation>
    implements $MatrixOperationCopyWith<$Res> {
  _$MatrixOperationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatrixOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? inputMatrixIds = null,
    Object? outputMatrixId = null,
    Object? description = null,
    Object? createdAt = null,
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
                      as String,
            inputMatrixIds: null == inputMatrixIds
                ? _value.inputMatrixIds
                : inputMatrixIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            outputMatrixId: null == outputMatrixId
                ? _value.outputMatrixId
                : outputMatrixId // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatrixOperationImplCopyWith<$Res>
    implements $MatrixOperationCopyWith<$Res> {
  factory _$$MatrixOperationImplCopyWith(
    _$MatrixOperationImpl value,
    $Res Function(_$MatrixOperationImpl) then,
  ) = __$$MatrixOperationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String type,
    List<String> inputMatrixIds,
    String outputMatrixId,
    String description,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$MatrixOperationImplCopyWithImpl<$Res>
    extends _$MatrixOperationCopyWithImpl<$Res, _$MatrixOperationImpl>
    implements _$$MatrixOperationImplCopyWith<$Res> {
  __$$MatrixOperationImplCopyWithImpl(
    _$MatrixOperationImpl _value,
    $Res Function(_$MatrixOperationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatrixOperation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? inputMatrixIds = null,
    Object? outputMatrixId = null,
    Object? description = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$MatrixOperationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        inputMatrixIds: null == inputMatrixIds
            ? _value._inputMatrixIds
            : inputMatrixIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        outputMatrixId: null == outputMatrixId
            ? _value.outputMatrixId
            : outputMatrixId // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatrixOperationImpl extends _MatrixOperation {
  const _$MatrixOperationImpl({
    required this.id,
    required this.type,
    required final List<String> inputMatrixIds,
    required this.outputMatrixId,
    this.description = '',
    required this.createdAt,
  }) : _inputMatrixIds = inputMatrixIds,
       super._();

  factory _$MatrixOperationImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatrixOperationImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  // 'multiply', 'invert', 'transpose', 'determinant', etc.
  final List<String> _inputMatrixIds;
  // 'multiply', 'invert', 'transpose', 'determinant', etc.
  @override
  List<String> get inputMatrixIds {
    if (_inputMatrixIds is EqualUnmodifiableListView) return _inputMatrixIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inputMatrixIds);
  }

  @override
  final String outputMatrixId;
  @override
  @JsonKey()
  final String description;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'MatrixOperation(id: $id, type: $type, inputMatrixIds: $inputMatrixIds, outputMatrixId: $outputMatrixId, description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatrixOperationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(
              other._inputMatrixIds,
              _inputMatrixIds,
            ) &&
            (identical(other.outputMatrixId, outputMatrixId) ||
                other.outputMatrixId == outputMatrixId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    const DeepCollectionEquality().hash(_inputMatrixIds),
    outputMatrixId,
    description,
    createdAt,
  );

  /// Create a copy of MatrixOperation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatrixOperationImplCopyWith<_$MatrixOperationImpl> get copyWith =>
      __$$MatrixOperationImplCopyWithImpl<_$MatrixOperationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MatrixOperationImplToJson(this);
  }
}

abstract class _MatrixOperation extends MatrixOperation {
  const factory _MatrixOperation({
    required final String id,
    required final String type,
    required final List<String> inputMatrixIds,
    required final String outputMatrixId,
    final String description,
    required final DateTime createdAt,
  }) = _$MatrixOperationImpl;
  const _MatrixOperation._() : super._();

  factory _MatrixOperation.fromJson(Map<String, dynamic> json) =
      _$MatrixOperationImpl.fromJson;

  @override
  String get id;
  @override
  String get type; // 'multiply', 'invert', 'transpose', 'determinant', etc.
  @override
  List<String> get inputMatrixIds;
  @override
  String get outputMatrixId;
  @override
  String get description;
  @override
  DateTime get createdAt;

  /// Create a copy of MatrixOperation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatrixOperationImplCopyWith<_$MatrixOperationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatrixCalculatorData _$MatrixCalculatorDataFromJson(Map<String, dynamic> json) {
  return _MatrixCalculatorData.fromJson(json);
}

/// @nodoc
mixin _$MatrixCalculatorData {
  List<Matrix> get matrices => throw _privateConstructorUsedError;
  List<MatrixOperation> get operations => throw _privateConstructorUsedError;
  Map<String, List<List<double>>> get results =>
      throw _privateConstructorUsedError;

  /// Serializes this MatrixCalculatorData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatrixCalculatorData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatrixCalculatorDataCopyWith<MatrixCalculatorData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatrixCalculatorDataCopyWith<$Res> {
  factory $MatrixCalculatorDataCopyWith(
    MatrixCalculatorData value,
    $Res Function(MatrixCalculatorData) then,
  ) = _$MatrixCalculatorDataCopyWithImpl<$Res, MatrixCalculatorData>;
  @useResult
  $Res call({
    List<Matrix> matrices,
    List<MatrixOperation> operations,
    Map<String, List<List<double>>> results,
  });
}

/// @nodoc
class _$MatrixCalculatorDataCopyWithImpl<
  $Res,
  $Val extends MatrixCalculatorData
>
    implements $MatrixCalculatorDataCopyWith<$Res> {
  _$MatrixCalculatorDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatrixCalculatorData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matrices = null,
    Object? operations = null,
    Object? results = null,
  }) {
    return _then(
      _value.copyWith(
            matrices: null == matrices
                ? _value.matrices
                : matrices // ignore: cast_nullable_to_non_nullable
                      as List<Matrix>,
            operations: null == operations
                ? _value.operations
                : operations // ignore: cast_nullable_to_non_nullable
                      as List<MatrixOperation>,
            results: null == results
                ? _value.results
                : results // ignore: cast_nullable_to_non_nullable
                      as Map<String, List<List<double>>>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatrixCalculatorDataImplCopyWith<$Res>
    implements $MatrixCalculatorDataCopyWith<$Res> {
  factory _$$MatrixCalculatorDataImplCopyWith(
    _$MatrixCalculatorDataImpl value,
    $Res Function(_$MatrixCalculatorDataImpl) then,
  ) = __$$MatrixCalculatorDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<Matrix> matrices,
    List<MatrixOperation> operations,
    Map<String, List<List<double>>> results,
  });
}

/// @nodoc
class __$$MatrixCalculatorDataImplCopyWithImpl<$Res>
    extends _$MatrixCalculatorDataCopyWithImpl<$Res, _$MatrixCalculatorDataImpl>
    implements _$$MatrixCalculatorDataImplCopyWith<$Res> {
  __$$MatrixCalculatorDataImplCopyWithImpl(
    _$MatrixCalculatorDataImpl _value,
    $Res Function(_$MatrixCalculatorDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatrixCalculatorData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? matrices = null,
    Object? operations = null,
    Object? results = null,
  }) {
    return _then(
      _$MatrixCalculatorDataImpl(
        matrices: null == matrices
            ? _value._matrices
            : matrices // ignore: cast_nullable_to_non_nullable
                  as List<Matrix>,
        operations: null == operations
            ? _value._operations
            : operations // ignore: cast_nullable_to_non_nullable
                  as List<MatrixOperation>,
        results: null == results
            ? _value._results
            : results // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<List<double>>>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatrixCalculatorDataImpl extends _MatrixCalculatorData {
  const _$MatrixCalculatorDataImpl({
    final List<Matrix> matrices = const [],
    final List<MatrixOperation> operations = const [],
    final Map<String, List<List<double>>> results = const {},
  }) : _matrices = matrices,
       _operations = operations,
       _results = results,
       super._();

  factory _$MatrixCalculatorDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatrixCalculatorDataImplFromJson(json);

  final List<Matrix> _matrices;
  @override
  @JsonKey()
  List<Matrix> get matrices {
    if (_matrices is EqualUnmodifiableListView) return _matrices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_matrices);
  }

  final List<MatrixOperation> _operations;
  @override
  @JsonKey()
  List<MatrixOperation> get operations {
    if (_operations is EqualUnmodifiableListView) return _operations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_operations);
  }

  final Map<String, List<List<double>>> _results;
  @override
  @JsonKey()
  Map<String, List<List<double>>> get results {
    if (_results is EqualUnmodifiableMapView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_results);
  }

  @override
  String toString() {
    return 'MatrixCalculatorData(matrices: $matrices, operations: $operations, results: $results)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatrixCalculatorDataImpl &&
            const DeepCollectionEquality().equals(other._matrices, _matrices) &&
            const DeepCollectionEquality().equals(
              other._operations,
              _operations,
            ) &&
            const DeepCollectionEquality().equals(other._results, _results));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_matrices),
    const DeepCollectionEquality().hash(_operations),
    const DeepCollectionEquality().hash(_results),
  );

  /// Create a copy of MatrixCalculatorData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatrixCalculatorDataImplCopyWith<_$MatrixCalculatorDataImpl>
  get copyWith =>
      __$$MatrixCalculatorDataImplCopyWithImpl<_$MatrixCalculatorDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MatrixCalculatorDataImplToJson(this);
  }
}

abstract class _MatrixCalculatorData extends MatrixCalculatorData {
  const factory _MatrixCalculatorData({
    final List<Matrix> matrices,
    final List<MatrixOperation> operations,
    final Map<String, List<List<double>>> results,
  }) = _$MatrixCalculatorDataImpl;
  const _MatrixCalculatorData._() : super._();

  factory _MatrixCalculatorData.fromJson(Map<String, dynamic> json) =
      _$MatrixCalculatorDataImpl.fromJson;

  @override
  List<Matrix> get matrices;
  @override
  List<MatrixOperation> get operations;
  @override
  Map<String, List<List<double>>> get results;

  /// Create a copy of MatrixCalculatorData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatrixCalculatorDataImplCopyWith<_$MatrixCalculatorDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}
