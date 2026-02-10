// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maths.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MatrixObjectImpl _$$MatrixObjectImplFromJson(Map<String, dynamic> json) =>
    _$MatrixObjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      workspaceId: json['workspaceId'] as String,
      data: MatrixData.fromJson(json['data'] as Map<String, dynamic>),
      operations:
          (json['operations'] as List<dynamic>?)
              ?.map((e) => MathsOperation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MatrixObjectImplToJson(_$MatrixObjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'workspaceId': instance.workspaceId,
      'data': instance.data,
      'operations': instance.operations,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'runtimeType': instance.$type,
    };

_$GraphObjectImpl _$$GraphObjectImplFromJson(Map<String, dynamic> json) =>
    _$GraphObjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      workspaceId: json['workspaceId'] as String,
      data: GraphData.fromJson(json['data'] as Map<String, dynamic>),
      operations:
          (json['operations'] as List<dynamic>?)
              ?.map((e) => MathsOperation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$GraphObjectImplToJson(_$GraphObjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'workspaceId': instance.workspaceId,
      'data': instance.data,
      'operations': instance.operations,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'runtimeType': instance.$type,
    };

_$MatrixDataImpl _$$MatrixDataImplFromJson(Map<String, dynamic> json) =>
    _$MatrixDataImpl(
      rows: (json['rows'] as num).toInt(),
      cols: (json['cols'] as num).toInt(),
      values: (json['values'] as List<dynamic>)
          .map(
            (e) =>
                (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
          )
          .toList(),
      cachedResults: json['cachedResults'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$MatrixDataImplToJson(_$MatrixDataImpl instance) =>
    <String, dynamic>{
      'rows': instance.rows,
      'cols': instance.cols,
      'values': instance.values,
      'cachedResults': instance.cachedResults,
    };

_$GraphDataImpl _$$GraphDataImplFromJson(Map<String, dynamic> json) =>
    _$GraphDataImpl(
      equations: (json['equations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      domainMin: (json['domainMin'] as num?)?.toDouble() ?? -10.0,
      domainMax: (json['domainMax'] as num?)?.toDouble() ?? 10.0,
      rangeMin: (json['rangeMin'] as num?)?.toDouble() ?? -10.0,
      rangeMax: (json['rangeMax'] as num?)?.toDouble() ?? 10.0,
      plotPoints: (json['plotPoints'] as num?)?.toInt() ?? 200,
      colors:
          (json['colors'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$$GraphDataImplToJson(_$GraphDataImpl instance) =>
    <String, dynamic>{
      'equations': instance.equations,
      'domainMin': instance.domainMin,
      'domainMax': instance.domainMax,
      'rangeMin': instance.rangeMin,
      'rangeMax': instance.rangeMax,
      'plotPoints': instance.plotPoints,
      'colors': instance.colors,
    };

_$MathsOperationImpl _$$MathsOperationImplFromJson(Map<String, dynamic> json) =>
    _$MathsOperationImpl(
      id: json['id'] as String,
      type: $enumDecode(_$MathsOperationTypeEnumMap, json['type']),
      inputs: json['inputs'] as Map<String, dynamic>,
      result: json['result'] as Map<String, dynamic>,
      steps:
          (json['steps'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$MathsOperationImplToJson(
  _$MathsOperationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$MathsOperationTypeEnumMap[instance.type]!,
  'inputs': instance.inputs,
  'result': instance.result,
  'steps': instance.steps,
  'timestamp': instance.timestamp.toIso8601String(),
};

const _$MathsOperationTypeEnumMap = {
  MathsOperationType.transpose: 'transpose',
  MathsOperationType.multiply: 'multiply',
  MathsOperationType.add: 'add',
  MathsOperationType.subtract: 'subtract',
  MathsOperationType.scalarMultiply: 'scalarMultiply',
  MathsOperationType.determinant: 'determinant',
  MathsOperationType.inverse: 'inverse',
  MathsOperationType.rowEchelon: 'rowEchelon',
  MathsOperationType.plot: 'plot',
  MathsOperationType.evaluate: 'evaluate',
};
