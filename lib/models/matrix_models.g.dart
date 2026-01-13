// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matrix_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatrixImpl _$$MatrixImplFromJson(Map<String, dynamic> json) => _$MatrixImpl(
  id: json['id'] as String,
  data: (json['data'] as List<dynamic>)
      .map(
        (e) => (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      )
      .toList(),
  name: json['name'] as String? ?? '',
);

Map<String, dynamic> _$$MatrixImplToJson(_$MatrixImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data,
      'name': instance.name,
    };

_$MatrixOperationImpl _$$MatrixOperationImplFromJson(
  Map<String, dynamic> json,
) => _$MatrixOperationImpl(
  id: json['id'] as String,
  type: json['type'] as String,
  inputMatrixIds: (json['inputMatrixIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  outputMatrixId: json['outputMatrixId'] as String,
  description: json['description'] as String? ?? '',
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$MatrixOperationImplToJson(
  _$MatrixOperationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'inputMatrixIds': instance.inputMatrixIds,
  'outputMatrixId': instance.outputMatrixId,
  'description': instance.description,
  'createdAt': instance.createdAt.toIso8601String(),
};

_$MatrixCalculatorDataImpl _$$MatrixCalculatorDataImplFromJson(
  Map<String, dynamic> json,
) => _$MatrixCalculatorDataImpl(
  matrices:
      (json['matrices'] as List<dynamic>?)
          ?.map((e) => Matrix.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  operations:
      (json['operations'] as List<dynamic>?)
          ?.map((e) => MatrixOperation.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  results:
      (json['results'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map(
                (e) => (e as List<dynamic>)
                    .map((e) => (e as num).toDouble())
                    .toList(),
              )
              .toList(),
        ),
      ) ??
      const {},
);

Map<String, dynamic> _$$MatrixCalculatorDataImplToJson(
  _$MatrixCalculatorDataImpl instance,
) => <String, dynamic>{
  'matrices': instance.matrices,
  'operations': instance.operations,
  'results': instance.results,
};
