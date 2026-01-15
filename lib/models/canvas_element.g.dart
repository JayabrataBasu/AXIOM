// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'canvas_element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StandaloneBlockImpl _$$StandaloneBlockImplFromJson(
  Map<String, dynamic> json,
) => _$StandaloneBlockImpl(
  id: json['id'] as String,
  position: Position.fromJson(json['position'] as Map<String, dynamic>),
  block: const ContentBlockConverter().fromJson(
    json['block'] as Map<String, dynamic>,
  ),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  links:
      (json['links'] as List<dynamic>?)
          ?.map((e) => ElementLink.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$StandaloneBlockImplToJson(
  _$StandaloneBlockImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'position': instance.position,
  'block': const ContentBlockConverter().toJson(instance.block),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'links': instance.links,
  'runtimeType': instance.$type,
};

_$ContainerNodeImpl _$$ContainerNodeImplFromJson(Map<String, dynamic> json) =>
    _$ContainerNodeImpl(
      id: json['id'] as String,
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      name: json['name'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      blocks: json['blocks'] == null
          ? const []
          : const ContentBlockListConverter2().fromJson(json['blocks'] as List),
      links:
          (json['links'] as List<dynamic>?)
              ?.map((e) => ElementLink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ContainerNodeImplToJson(_$ContainerNodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': instance.position,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'blocks': const ContentBlockListConverter2().toJson(instance.blocks),
      'links': instance.links,
      'runtimeType': instance.$type,
    };

_$ElementLinkImpl _$$ElementLinkImplFromJson(Map<String, dynamic> json) =>
    _$ElementLinkImpl(
      targetElementId: json['targetElementId'] as String,
      label: json['label'] as String? ?? '',
      type:
          $enumDecodeNullable(_$LinkTypeEnumMap, json['type']) ??
          LinkType.reference,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ElementLinkImplToJson(_$ElementLinkImpl instance) =>
    <String, dynamic>{
      'targetElementId': instance.targetElementId,
      'label': instance.label,
      'type': _$LinkTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$LinkTypeEnumMap = {
  LinkType.reference: 'reference',
  LinkType.dependency: 'dependency',
  LinkType.derivation: 'derivation',
  LinkType.association: 'association',
};
