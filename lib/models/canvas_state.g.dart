// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canvas_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CanvasStateImpl _$$CanvasStateImplFromJson(Map<String, dynamic> json) =>
    _$CanvasStateImpl(
      version: (json['version'] as num?)?.toInt() ?? 1,
      viewportCenter: json['viewportCenter'] == null
          ? const Position()
          : Position.fromJson(json['viewportCenter'] as Map<String, dynamic>),
      zoom: (json['zoom'] as num?)?.toDouble() ?? 1.0,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CanvasStateImplToJson(_$CanvasStateImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
      'viewportCenter': instance.viewportCenter,
      'zoom': instance.zoom,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
