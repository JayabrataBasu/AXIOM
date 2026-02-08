// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mind_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MindMapNodeImpl _$$MindMapNodeImplFromJson(Map<String, dynamic> json) =>
    _$MindMapNodeImpl(
      id: json['id'] as String,
      parentId: json['parentId'] as String?,
      text: json['text'] as String,
      position: json['position'] == null
          ? const Position()
          : Position.fromJson(json['position'] as Map<String, dynamic>),
      style: json['style'] == null
          ? const MindMapNodeStyle()
          : MindMapNodeStyle.fromJson(json['style'] as Map<String, dynamic>),
      childIds:
          (json['childIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      collapsed: json['collapsed'] as bool? ?? false,
      priority: json['priority'] as String? ?? 'none',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MindMapNodeImplToJson(_$MindMapNodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'text': instance.text,
      'position': instance.position,
      'style': instance.style,
      'childIds': instance.childIds,
      'collapsed': instance.collapsed,
      'priority': instance.priority,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$MindMapNodeStyleImpl _$$MindMapNodeStyleImplFromJson(
  Map<String, dynamic> json,
) => _$MindMapNodeStyleImpl(
  backgroundColor: (json['backgroundColor'] as num?)?.toInt() ?? 0xFFFDF6E3,
  textColor: (json['textColor'] as num?)?.toInt() ?? 0xFF000000,
  borderColor: (json['borderColor'] as num?)?.toInt() ?? 0xFF708238,
  borderWidth: (json['borderWidth'] as num?)?.toDouble() ?? 2.0,
  shape: json['shape'] as String? ?? 'rounded',
  emoji: json['emoji'] as String? ?? '',
);

Map<String, dynamic> _$$MindMapNodeStyleImplToJson(
  _$MindMapNodeStyleImpl instance,
) => <String, dynamic>{
  'backgroundColor': instance.backgroundColor,
  'textColor': instance.textColor,
  'borderColor': instance.borderColor,
  'borderWidth': instance.borderWidth,
  'shape': instance.shape,
  'emoji': instance.emoji,
};

_$MindMapGraphImpl _$$MindMapGraphImplFromJson(Map<String, dynamic> json) =>
    _$MindMapGraphImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      workspaceId: json['workspaceId'] as String,
      rootNodeId: json['rootNodeId'] as String?,
      nodes:
          (json['nodes'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, MindMapNode.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MindMapGraphImplToJson(_$MindMapGraphImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'workspaceId': instance.workspaceId,
      'rootNodeId': instance.rootNodeId,
      'nodes': instance.nodes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
