import 'package:freezed_annotation/freezed_annotation.dart';

part 'matrix_models.freezed.dart';
part 'matrix_models.g.dart';

/// A matrix of numbers for calculation
@freezed
class Matrix with _$Matrix {
  const Matrix._();

  const factory Matrix({
    required String id,
    required List<List<double>> data,
    @Default('') String name,
  }) = _Matrix;

  /// Get dimensions as "rows x cols"
  String get dimensions {
    if (data.isEmpty) return '0x0';
    return '${data.length}x${data[0].length}';
  }

  factory Matrix.fromJson(Map<String, dynamic> json) =>
      _$MatrixFromJson(json);
}

/// An operation performed on matrices
@freezed
class MatrixOperation with _$MatrixOperation {
  const MatrixOperation._();

  const factory MatrixOperation({
    required String id,
    required String type, // 'multiply', 'invert', 'transpose', 'determinant', etc.
    required List<String> inputMatrixIds,
    required String outputMatrixId,
    @Default('') String description,
    required DateTime createdAt,
  }) = _MatrixOperation;

  factory MatrixOperation.fromJson(Map<String, dynamic> json) =>
      _$MatrixOperationFromJson(json);
}

/// Matrix calculator session data
@freezed
class MatrixCalculatorData with _$MatrixCalculatorData {
  const MatrixCalculatorData._();

  const factory MatrixCalculatorData({
    @Default([]) List<Matrix> matrices,
    @Default([]) List<MatrixOperation> operations,
    @Default({}) Map<String, List<List<double>>> results,
  }) = _MatrixCalculatorData;

  factory MatrixCalculatorData.fromJson(Map<String, dynamic> json) =>
      _$MatrixCalculatorDataFromJson(json);
}
