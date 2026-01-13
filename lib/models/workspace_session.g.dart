// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkspaceSessionImpl _$$WorkspaceSessionImplFromJson(
  Map<String, dynamic> json,
) => _$WorkspaceSessionImpl(
  id: json['id'] as String,
  workspaceType: json['workspaceType'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  parentSessionId: json['parentSessionId'] as String?,
  data: json['data'] as Map<String, dynamic>,
  label: json['label'] as String? ?? '',
);

Map<String, dynamic> _$$WorkspaceSessionImplToJson(
  _$WorkspaceSessionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'workspaceType': instance.workspaceType,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'parentSessionId': instance.parentSessionId,
  'data': instance.data,
  'label': instance.label,
};
