// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TextBlockImpl _$$TextBlockImplFromJson(Map<String, dynamic> json) =>
    _$TextBlockImpl(
      id: json['id'] as String,
      content: json['content'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$TextBlockImplToJson(_$TextBlockImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'type': instance.$type,
    };

_$HeadingBlockImpl _$$HeadingBlockImplFromJson(Map<String, dynamic> json) =>
    _$HeadingBlockImpl(
      id: json['id'] as String,
      content: json['content'] as String? ?? '',
      level: (json['level'] as num?)?.toInt() ?? 1,
      createdAt: DateTime.parse(json['createdAt'] as String),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$HeadingBlockImplToJson(_$HeadingBlockImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'level': instance.level,
      'createdAt': instance.createdAt.toIso8601String(),
      'type': instance.$type,
    };

_$BulletListBlockImpl _$$BulletListBlockImplFromJson(
  Map<String, dynamic> json,
) => _$BulletListBlockImpl(
  id: json['id'] as String,
  items:
      (json['items'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$$BulletListBlockImplToJson(
  _$BulletListBlockImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'items': instance.items,
  'createdAt': instance.createdAt.toIso8601String(),
  'type': instance.$type,
};

_$CodeBlockImpl _$$CodeBlockImplFromJson(Map<String, dynamic> json) =>
    _$CodeBlockImpl(
      id: json['id'] as String,
      content: json['content'] as String? ?? '',
      language: json['language'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$CodeBlockImplToJson(_$CodeBlockImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'language': instance.language,
      'createdAt': instance.createdAt.toIso8601String(),
      'type': instance.$type,
    };

_$QuoteBlockImpl _$$QuoteBlockImplFromJson(Map<String, dynamic> json) =>
    _$QuoteBlockImpl(
      id: json['id'] as String,
      content: json['content'] as String? ?? '',
      attribution: json['attribution'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$QuoteBlockImplToJson(_$QuoteBlockImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'attribution': instance.attribution,
      'createdAt': instance.createdAt.toIso8601String(),
      'type': instance.$type,
    };
