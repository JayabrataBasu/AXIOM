import 'package:freezed_annotation/freezed_annotation.dart';

part 'maths.freezed.dart';
part 'maths.g.dart';

/// Type of mathematical object
enum MathsObjectType {
  matrix,
  graph,
}

/// Type of mathematical operation
enum MathsOperationType {
  transpose,
  multiply,
  add,
  subtract,
  scalarMultiply,
  determinant,
  inverse,
  rowEchelon,
  plot,
  evaluate,
}

/// Base class for all mathematical objects
@freezed
class MathsObject with _$MathsObject {
  const MathsObject._();

  const factory MathsObject.matrix({
    required String id,
    required String name,
    required String workspaceId,
    required MatrixData data,
    @Default([]) List<MathsOperation> operations,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = MatrixObject;

  const factory MathsObject.graph({
    required String id,
    required String name,
    required String workspaceId,
    required GraphData data,
    @Default([]) List<MathsOperation> operations,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = GraphObject;

  factory MathsObject.fromJson(Map<String, dynamic> json) =>
      _$MathsObjectFromJson(json);

  /// Get the type of this maths object
  MathsObjectType get type => map(
        matrix: (_) => MathsObjectType.matrix,
        graph: (_) => MathsObjectType.graph,
      );
}

/// Data for matrix objects
@freezed
class MatrixData with _$MatrixData {
  const factory MatrixData({
    required int rows,
    required int cols,
    required List<List<double>> values,
    Map<String, dynamic>? cachedResults,
  }) = _MatrixData;

  factory MatrixData.fromJson(Map<String, dynamic> json) =>
      _$MatrixDataFromJson(json);
}

/// Data for graph objects
@freezed
class GraphData with _$GraphData {
  const factory GraphData({
    required List<String> equations,
    @Default(-10.0) double domainMin,
    @Default(10.0) double domainMax,
    @Default(-10.0) double rangeMin,
    @Default(10.0) double rangeMax,
    @Default(200) int plotPoints,
    @Default({}) Map<String, String> colors,
  }) = _GraphData;

  factory GraphData.fromJson(Map<String, dynamic> json) =>
      _$GraphDataFromJson(json);
}

/// Represents a mathematical operation with its result and steps
@freezed
class MathsOperation with _$MathsOperation {
  const factory MathsOperation({
    required String id,
    required MathsOperationType type,
    required Map<String, dynamic> inputs,
    required Map<String, dynamic> result,
    @Default([]) List<String> steps,
    required DateTime timestamp,
  }) = _MathsOperation;

  factory MathsOperation.fromJson(Map<String, dynamic> json) =>
      _$MathsOperationFromJson(json);
}
