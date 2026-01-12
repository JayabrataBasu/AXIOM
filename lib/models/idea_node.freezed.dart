// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'idea_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

IdeaNode _$IdeaNodeFromJson(Map<String, dynamic> json) {
  return _IdeaNode.fromJson(json);
}

/// @nodoc
mixin _$IdeaNode {
  /// Unique identifier for this node
  String get id => throw _privateConstructorUsedError;

  /// Timestamp when this node was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Timestamp when this node was last modified
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Position on the canvas
  Position get position => throw _privateConstructorUsedError;

  /// Ordered list of content blocks
  List<ContentBlock> get blocks => throw _privateConstructorUsedError;

  /// Links to other IdeaNodes (Stage 9)
  List<NodeLink> get links => throw _privateConstructorUsedError;

  /// Serializes this IdeaNode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IdeaNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IdeaNodeCopyWith<IdeaNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IdeaNodeCopyWith<$Res> {
  factory $IdeaNodeCopyWith(IdeaNode value, $Res Function(IdeaNode) then) =
      _$IdeaNodeCopyWithImpl<$Res, IdeaNode>;
  @useResult
  $Res call({
    String id,
    DateTime createdAt,
    DateTime updatedAt,
    Position position,
    List<ContentBlock> blocks,
    List<NodeLink> links,
  });

  $PositionCopyWith<$Res> get position;
}

/// @nodoc
class _$IdeaNodeCopyWithImpl<$Res, $Val extends IdeaNode>
    implements $IdeaNodeCopyWith<$Res> {
  _$IdeaNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IdeaNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? position = null,
    Object? blocks = null,
    Object? links = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as Position,
            blocks: null == blocks
                ? _value.blocks
                : blocks // ignore: cast_nullable_to_non_nullable
                      as List<ContentBlock>,
            links: null == links
                ? _value.links
                : links // ignore: cast_nullable_to_non_nullable
                      as List<NodeLink>,
          )
          as $Val,
    );
  }

  /// Create a copy of IdeaNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PositionCopyWith<$Res> get position {
    return $PositionCopyWith<$Res>(_value.position, (value) {
      return _then(_value.copyWith(position: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$IdeaNodeImplCopyWith<$Res>
    implements $IdeaNodeCopyWith<$Res> {
  factory _$$IdeaNodeImplCopyWith(
    _$IdeaNodeImpl value,
    $Res Function(_$IdeaNodeImpl) then,
  ) = __$$IdeaNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime createdAt,
    DateTime updatedAt,
    Position position,
    List<ContentBlock> blocks,
    List<NodeLink> links,
  });

  @override
  $PositionCopyWith<$Res> get position;
}

/// @nodoc
class __$$IdeaNodeImplCopyWithImpl<$Res>
    extends _$IdeaNodeCopyWithImpl<$Res, _$IdeaNodeImpl>
    implements _$$IdeaNodeImplCopyWith<$Res> {
  __$$IdeaNodeImplCopyWithImpl(
    _$IdeaNodeImpl _value,
    $Res Function(_$IdeaNodeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IdeaNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? position = null,
    Object? blocks = null,
    Object? links = null,
  }) {
    return _then(
      _$IdeaNodeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as Position,
        blocks: null == blocks
            ? _value._blocks
            : blocks // ignore: cast_nullable_to_non_nullable
                  as List<ContentBlock>,
        links: null == links
            ? _value._links
            : links // ignore: cast_nullable_to_non_nullable
                  as List<NodeLink>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$IdeaNodeImpl extends _IdeaNode {
  const _$IdeaNodeImpl({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.position = const Position(),
    final List<ContentBlock> blocks = const [],
    final List<NodeLink> links = const [],
  }) : _blocks = blocks,
       _links = links,
       super._();

  factory _$IdeaNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$IdeaNodeImplFromJson(json);

  /// Unique identifier for this node
  @override
  final String id;

  /// Timestamp when this node was created
  @override
  final DateTime createdAt;

  /// Timestamp when this node was last modified
  @override
  final DateTime updatedAt;

  /// Position on the canvas
  @override
  @JsonKey()
  final Position position;

  /// Ordered list of content blocks
  final List<ContentBlock> _blocks;

  /// Ordered list of content blocks
  @override
  @JsonKey()
  List<ContentBlock> get blocks {
    if (_blocks is EqualUnmodifiableListView) return _blocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blocks);
  }

  /// Links to other IdeaNodes (Stage 9)
  final List<NodeLink> _links;

  /// Links to other IdeaNodes (Stage 9)
  @override
  @JsonKey()
  List<NodeLink> get links {
    if (_links is EqualUnmodifiableListView) return _links;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_links);
  }

  @override
  String toString() {
    return 'IdeaNode(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, position: $position, blocks: $blocks, links: $links)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IdeaNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.position, position) ||
                other.position == position) &&
            const DeepCollectionEquality().equals(other._blocks, _blocks) &&
            const DeepCollectionEquality().equals(other._links, _links));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    createdAt,
    updatedAt,
    position,
    const DeepCollectionEquality().hash(_blocks),
    const DeepCollectionEquality().hash(_links),
  );

  /// Create a copy of IdeaNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IdeaNodeImplCopyWith<_$IdeaNodeImpl> get copyWith =>
      __$$IdeaNodeImplCopyWithImpl<_$IdeaNodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IdeaNodeImplToJson(this);
  }
}

abstract class _IdeaNode extends IdeaNode {
  const factory _IdeaNode({
    required final String id,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final Position position,
    final List<ContentBlock> blocks,
    final List<NodeLink> links,
  }) = _$IdeaNodeImpl;
  const _IdeaNode._() : super._();

  factory _IdeaNode.fromJson(Map<String, dynamic> json) =
      _$IdeaNodeImpl.fromJson;

  /// Unique identifier for this node
  @override
  String get id;

  /// Timestamp when this node was created
  @override
  DateTime get createdAt;

  /// Timestamp when this node was last modified
  @override
  DateTime get updatedAt;

  /// Position on the canvas
  @override
  Position get position;

  /// Ordered list of content blocks
  @override
  List<ContentBlock> get blocks;

  /// Links to other IdeaNodes (Stage 9)
  @override
  List<NodeLink> get links;

  /// Create a copy of IdeaNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IdeaNodeImplCopyWith<_$IdeaNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NodeLink _$NodeLinkFromJson(Map<String, dynamic> json) {
  return _NodeLink.fromJson(json);
}

/// @nodoc
mixin _$NodeLink {
  String get targetNodeId => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this NodeLink to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NodeLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NodeLinkCopyWith<NodeLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeLinkCopyWith<$Res> {
  factory $NodeLinkCopyWith(NodeLink value, $Res Function(NodeLink) then) =
      _$NodeLinkCopyWithImpl<$Res, NodeLink>;
  @useResult
  $Res call({String targetNodeId, String label, DateTime createdAt});
}

/// @nodoc
class _$NodeLinkCopyWithImpl<$Res, $Val extends NodeLink>
    implements $NodeLinkCopyWith<$Res> {
  _$NodeLinkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NodeLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetNodeId = null,
    Object? label = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            targetNodeId: null == targetNodeId
                ? _value.targetNodeId
                : targetNodeId // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NodeLinkImplCopyWith<$Res>
    implements $NodeLinkCopyWith<$Res> {
  factory _$$NodeLinkImplCopyWith(
    _$NodeLinkImpl value,
    $Res Function(_$NodeLinkImpl) then,
  ) = __$$NodeLinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String targetNodeId, String label, DateTime createdAt});
}

/// @nodoc
class __$$NodeLinkImplCopyWithImpl<$Res>
    extends _$NodeLinkCopyWithImpl<$Res, _$NodeLinkImpl>
    implements _$$NodeLinkImplCopyWith<$Res> {
  __$$NodeLinkImplCopyWithImpl(
    _$NodeLinkImpl _value,
    $Res Function(_$NodeLinkImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NodeLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetNodeId = null,
    Object? label = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$NodeLinkImpl(
        targetNodeId: null == targetNodeId
            ? _value.targetNodeId
            : targetNodeId // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NodeLinkImpl implements _NodeLink {
  const _$NodeLinkImpl({
    required this.targetNodeId,
    this.label = '',
    required this.createdAt,
  });

  factory _$NodeLinkImpl.fromJson(Map<String, dynamic> json) =>
      _$$NodeLinkImplFromJson(json);

  @override
  final String targetNodeId;
  @override
  @JsonKey()
  final String label;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'NodeLink(targetNodeId: $targetNodeId, label: $label, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodeLinkImpl &&
            (identical(other.targetNodeId, targetNodeId) ||
                other.targetNodeId == targetNodeId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, targetNodeId, label, createdAt);

  /// Create a copy of NodeLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NodeLinkImplCopyWith<_$NodeLinkImpl> get copyWith =>
      __$$NodeLinkImplCopyWithImpl<_$NodeLinkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NodeLinkImplToJson(this);
  }
}

abstract class _NodeLink implements NodeLink {
  const factory _NodeLink({
    required final String targetNodeId,
    final String label,
    required final DateTime createdAt,
  }) = _$NodeLinkImpl;

  factory _NodeLink.fromJson(Map<String, dynamic> json) =
      _$NodeLinkImpl.fromJson;

  @override
  String get targetNodeId;
  @override
  String get label;
  @override
  DateTime get createdAt;

  /// Create a copy of NodeLink
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NodeLinkImplCopyWith<_$NodeLinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
