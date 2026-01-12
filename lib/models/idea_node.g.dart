// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'idea_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IdeaNodeImpl _$$IdeaNodeImplFromJson(Map<String, dynamic> json) =>
    _$IdeaNodeImpl(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      position: json['position'] == null
          ? const Position()
          : Position.fromJson(json['position'] as Map<String, dynamic>),
      blocks: json['blocks'] == null
          ? const []
          : const ContentBlockListConverter().fromJson(json['blocks'] as List),
      links:
          (json['links'] as List<dynamic>?)
              ?.map((e) => NodeLink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$IdeaNodeImplToJson(_$IdeaNodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'position': instance.position,
      'blocks': const ContentBlockListConverter().toJson(instance.blocks),
      'links': instance.links,
    };

_$NodeLinkImpl _$$NodeLinkImplFromJson(Map<String, dynamic> json) =>
    _$NodeLinkImpl(
      targetNodeId: json['targetNodeId'] as String,
      label: json['label'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$NodeLinkImplToJson(_$NodeLinkImpl instance) =>
    <String, dynamic>{
      'targetNodeId': instance.targetNodeId,
      'label': instance.label,
      'createdAt': instance.createdAt.toIso8601String(),
    };
