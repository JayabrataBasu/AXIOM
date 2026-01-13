// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ContentBlock {
  String get id => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String content, DateTime createdAt)
    text,
    required TResult Function(
      String id,
      String content,
      int level,
      DateTime createdAt,
    )
    heading,
    required TResult Function(String id, List<String> items, DateTime createdAt)
    bulletList,
    required TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )
    code,
    required TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )
    quote,
    required TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )
    sketch,
    required TResult Function(String id, String latex, DateTime createdAt) math,
    required TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )
    audio,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String content, DateTime createdAt)? text,
    TResult? Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult? Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult? Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult? Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult? Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult? Function(String id, String latex, DateTime createdAt)? math,
    TResult? Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String content, DateTime createdAt)? text,
    TResult Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult Function(String id, String latex, DateTime createdAt)? math,
    TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextBlock value) text,
    required TResult Function(HeadingBlock value) heading,
    required TResult Function(BulletListBlock value) bulletList,
    required TResult Function(CodeBlock value) code,
    required TResult Function(QuoteBlock value) quote,
    required TResult Function(SketchBlock value) sketch,
    required TResult Function(MathBlock value) math,
    required TResult Function(AudioBlock value) audio,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TextBlock value)? text,
    TResult? Function(HeadingBlock value)? heading,
    TResult? Function(BulletListBlock value)? bulletList,
    TResult? Function(CodeBlock value)? code,
    TResult? Function(QuoteBlock value)? quote,
    TResult? Function(SketchBlock value)? sketch,
    TResult? Function(MathBlock value)? math,
    TResult? Function(AudioBlock value)? audio,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextBlock value)? text,
    TResult Function(HeadingBlock value)? heading,
    TResult Function(BulletListBlock value)? bulletList,
    TResult Function(CodeBlock value)? code,
    TResult Function(QuoteBlock value)? quote,
    TResult Function(SketchBlock value)? sketch,
    TResult Function(MathBlock value)? math,
    TResult Function(AudioBlock value)? audio,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentBlockCopyWith<ContentBlock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentBlockCopyWith<$Res> {
  factory $ContentBlockCopyWith(
    ContentBlock value,
    $Res Function(ContentBlock) then,
  ) = _$ContentBlockCopyWithImpl<$Res, ContentBlock>;
  @useResult
  $Res call({String id, DateTime createdAt});
}

/// @nodoc
class _$ContentBlockCopyWithImpl<$Res, $Val extends ContentBlock>
    implements $ContentBlockCopyWith<$Res> {
  _$ContentBlockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? createdAt = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TextBlockImplCopyWith<$Res>
    implements $ContentBlockCopyWith<$Res> {
  factory _$$TextBlockImplCopyWith(
    _$TextBlockImpl value,
    $Res Function(_$TextBlockImpl) then,
  ) = __$$TextBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String content, DateTime createdAt});
}

/// @nodoc
class __$$TextBlockImplCopyWithImpl<$Res>
    extends _$ContentBlockCopyWithImpl<$Res, _$TextBlockImpl>
    implements _$$TextBlockImplCopyWith<$Res> {
  __$$TextBlockImplCopyWithImpl(
    _$TextBlockImpl _value,
    $Res Function(_$TextBlockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$TextBlockImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
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

class _$TextBlockImpl extends TextBlock {
  const _$TextBlockImpl({
    required this.id,
    this.content = '',
    required this.createdAt,
  }) : super._();

  @override
  final String id;
  @override
  @JsonKey()
  final String content;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ContentBlock.text(id: $id, content: $content, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TextBlockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, content, createdAt);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TextBlockImplCopyWith<_$TextBlockImpl> get copyWith =>
      __$$TextBlockImplCopyWithImpl<_$TextBlockImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String content, DateTime createdAt)
    text,
    required TResult Function(
      String id,
      String content,
      int level,
      DateTime createdAt,
    )
    heading,
    required TResult Function(String id, List<String> items, DateTime createdAt)
    bulletList,
    required TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )
    code,
    required TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )
    quote,
    required TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )
    sketch,
    required TResult Function(String id, String latex, DateTime createdAt) math,
    required TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )
    audio,
  }) {
    return text(id, content, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String content, DateTime createdAt)? text,
    TResult? Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult? Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult? Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult? Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult? Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult? Function(String id, String latex, DateTime createdAt)? math,
    TResult? Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
  }) {
    return text?.call(id, content, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String content, DateTime createdAt)? text,
    TResult Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult Function(String id, String latex, DateTime createdAt)? math,
    TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(id, content, createdAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextBlock value) text,
    required TResult Function(HeadingBlock value) heading,
    required TResult Function(BulletListBlock value) bulletList,
    required TResult Function(CodeBlock value) code,
    required TResult Function(QuoteBlock value) quote,
    required TResult Function(SketchBlock value) sketch,
    required TResult Function(MathBlock value) math,
    required TResult Function(AudioBlock value) audio,
  }) {
    return text(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TextBlock value)? text,
    TResult? Function(HeadingBlock value)? heading,
    TResult? Function(BulletListBlock value)? bulletList,
    TResult? Function(CodeBlock value)? code,
    TResult? Function(QuoteBlock value)? quote,
    TResult? Function(SketchBlock value)? sketch,
    TResult? Function(MathBlock value)? math,
    TResult? Function(AudioBlock value)? audio,
  }) {
    return text?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextBlock value)? text,
    TResult Function(HeadingBlock value)? heading,
    TResult Function(BulletListBlock value)? bulletList,
    TResult Function(CodeBlock value)? code,
    TResult Function(QuoteBlock value)? quote,
    TResult Function(SketchBlock value)? sketch,
    TResult Function(MathBlock value)? math,
    TResult Function(AudioBlock value)? audio,
    required TResult orElse(),
  }) {
    if (text != null) {
      return text(this);
    }
    return orElse();
  }
}

abstract class TextBlock extends ContentBlock {
  const factory TextBlock({
    required final String id,
    final String content,
    required final DateTime createdAt,
  }) = _$TextBlockImpl;
  const TextBlock._() : super._();

  @override
  String get id;
  String get content;
  @override
  DateTime get createdAt;

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TextBlockImplCopyWith<_$TextBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HeadingBlockImplCopyWith<$Res>
    implements $ContentBlockCopyWith<$Res> {
  factory _$$HeadingBlockImplCopyWith(
    _$HeadingBlockImpl value,
    $Res Function(_$HeadingBlockImpl) then,
  ) = __$$HeadingBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String content, int level, DateTime createdAt});
}

/// @nodoc
class __$$HeadingBlockImplCopyWithImpl<$Res>
    extends _$ContentBlockCopyWithImpl<$Res, _$HeadingBlockImpl>
    implements _$$HeadingBlockImplCopyWith<$Res> {
  __$$HeadingBlockImplCopyWithImpl(
    _$HeadingBlockImpl _value,
    $Res Function(_$HeadingBlockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? level = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$HeadingBlockImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$HeadingBlockImpl extends HeadingBlock {
  const _$HeadingBlockImpl({
    required this.id,
    this.content = '',
    this.level = 1,
    required this.createdAt,
  }) : super._();

  @override
  final String id;
  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final int level;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ContentBlock.heading(id: $id, content: $content, level: $level, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeadingBlockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, content, level, createdAt);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeadingBlockImplCopyWith<_$HeadingBlockImpl> get copyWith =>
      __$$HeadingBlockImplCopyWithImpl<_$HeadingBlockImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String content, DateTime createdAt)
    text,
    required TResult Function(
      String id,
      String content,
      int level,
      DateTime createdAt,
    )
    heading,
    required TResult Function(String id, List<String> items, DateTime createdAt)
    bulletList,
    required TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )
    code,
    required TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )
    quote,
    required TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )
    sketch,
    required TResult Function(String id, String latex, DateTime createdAt) math,
    required TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )
    audio,
  }) {
    return heading(id, content, level, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String content, DateTime createdAt)? text,
    TResult? Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult? Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult? Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult? Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult? Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult? Function(String id, String latex, DateTime createdAt)? math,
    TResult? Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
  }) {
    return heading?.call(id, content, level, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String content, DateTime createdAt)? text,
    TResult Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult Function(String id, String latex, DateTime createdAt)? math,
    TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
    required TResult orElse(),
  }) {
    if (heading != null) {
      return heading(id, content, level, createdAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextBlock value) text,
    required TResult Function(HeadingBlock value) heading,
    required TResult Function(BulletListBlock value) bulletList,
    required TResult Function(CodeBlock value) code,
    required TResult Function(QuoteBlock value) quote,
    required TResult Function(SketchBlock value) sketch,
    required TResult Function(MathBlock value) math,
    required TResult Function(AudioBlock value) audio,
  }) {
    return heading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TextBlock value)? text,
    TResult? Function(HeadingBlock value)? heading,
    TResult? Function(BulletListBlock value)? bulletList,
    TResult? Function(CodeBlock value)? code,
    TResult? Function(QuoteBlock value)? quote,
    TResult? Function(SketchBlock value)? sketch,
    TResult? Function(MathBlock value)? math,
    TResult? Function(AudioBlock value)? audio,
  }) {
    return heading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextBlock value)? text,
    TResult Function(HeadingBlock value)? heading,
    TResult Function(BulletListBlock value)? bulletList,
    TResult Function(CodeBlock value)? code,
    TResult Function(QuoteBlock value)? quote,
    TResult Function(SketchBlock value)? sketch,
    TResult Function(MathBlock value)? math,
    TResult Function(AudioBlock value)? audio,
    required TResult orElse(),
  }) {
    if (heading != null) {
      return heading(this);
    }
    return orElse();
  }
}

abstract class HeadingBlock extends ContentBlock {
  const factory HeadingBlock({
    required final String id,
    final String content,
    final int level,
    required final DateTime createdAt,
  }) = _$HeadingBlockImpl;
  const HeadingBlock._() : super._();

  @override
  String get id;
  String get content;
  int get level;
  @override
  DateTime get createdAt;

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeadingBlockImplCopyWith<_$HeadingBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BulletListBlockImplCopyWith<$Res>
    implements $ContentBlockCopyWith<$Res> {
  factory _$$BulletListBlockImplCopyWith(
    _$BulletListBlockImpl value,
    $Res Function(_$BulletListBlockImpl) then,
  ) = __$$BulletListBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, List<String> items, DateTime createdAt});
}

/// @nodoc
class __$$BulletListBlockImplCopyWithImpl<$Res>
    extends _$ContentBlockCopyWithImpl<$Res, _$BulletListBlockImpl>
    implements _$$BulletListBlockImplCopyWith<$Res> {
  __$$BulletListBlockImplCopyWithImpl(
    _$BulletListBlockImpl _value,
    $Res Function(_$BulletListBlockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? items = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$BulletListBlockImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$BulletListBlockImpl extends BulletListBlock {
  const _$BulletListBlockImpl({
    required this.id,
    final List<String> items = const [],
    required this.createdAt,
  }) : _items = items,
       super._();

  @override
  final String id;
  final List<String> _items;
  @override
  @JsonKey()
  List<String> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ContentBlock.bulletList(id: $id, items: $items, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BulletListBlockImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    const DeepCollectionEquality().hash(_items),
    createdAt,
  );

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BulletListBlockImplCopyWith<_$BulletListBlockImpl> get copyWith =>
      __$$BulletListBlockImplCopyWithImpl<_$BulletListBlockImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String content, DateTime createdAt)
    text,
    required TResult Function(
      String id,
      String content,
      int level,
      DateTime createdAt,
    )
    heading,
    required TResult Function(String id, List<String> items, DateTime createdAt)
    bulletList,
    required TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )
    code,
    required TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )
    quote,
    required TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )
    sketch,
    required TResult Function(String id, String latex, DateTime createdAt) math,
    required TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )
    audio,
  }) {
    return bulletList(id, items, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String content, DateTime createdAt)? text,
    TResult? Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult? Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult? Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult? Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult? Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult? Function(String id, String latex, DateTime createdAt)? math,
    TResult? Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
  }) {
    return bulletList?.call(id, items, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String content, DateTime createdAt)? text,
    TResult Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult Function(String id, String latex, DateTime createdAt)? math,
    TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
    required TResult orElse(),
  }) {
    if (bulletList != null) {
      return bulletList(id, items, createdAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextBlock value) text,
    required TResult Function(HeadingBlock value) heading,
    required TResult Function(BulletListBlock value) bulletList,
    required TResult Function(CodeBlock value) code,
    required TResult Function(QuoteBlock value) quote,
    required TResult Function(SketchBlock value) sketch,
    required TResult Function(MathBlock value) math,
    required TResult Function(AudioBlock value) audio,
  }) {
    return bulletList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TextBlock value)? text,
    TResult? Function(HeadingBlock value)? heading,
    TResult? Function(BulletListBlock value)? bulletList,
    TResult? Function(CodeBlock value)? code,
    TResult? Function(QuoteBlock value)? quote,
    TResult? Function(SketchBlock value)? sketch,
    TResult? Function(MathBlock value)? math,
    TResult? Function(AudioBlock value)? audio,
  }) {
    return bulletList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextBlock value)? text,
    TResult Function(HeadingBlock value)? heading,
    TResult Function(BulletListBlock value)? bulletList,
    TResult Function(CodeBlock value)? code,
    TResult Function(QuoteBlock value)? quote,
    TResult Function(SketchBlock value)? sketch,
    TResult Function(MathBlock value)? math,
    TResult Function(AudioBlock value)? audio,
    required TResult orElse(),
  }) {
    if (bulletList != null) {
      return bulletList(this);
    }
    return orElse();
  }
}

abstract class BulletListBlock extends ContentBlock {
  const factory BulletListBlock({
    required final String id,
    final List<String> items,
    required final DateTime createdAt,
  }) = _$BulletListBlockImpl;
  const BulletListBlock._() : super._();

  @override
  String get id;
  List<String> get items;
  @override
  DateTime get createdAt;

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BulletListBlockImplCopyWith<_$BulletListBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CodeBlockImplCopyWith<$Res>
    implements $ContentBlockCopyWith<$Res> {
  factory _$$CodeBlockImplCopyWith(
    _$CodeBlockImpl value,
    $Res Function(_$CodeBlockImpl) then,
  ) = __$$CodeBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String content, String language, DateTime createdAt});
}

/// @nodoc
class __$$CodeBlockImplCopyWithImpl<$Res>
    extends _$ContentBlockCopyWithImpl<$Res, _$CodeBlockImpl>
    implements _$$CodeBlockImplCopyWith<$Res> {
  __$$CodeBlockImplCopyWithImpl(
    _$CodeBlockImpl _value,
    $Res Function(_$CodeBlockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? language = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$CodeBlockImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        language: null == language
            ? _value.language
            : language // ignore: cast_nullable_to_non_nullable
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

class _$CodeBlockImpl extends CodeBlock {
  const _$CodeBlockImpl({
    required this.id,
    this.content = '',
    this.language = '',
    required this.createdAt,
  }) : super._();

  @override
  final String id;
  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final String language;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ContentBlock.code(id: $id, content: $content, language: $language, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CodeBlockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, content, language, createdAt);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CodeBlockImplCopyWith<_$CodeBlockImpl> get copyWith =>
      __$$CodeBlockImplCopyWithImpl<_$CodeBlockImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String content, DateTime createdAt)
    text,
    required TResult Function(
      String id,
      String content,
      int level,
      DateTime createdAt,
    )
    heading,
    required TResult Function(String id, List<String> items, DateTime createdAt)
    bulletList,
    required TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )
    code,
    required TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )
    quote,
    required TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )
    sketch,
    required TResult Function(String id, String latex, DateTime createdAt) math,
    required TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )
    audio,
  }) {
    return code(id, content, language, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String content, DateTime createdAt)? text,
    TResult? Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult? Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult? Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult? Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult? Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult? Function(String id, String latex, DateTime createdAt)? math,
    TResult? Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
  }) {
    return code?.call(id, content, language, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String content, DateTime createdAt)? text,
    TResult Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult Function(String id, String latex, DateTime createdAt)? math,
    TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
    required TResult orElse(),
  }) {
    if (code != null) {
      return code(id, content, language, createdAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextBlock value) text,
    required TResult Function(HeadingBlock value) heading,
    required TResult Function(BulletListBlock value) bulletList,
    required TResult Function(CodeBlock value) code,
    required TResult Function(QuoteBlock value) quote,
    required TResult Function(SketchBlock value) sketch,
    required TResult Function(MathBlock value) math,
    required TResult Function(AudioBlock value) audio,
  }) {
    return code(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TextBlock value)? text,
    TResult? Function(HeadingBlock value)? heading,
    TResult? Function(BulletListBlock value)? bulletList,
    TResult? Function(CodeBlock value)? code,
    TResult? Function(QuoteBlock value)? quote,
    TResult? Function(SketchBlock value)? sketch,
    TResult? Function(MathBlock value)? math,
    TResult? Function(AudioBlock value)? audio,
  }) {
    return code?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextBlock value)? text,
    TResult Function(HeadingBlock value)? heading,
    TResult Function(BulletListBlock value)? bulletList,
    TResult Function(CodeBlock value)? code,
    TResult Function(QuoteBlock value)? quote,
    TResult Function(SketchBlock value)? sketch,
    TResult Function(MathBlock value)? math,
    TResult Function(AudioBlock value)? audio,
    required TResult orElse(),
  }) {
    if (code != null) {
      return code(this);
    }
    return orElse();
  }
}

abstract class CodeBlock extends ContentBlock {
  const factory CodeBlock({
    required final String id,
    final String content,
    final String language,
    required final DateTime createdAt,
  }) = _$CodeBlockImpl;
  const CodeBlock._() : super._();

  @override
  String get id;
  String get content;
  String get language;
  @override
  DateTime get createdAt;

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CodeBlockImplCopyWith<_$CodeBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$QuoteBlockImplCopyWith<$Res>
    implements $ContentBlockCopyWith<$Res> {
  factory _$$QuoteBlockImplCopyWith(
    _$QuoteBlockImpl value,
    $Res Function(_$QuoteBlockImpl) then,
  ) = __$$QuoteBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String content,
    String attribution,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$QuoteBlockImplCopyWithImpl<$Res>
    extends _$ContentBlockCopyWithImpl<$Res, _$QuoteBlockImpl>
    implements _$$QuoteBlockImplCopyWith<$Res> {
  __$$QuoteBlockImplCopyWithImpl(
    _$QuoteBlockImpl _value,
    $Res Function(_$QuoteBlockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? attribution = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$QuoteBlockImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        attribution: null == attribution
            ? _value.attribution
            : attribution // ignore: cast_nullable_to_non_nullable
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

class _$QuoteBlockImpl extends QuoteBlock {
  const _$QuoteBlockImpl({
    required this.id,
    this.content = '',
    this.attribution = '',
    required this.createdAt,
  }) : super._();

  @override
  final String id;
  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final String attribution;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ContentBlock.quote(id: $id, content: $content, attribution: $attribution, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuoteBlockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.attribution, attribution) ||
                other.attribution == attribution) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, content, attribution, createdAt);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuoteBlockImplCopyWith<_$QuoteBlockImpl> get copyWith =>
      __$$QuoteBlockImplCopyWithImpl<_$QuoteBlockImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String content, DateTime createdAt)
    text,
    required TResult Function(
      String id,
      String content,
      int level,
      DateTime createdAt,
    )
    heading,
    required TResult Function(String id, List<String> items, DateTime createdAt)
    bulletList,
    required TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )
    code,
    required TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )
    quote,
    required TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )
    sketch,
    required TResult Function(String id, String latex, DateTime createdAt) math,
    required TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )
    audio,
  }) {
    return quote(id, content, attribution, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String content, DateTime createdAt)? text,
    TResult? Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult? Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult? Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult? Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult? Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult? Function(String id, String latex, DateTime createdAt)? math,
    TResult? Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
  }) {
    return quote?.call(id, content, attribution, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String content, DateTime createdAt)? text,
    TResult Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult Function(String id, String latex, DateTime createdAt)? math,
    TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
    required TResult orElse(),
  }) {
    if (quote != null) {
      return quote(id, content, attribution, createdAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextBlock value) text,
    required TResult Function(HeadingBlock value) heading,
    required TResult Function(BulletListBlock value) bulletList,
    required TResult Function(CodeBlock value) code,
    required TResult Function(QuoteBlock value) quote,
    required TResult Function(SketchBlock value) sketch,
    required TResult Function(MathBlock value) math,
    required TResult Function(AudioBlock value) audio,
  }) {
    return quote(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TextBlock value)? text,
    TResult? Function(HeadingBlock value)? heading,
    TResult? Function(BulletListBlock value)? bulletList,
    TResult? Function(CodeBlock value)? code,
    TResult? Function(QuoteBlock value)? quote,
    TResult? Function(SketchBlock value)? sketch,
    TResult? Function(MathBlock value)? math,
    TResult? Function(AudioBlock value)? audio,
  }) {
    return quote?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextBlock value)? text,
    TResult Function(HeadingBlock value)? heading,
    TResult Function(BulletListBlock value)? bulletList,
    TResult Function(CodeBlock value)? code,
    TResult Function(QuoteBlock value)? quote,
    TResult Function(SketchBlock value)? sketch,
    TResult Function(MathBlock value)? math,
    TResult Function(AudioBlock value)? audio,
    required TResult orElse(),
  }) {
    if (quote != null) {
      return quote(this);
    }
    return orElse();
  }
}

abstract class QuoteBlock extends ContentBlock {
  const factory QuoteBlock({
    required final String id,
    final String content,
    final String attribution,
    required final DateTime createdAt,
  }) = _$QuoteBlockImpl;
  const QuoteBlock._() : super._();

  @override
  String get id;
  String get content;
  String get attribution;
  @override
  DateTime get createdAt;

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuoteBlockImplCopyWith<_$QuoteBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SketchBlockImplCopyWith<$Res>
    implements $ContentBlockCopyWith<$Res> {
  factory _$$SketchBlockImplCopyWith(
    _$SketchBlockImpl value,
    $Res Function(_$SketchBlockImpl) then,
  ) = __$$SketchBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String strokeFile,
    String thumbnailFile,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$SketchBlockImplCopyWithImpl<$Res>
    extends _$ContentBlockCopyWithImpl<$Res, _$SketchBlockImpl>
    implements _$$SketchBlockImplCopyWith<$Res> {
  __$$SketchBlockImplCopyWithImpl(
    _$SketchBlockImpl _value,
    $Res Function(_$SketchBlockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? strokeFile = null,
    Object? thumbnailFile = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$SketchBlockImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        strokeFile: null == strokeFile
            ? _value.strokeFile
            : strokeFile // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnailFile: null == thumbnailFile
            ? _value.thumbnailFile
            : thumbnailFile // ignore: cast_nullable_to_non_nullable
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

class _$SketchBlockImpl extends SketchBlock {
  const _$SketchBlockImpl({
    required this.id,
    required this.strokeFile,
    this.thumbnailFile = '',
    required this.createdAt,
  }) : super._();

  @override
  final String id;
  @override
  final String strokeFile;
  @override
  @JsonKey()
  final String thumbnailFile;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ContentBlock.sketch(id: $id, strokeFile: $strokeFile, thumbnailFile: $thumbnailFile, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SketchBlockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.strokeFile, strokeFile) ||
                other.strokeFile == strokeFile) &&
            (identical(other.thumbnailFile, thumbnailFile) ||
                other.thumbnailFile == thumbnailFile) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, strokeFile, thumbnailFile, createdAt);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SketchBlockImplCopyWith<_$SketchBlockImpl> get copyWith =>
      __$$SketchBlockImplCopyWithImpl<_$SketchBlockImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String content, DateTime createdAt)
    text,
    required TResult Function(
      String id,
      String content,
      int level,
      DateTime createdAt,
    )
    heading,
    required TResult Function(String id, List<String> items, DateTime createdAt)
    bulletList,
    required TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )
    code,
    required TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )
    quote,
    required TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )
    sketch,
    required TResult Function(String id, String latex, DateTime createdAt) math,
    required TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )
    audio,
  }) {
    return sketch(id, strokeFile, thumbnailFile, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String content, DateTime createdAt)? text,
    TResult? Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult? Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult? Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult? Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult? Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult? Function(String id, String latex, DateTime createdAt)? math,
    TResult? Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
  }) {
    return sketch?.call(id, strokeFile, thumbnailFile, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String content, DateTime createdAt)? text,
    TResult Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult Function(String id, String latex, DateTime createdAt)? math,
    TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
    required TResult orElse(),
  }) {
    if (sketch != null) {
      return sketch(id, strokeFile, thumbnailFile, createdAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextBlock value) text,
    required TResult Function(HeadingBlock value) heading,
    required TResult Function(BulletListBlock value) bulletList,
    required TResult Function(CodeBlock value) code,
    required TResult Function(QuoteBlock value) quote,
    required TResult Function(SketchBlock value) sketch,
    required TResult Function(MathBlock value) math,
    required TResult Function(AudioBlock value) audio,
  }) {
    return sketch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TextBlock value)? text,
    TResult? Function(HeadingBlock value)? heading,
    TResult? Function(BulletListBlock value)? bulletList,
    TResult? Function(CodeBlock value)? code,
    TResult? Function(QuoteBlock value)? quote,
    TResult? Function(SketchBlock value)? sketch,
    TResult? Function(MathBlock value)? math,
    TResult? Function(AudioBlock value)? audio,
  }) {
    return sketch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextBlock value)? text,
    TResult Function(HeadingBlock value)? heading,
    TResult Function(BulletListBlock value)? bulletList,
    TResult Function(CodeBlock value)? code,
    TResult Function(QuoteBlock value)? quote,
    TResult Function(SketchBlock value)? sketch,
    TResult Function(MathBlock value)? math,
    TResult Function(AudioBlock value)? audio,
    required TResult orElse(),
  }) {
    if (sketch != null) {
      return sketch(this);
    }
    return orElse();
  }
}

abstract class SketchBlock extends ContentBlock {
  const factory SketchBlock({
    required final String id,
    required final String strokeFile,
    final String thumbnailFile,
    required final DateTime createdAt,
  }) = _$SketchBlockImpl;
  const SketchBlock._() : super._();

  @override
  String get id;
  String get strokeFile;
  String get thumbnailFile;
  @override
  DateTime get createdAt;

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SketchBlockImplCopyWith<_$SketchBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MathBlockImplCopyWith<$Res>
    implements $ContentBlockCopyWith<$Res> {
  factory _$$MathBlockImplCopyWith(
    _$MathBlockImpl value,
    $Res Function(_$MathBlockImpl) then,
  ) = __$$MathBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String latex, DateTime createdAt});
}

/// @nodoc
class __$$MathBlockImplCopyWithImpl<$Res>
    extends _$ContentBlockCopyWithImpl<$Res, _$MathBlockImpl>
    implements _$$MathBlockImplCopyWith<$Res> {
  __$$MathBlockImplCopyWithImpl(
    _$MathBlockImpl _value,
    $Res Function(_$MathBlockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? latex = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$MathBlockImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        latex: null == latex
            ? _value.latex
            : latex // ignore: cast_nullable_to_non_nullable
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

class _$MathBlockImpl extends MathBlock {
  const _$MathBlockImpl({
    required this.id,
    this.latex = '',
    required this.createdAt,
  }) : super._();

  @override
  final String id;
  @override
  @JsonKey()
  final String latex;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ContentBlock.math(id: $id, latex: $latex, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MathBlockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.latex, latex) || other.latex == latex) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, latex, createdAt);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MathBlockImplCopyWith<_$MathBlockImpl> get copyWith =>
      __$$MathBlockImplCopyWithImpl<_$MathBlockImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String content, DateTime createdAt)
    text,
    required TResult Function(
      String id,
      String content,
      int level,
      DateTime createdAt,
    )
    heading,
    required TResult Function(String id, List<String> items, DateTime createdAt)
    bulletList,
    required TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )
    code,
    required TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )
    quote,
    required TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )
    sketch,
    required TResult Function(String id, String latex, DateTime createdAt) math,
    required TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )
    audio,
  }) {
    return math(id, latex, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String content, DateTime createdAt)? text,
    TResult? Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult? Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult? Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult? Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult? Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult? Function(String id, String latex, DateTime createdAt)? math,
    TResult? Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
  }) {
    return math?.call(id, latex, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String content, DateTime createdAt)? text,
    TResult Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult Function(String id, String latex, DateTime createdAt)? math,
    TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
    required TResult orElse(),
  }) {
    if (math != null) {
      return math(id, latex, createdAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextBlock value) text,
    required TResult Function(HeadingBlock value) heading,
    required TResult Function(BulletListBlock value) bulletList,
    required TResult Function(CodeBlock value) code,
    required TResult Function(QuoteBlock value) quote,
    required TResult Function(SketchBlock value) sketch,
    required TResult Function(MathBlock value) math,
    required TResult Function(AudioBlock value) audio,
  }) {
    return math(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TextBlock value)? text,
    TResult? Function(HeadingBlock value)? heading,
    TResult? Function(BulletListBlock value)? bulletList,
    TResult? Function(CodeBlock value)? code,
    TResult? Function(QuoteBlock value)? quote,
    TResult? Function(SketchBlock value)? sketch,
    TResult? Function(MathBlock value)? math,
    TResult? Function(AudioBlock value)? audio,
  }) {
    return math?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextBlock value)? text,
    TResult Function(HeadingBlock value)? heading,
    TResult Function(BulletListBlock value)? bulletList,
    TResult Function(CodeBlock value)? code,
    TResult Function(QuoteBlock value)? quote,
    TResult Function(SketchBlock value)? sketch,
    TResult Function(MathBlock value)? math,
    TResult Function(AudioBlock value)? audio,
    required TResult orElse(),
  }) {
    if (math != null) {
      return math(this);
    }
    return orElse();
  }
}

abstract class MathBlock extends ContentBlock {
  const factory MathBlock({
    required final String id,
    final String latex,
    required final DateTime createdAt,
  }) = _$MathBlockImpl;
  const MathBlock._() : super._();

  @override
  String get id;
  String get latex;
  @override
  DateTime get createdAt;

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MathBlockImplCopyWith<_$MathBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AudioBlockImplCopyWith<$Res>
    implements $ContentBlockCopyWith<$Res> {
  factory _$$AudioBlockImplCopyWith(
    _$AudioBlockImpl value,
    $Res Function(_$AudioBlockImpl) then,
  ) = __$$AudioBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String audioFile, int durationMs, DateTime createdAt});
}

/// @nodoc
class __$$AudioBlockImplCopyWithImpl<$Res>
    extends _$ContentBlockCopyWithImpl<$Res, _$AudioBlockImpl>
    implements _$$AudioBlockImplCopyWith<$Res> {
  __$$AudioBlockImplCopyWithImpl(
    _$AudioBlockImpl _value,
    $Res Function(_$AudioBlockImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? audioFile = null,
    Object? durationMs = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$AudioBlockImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        audioFile: null == audioFile
            ? _value.audioFile
            : audioFile // ignore: cast_nullable_to_non_nullable
                  as String,
        durationMs: null == durationMs
            ? _value.durationMs
            : durationMs // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$AudioBlockImpl extends AudioBlock {
  const _$AudioBlockImpl({
    required this.id,
    required this.audioFile,
    this.durationMs = 0,
    required this.createdAt,
  }) : super._();

  @override
  final String id;
  @override
  final String audioFile;
  @override
  @JsonKey()
  final int durationMs;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ContentBlock.audio(id: $id, audioFile: $audioFile, durationMs: $durationMs, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioBlockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.audioFile, audioFile) ||
                other.audioFile == audioFile) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, audioFile, durationMs, createdAt);

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioBlockImplCopyWith<_$AudioBlockImpl> get copyWith =>
      __$$AudioBlockImplCopyWithImpl<_$AudioBlockImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String content, DateTime createdAt)
    text,
    required TResult Function(
      String id,
      String content,
      int level,
      DateTime createdAt,
    )
    heading,
    required TResult Function(String id, List<String> items, DateTime createdAt)
    bulletList,
    required TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )
    code,
    required TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )
    quote,
    required TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )
    sketch,
    required TResult Function(String id, String latex, DateTime createdAt) math,
    required TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )
    audio,
  }) {
    return audio(id, audioFile, durationMs, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String content, DateTime createdAt)? text,
    TResult? Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult? Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult? Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult? Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult? Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult? Function(String id, String latex, DateTime createdAt)? math,
    TResult? Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
  }) {
    return audio?.call(id, audioFile, durationMs, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String content, DateTime createdAt)? text,
    TResult Function(String id, String content, int level, DateTime createdAt)?
    heading,
    TResult Function(String id, List<String> items, DateTime createdAt)?
    bulletList,
    TResult Function(
      String id,
      String content,
      String language,
      DateTime createdAt,
    )?
    code,
    TResult Function(
      String id,
      String content,
      String attribution,
      DateTime createdAt,
    )?
    quote,
    TResult Function(
      String id,
      String strokeFile,
      String thumbnailFile,
      DateTime createdAt,
    )?
    sketch,
    TResult Function(String id, String latex, DateTime createdAt)? math,
    TResult Function(
      String id,
      String audioFile,
      int durationMs,
      DateTime createdAt,
    )?
    audio,
    required TResult orElse(),
  }) {
    if (audio != null) {
      return audio(id, audioFile, durationMs, createdAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextBlock value) text,
    required TResult Function(HeadingBlock value) heading,
    required TResult Function(BulletListBlock value) bulletList,
    required TResult Function(CodeBlock value) code,
    required TResult Function(QuoteBlock value) quote,
    required TResult Function(SketchBlock value) sketch,
    required TResult Function(MathBlock value) math,
    required TResult Function(AudioBlock value) audio,
  }) {
    return audio(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TextBlock value)? text,
    TResult? Function(HeadingBlock value)? heading,
    TResult? Function(BulletListBlock value)? bulletList,
    TResult? Function(CodeBlock value)? code,
    TResult? Function(QuoteBlock value)? quote,
    TResult? Function(SketchBlock value)? sketch,
    TResult? Function(MathBlock value)? math,
    TResult? Function(AudioBlock value)? audio,
  }) {
    return audio?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextBlock value)? text,
    TResult Function(HeadingBlock value)? heading,
    TResult Function(BulletListBlock value)? bulletList,
    TResult Function(CodeBlock value)? code,
    TResult Function(QuoteBlock value)? quote,
    TResult Function(SketchBlock value)? sketch,
    TResult Function(MathBlock value)? math,
    TResult Function(AudioBlock value)? audio,
    required TResult orElse(),
  }) {
    if (audio != null) {
      return audio(this);
    }
    return orElse();
  }
}

abstract class AudioBlock extends ContentBlock {
  const factory AudioBlock({
    required final String id,
    required final String audioFile,
    final int durationMs,
    required final DateTime createdAt,
  }) = _$AudioBlockImpl;
  const AudioBlock._() : super._();

  @override
  String get id;
  String get audioFile;
  int get durationMs;
  @override
  DateTime get createdAt;

  /// Create a copy of ContentBlock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AudioBlockImplCopyWith<_$AudioBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
