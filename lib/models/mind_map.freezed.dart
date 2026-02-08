// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mind_map.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MindMapNode _$MindMapNodeFromJson(Map<String, dynamic> json) {
  return _MindMapNode.fromJson(json);
}

/// @nodoc
mixin _$MindMapNode {
  /// Unique identifier for this node
  String get id => throw _privateConstructorUsedError;

  /// Parent node ID (null for root node)
  String? get parentId => throw _privateConstructorUsedError;

  /// Node text content
  String get text => throw _privateConstructorUsedError;

  /// Position in the mind map canvas
  Position get position => throw _privateConstructorUsedError;

  /// Visual styling
  MindMapNodeStyle get style => throw _privateConstructorUsedError;

  /// Child node IDs
  List<String> get childIds => throw _privateConstructorUsedError;

  /// Whether this node is collapsed (children hidden)
  bool get collapsed => throw _privateConstructorUsedError;

  /// Priority level: 'none', 'low', 'high', 'urgent'
  String get priority => throw _privateConstructorUsedError;

  /// Timestamp when created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Timestamp when last modified
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MindMapNode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MindMapNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MindMapNodeCopyWith<MindMapNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MindMapNodeCopyWith<$Res> {
  factory $MindMapNodeCopyWith(
    MindMapNode value,
    $Res Function(MindMapNode) then,
  ) = _$MindMapNodeCopyWithImpl<$Res, MindMapNode>;
  @useResult
  $Res call({
    String id,
    String? parentId,
    String text,
    Position position,
    MindMapNodeStyle style,
    List<String> childIds,
    bool collapsed,
    String priority,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $PositionCopyWith<$Res> get position;
  $MindMapNodeStyleCopyWith<$Res> get style;
}

/// @nodoc
class _$MindMapNodeCopyWithImpl<$Res, $Val extends MindMapNode>
    implements $MindMapNodeCopyWith<$Res> {
  _$MindMapNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MindMapNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = freezed,
    Object? text = null,
    Object? position = null,
    Object? style = null,
    Object? childIds = null,
    Object? collapsed = null,
    Object? priority = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as Position,
            style: null == style
                ? _value.style
                : style // ignore: cast_nullable_to_non_nullable
                      as MindMapNodeStyle,
            childIds: null == childIds
                ? _value.childIds
                : childIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            collapsed: null == collapsed
                ? _value.collapsed
                : collapsed // ignore: cast_nullable_to_non_nullable
                      as bool,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of MindMapNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PositionCopyWith<$Res> get position {
    return $PositionCopyWith<$Res>(_value.position, (value) {
      return _then(_value.copyWith(position: value) as $Val);
    });
  }

  /// Create a copy of MindMapNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MindMapNodeStyleCopyWith<$Res> get style {
    return $MindMapNodeStyleCopyWith<$Res>(_value.style, (value) {
      return _then(_value.copyWith(style: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MindMapNodeImplCopyWith<$Res>
    implements $MindMapNodeCopyWith<$Res> {
  factory _$$MindMapNodeImplCopyWith(
    _$MindMapNodeImpl value,
    $Res Function(_$MindMapNodeImpl) then,
  ) = __$$MindMapNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? parentId,
    String text,
    Position position,
    MindMapNodeStyle style,
    List<String> childIds,
    bool collapsed,
    String priority,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $PositionCopyWith<$Res> get position;
  @override
  $MindMapNodeStyleCopyWith<$Res> get style;
}

/// @nodoc
class __$$MindMapNodeImplCopyWithImpl<$Res>
    extends _$MindMapNodeCopyWithImpl<$Res, _$MindMapNodeImpl>
    implements _$$MindMapNodeImplCopyWith<$Res> {
  __$$MindMapNodeImplCopyWithImpl(
    _$MindMapNodeImpl _value,
    $Res Function(_$MindMapNodeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MindMapNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = freezed,
    Object? text = null,
    Object? position = null,
    Object? style = null,
    Object? childIds = null,
    Object? collapsed = null,
    Object? priority = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$MindMapNodeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as Position,
        style: null == style
            ? _value.style
            : style // ignore: cast_nullable_to_non_nullable
                  as MindMapNodeStyle,
        childIds: null == childIds
            ? _value._childIds
            : childIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        collapsed: null == collapsed
            ? _value.collapsed
            : collapsed // ignore: cast_nullable_to_non_nullable
                  as bool,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MindMapNodeImpl extends _MindMapNode {
  const _$MindMapNodeImpl({
    required this.id,
    this.parentId,
    required this.text,
    this.position = const Position(),
    this.style = const MindMapNodeStyle(),
    final List<String> childIds = const [],
    this.collapsed = false,
    this.priority = 'none',
    required this.createdAt,
    required this.updatedAt,
  }) : _childIds = childIds,
       super._();

  factory _$MindMapNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$MindMapNodeImplFromJson(json);

  /// Unique identifier for this node
  @override
  final String id;

  /// Parent node ID (null for root node)
  @override
  final String? parentId;

  /// Node text content
  @override
  final String text;

  /// Position in the mind map canvas
  @override
  @JsonKey()
  final Position position;

  /// Visual styling
  @override
  @JsonKey()
  final MindMapNodeStyle style;

  /// Child node IDs
  final List<String> _childIds;

  /// Child node IDs
  @override
  @JsonKey()
  List<String> get childIds {
    if (_childIds is EqualUnmodifiableListView) return _childIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childIds);
  }

  /// Whether this node is collapsed (children hidden)
  @override
  @JsonKey()
  final bool collapsed;

  /// Priority level: 'none', 'low', 'high', 'urgent'
  @override
  @JsonKey()
  final String priority;

  /// Timestamp when created
  @override
  final DateTime createdAt;

  /// Timestamp when last modified
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MindMapNode(id: $id, parentId: $parentId, text: $text, position: $position, style: $style, childIds: $childIds, collapsed: $collapsed, priority: $priority, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MindMapNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.style, style) || other.style == style) &&
            const DeepCollectionEquality().equals(other._childIds, _childIds) &&
            (identical(other.collapsed, collapsed) ||
                other.collapsed == collapsed) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    parentId,
    text,
    position,
    style,
    const DeepCollectionEquality().hash(_childIds),
    collapsed,
    priority,
    createdAt,
    updatedAt,
  );

  /// Create a copy of MindMapNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MindMapNodeImplCopyWith<_$MindMapNodeImpl> get copyWith =>
      __$$MindMapNodeImplCopyWithImpl<_$MindMapNodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MindMapNodeImplToJson(this);
  }
}

abstract class _MindMapNode extends MindMapNode {
  const factory _MindMapNode({
    required final String id,
    final String? parentId,
    required final String text,
    final Position position,
    final MindMapNodeStyle style,
    final List<String> childIds,
    final bool collapsed,
    final String priority,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$MindMapNodeImpl;
  const _MindMapNode._() : super._();

  factory _MindMapNode.fromJson(Map<String, dynamic> json) =
      _$MindMapNodeImpl.fromJson;

  /// Unique identifier for this node
  @override
  String get id;

  /// Parent node ID (null for root node)
  @override
  String? get parentId;

  /// Node text content
  @override
  String get text;

  /// Position in the mind map canvas
  @override
  Position get position;

  /// Visual styling
  @override
  MindMapNodeStyle get style;

  /// Child node IDs
  @override
  List<String> get childIds;

  /// Whether this node is collapsed (children hidden)
  @override
  bool get collapsed;

  /// Priority level: 'none', 'low', 'high', 'urgent'
  @override
  String get priority;

  /// Timestamp when created
  @override
  DateTime get createdAt;

  /// Timestamp when last modified
  @override
  DateTime get updatedAt;

  /// Create a copy of MindMapNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MindMapNodeImplCopyWith<_$MindMapNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MindMapNodeStyle _$MindMapNodeStyleFromJson(Map<String, dynamic> json) {
  return _MindMapNodeStyle.fromJson(json);
}

/// @nodoc
mixin _$MindMapNodeStyle {
  /// Background color as ARGB int (Everforest light parchment by default)
  int get backgroundColor => throw _privateConstructorUsedError;

  /// Text color as ARGB int
  int get textColor => throw _privateConstructorUsedError;

  /// Border color as ARGB int (Everforest primary green)
  int get borderColor => throw _privateConstructorUsedError;

  /// Border width
  double get borderWidth => throw _privateConstructorUsedError;

  /// Shape: 'rounded', 'rectangle', 'circle', 'diamond'
  String get shape => throw _privateConstructorUsedError;

  /// Optional emoji icon for the node (single character)
  String get emoji => throw _privateConstructorUsedError;

  /// Serializes this MindMapNodeStyle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MindMapNodeStyle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MindMapNodeStyleCopyWith<MindMapNodeStyle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MindMapNodeStyleCopyWith<$Res> {
  factory $MindMapNodeStyleCopyWith(
    MindMapNodeStyle value,
    $Res Function(MindMapNodeStyle) then,
  ) = _$MindMapNodeStyleCopyWithImpl<$Res, MindMapNodeStyle>;
  @useResult
  $Res call({
    int backgroundColor,
    int textColor,
    int borderColor,
    double borderWidth,
    String shape,
    String emoji,
  });
}

/// @nodoc
class _$MindMapNodeStyleCopyWithImpl<$Res, $Val extends MindMapNodeStyle>
    implements $MindMapNodeStyleCopyWith<$Res> {
  _$MindMapNodeStyleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MindMapNodeStyle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backgroundColor = null,
    Object? textColor = null,
    Object? borderColor = null,
    Object? borderWidth = null,
    Object? shape = null,
    Object? emoji = null,
  }) {
    return _then(
      _value.copyWith(
            backgroundColor: null == backgroundColor
                ? _value.backgroundColor
                : backgroundColor // ignore: cast_nullable_to_non_nullable
                      as int,
            textColor: null == textColor
                ? _value.textColor
                : textColor // ignore: cast_nullable_to_non_nullable
                      as int,
            borderColor: null == borderColor
                ? _value.borderColor
                : borderColor // ignore: cast_nullable_to_non_nullable
                      as int,
            borderWidth: null == borderWidth
                ? _value.borderWidth
                : borderWidth // ignore: cast_nullable_to_non_nullable
                      as double,
            shape: null == shape
                ? _value.shape
                : shape // ignore: cast_nullable_to_non_nullable
                      as String,
            emoji: null == emoji
                ? _value.emoji
                : emoji // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MindMapNodeStyleImplCopyWith<$Res>
    implements $MindMapNodeStyleCopyWith<$Res> {
  factory _$$MindMapNodeStyleImplCopyWith(
    _$MindMapNodeStyleImpl value,
    $Res Function(_$MindMapNodeStyleImpl) then,
  ) = __$$MindMapNodeStyleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int backgroundColor,
    int textColor,
    int borderColor,
    double borderWidth,
    String shape,
    String emoji,
  });
}

/// @nodoc
class __$$MindMapNodeStyleImplCopyWithImpl<$Res>
    extends _$MindMapNodeStyleCopyWithImpl<$Res, _$MindMapNodeStyleImpl>
    implements _$$MindMapNodeStyleImplCopyWith<$Res> {
  __$$MindMapNodeStyleImplCopyWithImpl(
    _$MindMapNodeStyleImpl _value,
    $Res Function(_$MindMapNodeStyleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MindMapNodeStyle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backgroundColor = null,
    Object? textColor = null,
    Object? borderColor = null,
    Object? borderWidth = null,
    Object? shape = null,
    Object? emoji = null,
  }) {
    return _then(
      _$MindMapNodeStyleImpl(
        backgroundColor: null == backgroundColor
            ? _value.backgroundColor
            : backgroundColor // ignore: cast_nullable_to_non_nullable
                  as int,
        textColor: null == textColor
            ? _value.textColor
            : textColor // ignore: cast_nullable_to_non_nullable
                  as int,
        borderColor: null == borderColor
            ? _value.borderColor
            : borderColor // ignore: cast_nullable_to_non_nullable
                  as int,
        borderWidth: null == borderWidth
            ? _value.borderWidth
            : borderWidth // ignore: cast_nullable_to_non_nullable
                  as double,
        shape: null == shape
            ? _value.shape
            : shape // ignore: cast_nullable_to_non_nullable
                  as String,
        emoji: null == emoji
            ? _value.emoji
            : emoji // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MindMapNodeStyleImpl implements _MindMapNodeStyle {
  const _$MindMapNodeStyleImpl({
    this.backgroundColor = 0xFFFDF6E3,
    this.textColor = 0xFF000000,
    this.borderColor = 0xFF708238,
    this.borderWidth = 2.0,
    this.shape = 'rounded',
    this.emoji = '',
  });

  factory _$MindMapNodeStyleImpl.fromJson(Map<String, dynamic> json) =>
      _$$MindMapNodeStyleImplFromJson(json);

  /// Background color as ARGB int (Everforest light parchment by default)
  @override
  @JsonKey()
  final int backgroundColor;

  /// Text color as ARGB int
  @override
  @JsonKey()
  final int textColor;

  /// Border color as ARGB int (Everforest primary green)
  @override
  @JsonKey()
  final int borderColor;

  /// Border width
  @override
  @JsonKey()
  final double borderWidth;

  /// Shape: 'rounded', 'rectangle', 'circle', 'diamond'
  @override
  @JsonKey()
  final String shape;

  /// Optional emoji icon for the node (single character)
  @override
  @JsonKey()
  final String emoji;

  @override
  String toString() {
    return 'MindMapNodeStyle(backgroundColor: $backgroundColor, textColor: $textColor, borderColor: $borderColor, borderWidth: $borderWidth, shape: $shape, emoji: $emoji)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MindMapNodeStyleImpl &&
            (identical(other.backgroundColor, backgroundColor) ||
                other.backgroundColor == backgroundColor) &&
            (identical(other.textColor, textColor) ||
                other.textColor == textColor) &&
            (identical(other.borderColor, borderColor) ||
                other.borderColor == borderColor) &&
            (identical(other.borderWidth, borderWidth) ||
                other.borderWidth == borderWidth) &&
            (identical(other.shape, shape) || other.shape == shape) &&
            (identical(other.emoji, emoji) || other.emoji == emoji));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    backgroundColor,
    textColor,
    borderColor,
    borderWidth,
    shape,
    emoji,
  );

  /// Create a copy of MindMapNodeStyle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MindMapNodeStyleImplCopyWith<_$MindMapNodeStyleImpl> get copyWith =>
      __$$MindMapNodeStyleImplCopyWithImpl<_$MindMapNodeStyleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MindMapNodeStyleImplToJson(this);
  }
}

abstract class _MindMapNodeStyle implements MindMapNodeStyle {
  const factory _MindMapNodeStyle({
    final int backgroundColor,
    final int textColor,
    final int borderColor,
    final double borderWidth,
    final String shape,
    final String emoji,
  }) = _$MindMapNodeStyleImpl;

  factory _MindMapNodeStyle.fromJson(Map<String, dynamic> json) =
      _$MindMapNodeStyleImpl.fromJson;

  /// Background color as ARGB int (Everforest light parchment by default)
  @override
  int get backgroundColor;

  /// Text color as ARGB int
  @override
  int get textColor;

  /// Border color as ARGB int (Everforest primary green)
  @override
  int get borderColor;

  /// Border width
  @override
  double get borderWidth;

  /// Shape: 'rounded', 'rectangle', 'circle', 'diamond'
  @override
  String get shape;

  /// Optional emoji icon for the node (single character)
  @override
  String get emoji;

  /// Create a copy of MindMapNodeStyle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MindMapNodeStyleImplCopyWith<_$MindMapNodeStyleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MindMapGraph _$MindMapGraphFromJson(Map<String, dynamic> json) {
  return _MindMapGraph.fromJson(json);
}

/// @nodoc
mixin _$MindMapGraph {
  /// Unique identifier for this mind map
  String get id => throw _privateConstructorUsedError;

  /// Display name
  String get name => throw _privateConstructorUsedError;

  /// Workspace this map belongs to
  String get workspaceId => throw _privateConstructorUsedError;

  /// Root node ID
  String? get rootNodeId => throw _privateConstructorUsedError;

  /// All nodes in the graph (keyed by node ID)
  Map<String, MindMapNode> get nodes => throw _privateConstructorUsedError;

  /// Timestamp when created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Timestamp when last modified
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MindMapGraph to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MindMapGraph
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MindMapGraphCopyWith<MindMapGraph> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MindMapGraphCopyWith<$Res> {
  factory $MindMapGraphCopyWith(
    MindMapGraph value,
    $Res Function(MindMapGraph) then,
  ) = _$MindMapGraphCopyWithImpl<$Res, MindMapGraph>;
  @useResult
  $Res call({
    String id,
    String name,
    String workspaceId,
    String? rootNodeId,
    Map<String, MindMapNode> nodes,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$MindMapGraphCopyWithImpl<$Res, $Val extends MindMapGraph>
    implements $MindMapGraphCopyWith<$Res> {
  _$MindMapGraphCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MindMapGraph
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? workspaceId = null,
    Object? rootNodeId = freezed,
    Object? nodes = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            workspaceId: null == workspaceId
                ? _value.workspaceId
                : workspaceId // ignore: cast_nullable_to_non_nullable
                      as String,
            rootNodeId: freezed == rootNodeId
                ? _value.rootNodeId
                : rootNodeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            nodes: null == nodes
                ? _value.nodes
                : nodes // ignore: cast_nullable_to_non_nullable
                      as Map<String, MindMapNode>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MindMapGraphImplCopyWith<$Res>
    implements $MindMapGraphCopyWith<$Res> {
  factory _$$MindMapGraphImplCopyWith(
    _$MindMapGraphImpl value,
    $Res Function(_$MindMapGraphImpl) then,
  ) = __$$MindMapGraphImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String workspaceId,
    String? rootNodeId,
    Map<String, MindMapNode> nodes,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$MindMapGraphImplCopyWithImpl<$Res>
    extends _$MindMapGraphCopyWithImpl<$Res, _$MindMapGraphImpl>
    implements _$$MindMapGraphImplCopyWith<$Res> {
  __$$MindMapGraphImplCopyWithImpl(
    _$MindMapGraphImpl _value,
    $Res Function(_$MindMapGraphImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MindMapGraph
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? workspaceId = null,
    Object? rootNodeId = freezed,
    Object? nodes = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$MindMapGraphImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        workspaceId: null == workspaceId
            ? _value.workspaceId
            : workspaceId // ignore: cast_nullable_to_non_nullable
                  as String,
        rootNodeId: freezed == rootNodeId
            ? _value.rootNodeId
            : rootNodeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        nodes: null == nodes
            ? _value._nodes
            : nodes // ignore: cast_nullable_to_non_nullable
                  as Map<String, MindMapNode>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MindMapGraphImpl extends _MindMapGraph {
  const _$MindMapGraphImpl({
    required this.id,
    required this.name,
    required this.workspaceId,
    this.rootNodeId,
    final Map<String, MindMapNode> nodes = const {},
    required this.createdAt,
    required this.updatedAt,
  }) : _nodes = nodes,
       super._();

  factory _$MindMapGraphImpl.fromJson(Map<String, dynamic> json) =>
      _$$MindMapGraphImplFromJson(json);

  /// Unique identifier for this mind map
  @override
  final String id;

  /// Display name
  @override
  final String name;

  /// Workspace this map belongs to
  @override
  final String workspaceId;

  /// Root node ID
  @override
  final String? rootNodeId;

  /// All nodes in the graph (keyed by node ID)
  final Map<String, MindMapNode> _nodes;

  /// All nodes in the graph (keyed by node ID)
  @override
  @JsonKey()
  Map<String, MindMapNode> get nodes {
    if (_nodes is EqualUnmodifiableMapView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nodes);
  }

  /// Timestamp when created
  @override
  final DateTime createdAt;

  /// Timestamp when last modified
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MindMapGraph(id: $id, name: $name, workspaceId: $workspaceId, rootNodeId: $rootNodeId, nodes: $nodes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MindMapGraphImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.rootNodeId, rootNodeId) ||
                other.rootNodeId == rootNodeId) &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    workspaceId,
    rootNodeId,
    const DeepCollectionEquality().hash(_nodes),
    createdAt,
    updatedAt,
  );

  /// Create a copy of MindMapGraph
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MindMapGraphImplCopyWith<_$MindMapGraphImpl> get copyWith =>
      __$$MindMapGraphImplCopyWithImpl<_$MindMapGraphImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MindMapGraphImplToJson(this);
  }
}

abstract class _MindMapGraph extends MindMapGraph {
  const factory _MindMapGraph({
    required final String id,
    required final String name,
    required final String workspaceId,
    final String? rootNodeId,
    final Map<String, MindMapNode> nodes,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$MindMapGraphImpl;
  const _MindMapGraph._() : super._();

  factory _MindMapGraph.fromJson(Map<String, dynamic> json) =
      _$MindMapGraphImpl.fromJson;

  /// Unique identifier for this mind map
  @override
  String get id;

  /// Display name
  @override
  String get name;

  /// Workspace this map belongs to
  @override
  String get workspaceId;

  /// Root node ID
  @override
  String? get rootNodeId;

  /// All nodes in the graph (keyed by node ID)
  @override
  Map<String, MindMapNode> get nodes;

  /// Timestamp when created
  @override
  DateTime get createdAt;

  /// Timestamp when last modified
  @override
  DateTime get updatedAt;

  /// Create a copy of MindMapGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MindMapGraphImplCopyWith<_$MindMapGraphImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
