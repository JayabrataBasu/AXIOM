// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'canvas_element.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CanvasElement _$CanvasElementFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'standaloneBlock':
      return StandaloneBlock.fromJson(json);
    case 'container':
      return ContainerNode.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'CanvasElement',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$CanvasElement {
  String get id => throw _privateConstructorUsedError;
  Position get position => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<ElementLink> get links => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      Position position,
      @ContentBlockConverter() ContentBlock block,
      DateTime createdAt,
      DateTime updatedAt,
      List<ElementLink> links,
    )
    standaloneBlock,
    required TResult Function(
      String id,
      Position position,
      String name,
      DateTime createdAt,
      DateTime updatedAt,
      @ContentBlockListConverter2() List<ContentBlock> blocks,
      List<ElementLink> links,
    )
    container,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      Position position,
      @ContentBlockConverter() ContentBlock block,
      DateTime createdAt,
      DateTime updatedAt,
      List<ElementLink> links,
    )?
    standaloneBlock,
    TResult? Function(
      String id,
      Position position,
      String name,
      DateTime createdAt,
      DateTime updatedAt,
      @ContentBlockListConverter2() List<ContentBlock> blocks,
      List<ElementLink> links,
    )?
    container,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      Position position,
      @ContentBlockConverter() ContentBlock block,
      DateTime createdAt,
      DateTime updatedAt,
      List<ElementLink> links,
    )?
    standaloneBlock,
    TResult Function(
      String id,
      Position position,
      String name,
      DateTime createdAt,
      DateTime updatedAt,
      @ContentBlockListConverter2() List<ContentBlock> blocks,
      List<ElementLink> links,
    )?
    container,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StandaloneBlock value) standaloneBlock,
    required TResult Function(ContainerNode value) container,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StandaloneBlock value)? standaloneBlock,
    TResult? Function(ContainerNode value)? container,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StandaloneBlock value)? standaloneBlock,
    TResult Function(ContainerNode value)? container,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this CanvasElement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CanvasElementCopyWith<CanvasElement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CanvasElementCopyWith<$Res> {
  factory $CanvasElementCopyWith(
    CanvasElement value,
    $Res Function(CanvasElement) then,
  ) = _$CanvasElementCopyWithImpl<$Res, CanvasElement>;
  @useResult
  $Res call({
    String id,
    Position position,
    DateTime createdAt,
    DateTime updatedAt,
    List<ElementLink> links,
  });

  $PositionCopyWith<$Res> get position;
}

/// @nodoc
class _$CanvasElementCopyWithImpl<$Res, $Val extends CanvasElement>
    implements $CanvasElementCopyWith<$Res> {
  _$CanvasElementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? position = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? links = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as Position,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            links: null == links
                ? _value.links
                : links // ignore: cast_nullable_to_non_nullable
                      as List<ElementLink>,
          )
          as $Val,
    );
  }

  /// Create a copy of CanvasElement
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
abstract class _$$StandaloneBlockImplCopyWith<$Res>
    implements $CanvasElementCopyWith<$Res> {
  factory _$$StandaloneBlockImplCopyWith(
    _$StandaloneBlockImpl value,
    $Res Function(_$StandaloneBlockImpl) then,
  ) = __$$StandaloneBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    Position position,
    @ContentBlockConverter() ContentBlock block,
    DateTime createdAt,
    DateTime updatedAt,
    List<ElementLink> links,
  });

  @override
  $PositionCopyWith<$Res> get position;
  $ContentBlockCopyWith<$Res> get block;
}

/// @nodoc
class __$$StandaloneBlockImplCopyWithImpl<$Res>
    extends _$CanvasElementCopyWithImpl<$Res, _$StandaloneBlockImpl>
    implements _$$StandaloneBlockImplCopyWith<$Res> {
  __$$StandaloneBlockImplCopyWithImpl(
    _$StandaloneBlockImpl _value,
    $Res Function(_$StandaloneBlockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? position = null,
    Object? block = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? links = null,
  }) {
    return _then(
      _$StandaloneBlockImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as Position,
        block: null == block
            ? _value.block
            : block // ignore: cast_nullable_to_non_nullable
                  as ContentBlock,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        links: null == links
            ? _value._links
            : links // ignore: cast_nullable_to_non_nullable
                  as List<ElementLink>,
      ),
    );
  }

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContentBlockCopyWith<$Res> get block {
    return $ContentBlockCopyWith<$Res>(_value.block, (value) {
      return _then(_value.copyWith(block: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$StandaloneBlockImpl extends StandaloneBlock {
  const _$StandaloneBlockImpl({
    required this.id,
    required this.position,
    @ContentBlockConverter() required this.block,
    required this.createdAt,
    required this.updatedAt,
    final List<ElementLink> links = const [],
    final String? $type,
  }) : _links = links,
       $type = $type ?? 'standaloneBlock',
       super._();

  factory _$StandaloneBlockImpl.fromJson(Map<String, dynamic> json) =>
      _$$StandaloneBlockImplFromJson(json);

  @override
  final String id;
  @override
  final Position position;
  @override
  @ContentBlockConverter()
  final ContentBlock block;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<ElementLink> _links;
  @override
  @JsonKey()
  List<ElementLink> get links {
    if (_links is EqualUnmodifiableListView) return _links;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_links);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'CanvasElement.standaloneBlock(id: $id, position: $position, block: $block, createdAt: $createdAt, updatedAt: $updatedAt, links: $links)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StandaloneBlockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.block, block) || other.block == block) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._links, _links));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    position,
    block,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_links),
  );

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StandaloneBlockImplCopyWith<_$StandaloneBlockImpl> get copyWith =>
      __$$StandaloneBlockImplCopyWithImpl<_$StandaloneBlockImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      Position position,
      @ContentBlockConverter() ContentBlock block,
      DateTime createdAt,
      DateTime updatedAt,
      List<ElementLink> links,
    )
    standaloneBlock,
    required TResult Function(
      String id,
      Position position,
      String name,
      DateTime createdAt,
      DateTime updatedAt,
      @ContentBlockListConverter2() List<ContentBlock> blocks,
      List<ElementLink> links,
    )
    container,
  }) {
    return standaloneBlock(id, position, block, createdAt, updatedAt, links);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      Position position,
      @ContentBlockConverter() ContentBlock block,
      DateTime createdAt,
      DateTime updatedAt,
      List<ElementLink> links,
    )?
    standaloneBlock,
    TResult? Function(
      String id,
      Position position,
      String name,
      DateTime createdAt,
      DateTime updatedAt,
      @ContentBlockListConverter2() List<ContentBlock> blocks,
      List<ElementLink> links,
    )?
    container,
  }) {
    return standaloneBlock?.call(
      id,
      position,
      block,
      createdAt,
      updatedAt,
      links,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      Position position,
      @ContentBlockConverter() ContentBlock block,
      DateTime createdAt,
      DateTime updatedAt,
      List<ElementLink> links,
    )?
    standaloneBlock,
    TResult Function(
      String id,
      Position position,
      String name,
      DateTime createdAt,
      DateTime updatedAt,
      @ContentBlockListConverter2() List<ContentBlock> blocks,
      List<ElementLink> links,
    )?
    container,
    required TResult orElse(),
  }) {
    if (standaloneBlock != null) {
      return standaloneBlock(id, position, block, createdAt, updatedAt, links);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StandaloneBlock value) standaloneBlock,
    required TResult Function(ContainerNode value) container,
  }) {
    return standaloneBlock(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StandaloneBlock value)? standaloneBlock,
    TResult? Function(ContainerNode value)? container,
  }) {
    return standaloneBlock?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StandaloneBlock value)? standaloneBlock,
    TResult Function(ContainerNode value)? container,
    required TResult orElse(),
  }) {
    if (standaloneBlock != null) {
      return standaloneBlock(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StandaloneBlockImplToJson(this);
  }
}

abstract class StandaloneBlock extends CanvasElement {
  const factory StandaloneBlock({
    required final String id,
    required final Position position,
    @ContentBlockConverter() required final ContentBlock block,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final List<ElementLink> links,
  }) = _$StandaloneBlockImpl;
  const StandaloneBlock._() : super._();

  factory StandaloneBlock.fromJson(Map<String, dynamic> json) =
      _$StandaloneBlockImpl.fromJson;

  @override
  String get id;
  @override
  Position get position;
  @ContentBlockConverter()
  ContentBlock get block;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<ElementLink> get links;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StandaloneBlockImplCopyWith<_$StandaloneBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ContainerNodeImplCopyWith<$Res>
    implements $CanvasElementCopyWith<$Res> {
  factory _$$ContainerNodeImplCopyWith(
    _$ContainerNodeImpl value,
    $Res Function(_$ContainerNodeImpl) then,
  ) = __$$ContainerNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    Position position,
    String name,
    DateTime createdAt,
    DateTime updatedAt,
    @ContentBlockListConverter2() List<ContentBlock> blocks,
    List<ElementLink> links,
  });

  @override
  $PositionCopyWith<$Res> get position;
}

/// @nodoc
class __$$ContainerNodeImplCopyWithImpl<$Res>
    extends _$CanvasElementCopyWithImpl<$Res, _$ContainerNodeImpl>
    implements _$$ContainerNodeImplCopyWith<$Res> {
  __$$ContainerNodeImplCopyWithImpl(
    _$ContainerNodeImpl _value,
    $Res Function(_$ContainerNodeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? position = null,
    Object? name = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? blocks = null,
    Object? links = null,
  }) {
    return _then(
      _$ContainerNodeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as Position,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        blocks: null == blocks
            ? _value._blocks
            : blocks // ignore: cast_nullable_to_non_nullable
                  as List<ContentBlock>,
        links: null == links
            ? _value._links
            : links // ignore: cast_nullable_to_non_nullable
                  as List<ElementLink>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ContainerNodeImpl extends ContainerNode {
  const _$ContainerNodeImpl({
    required this.id,
    required this.position,
    this.name = '',
    required this.createdAt,
    required this.updatedAt,
    @ContentBlockListConverter2() final List<ContentBlock> blocks = const [],
    final List<ElementLink> links = const [],
    final String? $type,
  }) : _blocks = blocks,
       _links = links,
       $type = $type ?? 'container',
       super._();

  factory _$ContainerNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContainerNodeImplFromJson(json);

  @override
  final String id;
  @override
  final Position position;
  @override
  @JsonKey()
  final String name;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<ContentBlock> _blocks;
  @override
  @JsonKey()
  @ContentBlockListConverter2()
  List<ContentBlock> get blocks {
    if (_blocks is EqualUnmodifiableListView) return _blocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blocks);
  }

  final List<ElementLink> _links;
  @override
  @JsonKey()
  List<ElementLink> get links {
    if (_links is EqualUnmodifiableListView) return _links;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_links);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'CanvasElement.container(id: $id, position: $position, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, blocks: $blocks, links: $links)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContainerNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._blocks, _blocks) &&
            const DeepCollectionEquality().equals(other._links, _links));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    position,
    name,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_blocks),
    const DeepCollectionEquality().hash(_links),
  );

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContainerNodeImplCopyWith<_$ContainerNodeImpl> get copyWith =>
      __$$ContainerNodeImplCopyWithImpl<_$ContainerNodeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String id,
      Position position,
      @ContentBlockConverter() ContentBlock block,
      DateTime createdAt,
      DateTime updatedAt,
      List<ElementLink> links,
    )
    standaloneBlock,
    required TResult Function(
      String id,
      Position position,
      String name,
      DateTime createdAt,
      DateTime updatedAt,
      @ContentBlockListConverter2() List<ContentBlock> blocks,
      List<ElementLink> links,
    )
    container,
  }) {
    return container(id, position, name, createdAt, updatedAt, blocks, links);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String id,
      Position position,
      @ContentBlockConverter() ContentBlock block,
      DateTime createdAt,
      DateTime updatedAt,
      List<ElementLink> links,
    )?
    standaloneBlock,
    TResult? Function(
      String id,
      Position position,
      String name,
      DateTime createdAt,
      DateTime updatedAt,
      @ContentBlockListConverter2() List<ContentBlock> blocks,
      List<ElementLink> links,
    )?
    container,
  }) {
    return container?.call(
      id,
      position,
      name,
      createdAt,
      updatedAt,
      blocks,
      links,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String id,
      Position position,
      @ContentBlockConverter() ContentBlock block,
      DateTime createdAt,
      DateTime updatedAt,
      List<ElementLink> links,
    )?
    standaloneBlock,
    TResult Function(
      String id,
      Position position,
      String name,
      DateTime createdAt,
      DateTime updatedAt,
      @ContentBlockListConverter2() List<ContentBlock> blocks,
      List<ElementLink> links,
    )?
    container,
    required TResult orElse(),
  }) {
    if (container != null) {
      return container(id, position, name, createdAt, updatedAt, blocks, links);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StandaloneBlock value) standaloneBlock,
    required TResult Function(ContainerNode value) container,
  }) {
    return container(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StandaloneBlock value)? standaloneBlock,
    TResult? Function(ContainerNode value)? container,
  }) {
    return container?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StandaloneBlock value)? standaloneBlock,
    TResult Function(ContainerNode value)? container,
    required TResult orElse(),
  }) {
    if (container != null) {
      return container(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ContainerNodeImplToJson(this);
  }
}

abstract class ContainerNode extends CanvasElement {
  const factory ContainerNode({
    required final String id,
    required final Position position,
    final String name,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    @ContentBlockListConverter2() final List<ContentBlock> blocks,
    final List<ElementLink> links,
  }) = _$ContainerNodeImpl;
  const ContainerNode._() : super._();

  factory ContainerNode.fromJson(Map<String, dynamic> json) =
      _$ContainerNodeImpl.fromJson;

  @override
  String get id;
  @override
  Position get position;
  String get name;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @ContentBlockListConverter2()
  List<ContentBlock> get blocks;
  @override
  List<ElementLink> get links;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContainerNodeImplCopyWith<_$ContainerNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ElementLink _$ElementLinkFromJson(Map<String, dynamic> json) {
  return _ElementLink.fromJson(json);
}

/// @nodoc
mixin _$ElementLink {
  String get targetElementId => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  LinkType get type => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ElementLink to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ElementLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ElementLinkCopyWith<ElementLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ElementLinkCopyWith<$Res> {
  factory $ElementLinkCopyWith(
    ElementLink value,
    $Res Function(ElementLink) then,
  ) = _$ElementLinkCopyWithImpl<$Res, ElementLink>;
  @useResult
  $Res call({
    String targetElementId,
    String label,
    LinkType type,
    DateTime createdAt,
  });
}

/// @nodoc
class _$ElementLinkCopyWithImpl<$Res, $Val extends ElementLink>
    implements $ElementLinkCopyWith<$Res> {
  _$ElementLinkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ElementLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetElementId = null,
    Object? label = null,
    Object? type = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            targetElementId: null == targetElementId
                ? _value.targetElementId
                : targetElementId // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as LinkType,
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
abstract class _$$ElementLinkImplCopyWith<$Res>
    implements $ElementLinkCopyWith<$Res> {
  factory _$$ElementLinkImplCopyWith(
    _$ElementLinkImpl value,
    $Res Function(_$ElementLinkImpl) then,
  ) = __$$ElementLinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String targetElementId,
    String label,
    LinkType type,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$ElementLinkImplCopyWithImpl<$Res>
    extends _$ElementLinkCopyWithImpl<$Res, _$ElementLinkImpl>
    implements _$$ElementLinkImplCopyWith<$Res> {
  __$$ElementLinkImplCopyWithImpl(
    _$ElementLinkImpl _value,
    $Res Function(_$ElementLinkImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ElementLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetElementId = null,
    Object? label = null,
    Object? type = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$ElementLinkImpl(
        targetElementId: null == targetElementId
            ? _value.targetElementId
            : targetElementId // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as LinkType,
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
class _$ElementLinkImpl implements _ElementLink {
  const _$ElementLinkImpl({
    required this.targetElementId,
    this.label = '',
    this.type = LinkType.reference,
    required this.createdAt,
  });

  factory _$ElementLinkImpl.fromJson(Map<String, dynamic> json) =>
      _$$ElementLinkImplFromJson(json);

  @override
  final String targetElementId;
  @override
  @JsonKey()
  final String label;
  @override
  @JsonKey()
  final LinkType type;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ElementLink(targetElementId: $targetElementId, label: $label, type: $type, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ElementLinkImpl &&
            (identical(other.targetElementId, targetElementId) ||
                other.targetElementId == targetElementId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, targetElementId, label, type, createdAt);

  /// Create a copy of ElementLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ElementLinkImplCopyWith<_$ElementLinkImpl> get copyWith =>
      __$$ElementLinkImplCopyWithImpl<_$ElementLinkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ElementLinkImplToJson(this);
  }
}

abstract class _ElementLink implements ElementLink {
  const factory _ElementLink({
    required final String targetElementId,
    final String label,
    final LinkType type,
    required final DateTime createdAt,
  }) = _$ElementLinkImpl;

  factory _ElementLink.fromJson(Map<String, dynamic> json) =
      _$ElementLinkImpl.fromJson;

  @override
  String get targetElementId;
  @override
  String get label;
  @override
  LinkType get type;
  @override
  DateTime get createdAt;

  /// Create a copy of ElementLink
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ElementLinkImplCopyWith<_$ElementLinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
