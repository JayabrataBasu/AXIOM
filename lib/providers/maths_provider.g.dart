// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maths_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mathsServiceHash() => r'27c6ae7674616249fcabda070b1d8ce36c77ef4b';

/// Provider for MathsService
///
/// Copied from [mathsService].
@ProviderFor(mathsService)
final mathsServiceProvider = AutoDisposeProvider<MathsService>.internal(
  mathsService,
  name: r'mathsServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mathsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MathsServiceRef = AutoDisposeProviderRef<MathsService>;
String _$mathsObjectHash() => r'7c16fee32e4d6e68e04c92f637612da22455886e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Async provider to load a specific maths object
///
/// Copied from [mathsObject].
@ProviderFor(mathsObject)
const mathsObjectProvider = MathsObjectFamily();

/// Async provider to load a specific maths object
///
/// Copied from [mathsObject].
class MathsObjectFamily extends Family<AsyncValue<MathsObject?>> {
  /// Async provider to load a specific maths object
  ///
  /// Copied from [mathsObject].
  const MathsObjectFamily();

  /// Async provider to load a specific maths object
  ///
  /// Copied from [mathsObject].
  MathsObjectProvider call({
    required String workspaceId,
    required String mathsObjectId,
  }) {
    return MathsObjectProvider(
      workspaceId: workspaceId,
      mathsObjectId: mathsObjectId,
    );
  }

  @override
  MathsObjectProvider getProviderOverride(
    covariant MathsObjectProvider provider,
  ) {
    return call(
      workspaceId: provider.workspaceId,
      mathsObjectId: provider.mathsObjectId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mathsObjectProvider';
}

/// Async provider to load a specific maths object
///
/// Copied from [mathsObject].
class MathsObjectProvider extends AutoDisposeFutureProvider<MathsObject?> {
  /// Async provider to load a specific maths object
  ///
  /// Copied from [mathsObject].
  MathsObjectProvider({
    required String workspaceId,
    required String mathsObjectId,
  }) : this._internal(
         (ref) => mathsObject(
           ref as MathsObjectRef,
           workspaceId: workspaceId,
           mathsObjectId: mathsObjectId,
         ),
         from: mathsObjectProvider,
         name: r'mathsObjectProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$mathsObjectHash,
         dependencies: MathsObjectFamily._dependencies,
         allTransitiveDependencies:
             MathsObjectFamily._allTransitiveDependencies,
         workspaceId: workspaceId,
         mathsObjectId: mathsObjectId,
       );

  MathsObjectProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workspaceId,
    required this.mathsObjectId,
  }) : super.internal();

  final String workspaceId;
  final String mathsObjectId;

  @override
  Override overrideWith(
    FutureOr<MathsObject?> Function(MathsObjectRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MathsObjectProvider._internal(
        (ref) => create(ref as MathsObjectRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workspaceId: workspaceId,
        mathsObjectId: mathsObjectId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MathsObject?> createElement() {
    return _MathsObjectProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MathsObjectProvider &&
        other.workspaceId == workspaceId &&
        other.mathsObjectId == mathsObjectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workspaceId.hashCode);
    hash = _SystemHash.combine(hash, mathsObjectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MathsObjectRef on AutoDisposeFutureProviderRef<MathsObject?> {
  /// The parameter `workspaceId` of this provider.
  String get workspaceId;

  /// The parameter `mathsObjectId` of this provider.
  String get mathsObjectId;
}

class _MathsObjectProviderElement
    extends AutoDisposeFutureProviderElement<MathsObject?>
    with MathsObjectRef {
  _MathsObjectProviderElement(super.provider);

  @override
  String get workspaceId => (origin as MathsObjectProvider).workspaceId;
  @override
  String get mathsObjectId => (origin as MathsObjectProvider).mathsObjectId;
}

String _$mathsObjectsListHash() => r'c6f7042b145e22ffc0cfb5a66f4b7c713f1c5b1c';

/// Async provider to list all maths objects in a workspace
///
/// Copied from [mathsObjectsList].
@ProviderFor(mathsObjectsList)
const mathsObjectsListProvider = MathsObjectsListFamily();

/// Async provider to list all maths objects in a workspace
///
/// Copied from [mathsObjectsList].
class MathsObjectsListFamily extends Family<AsyncValue<List<MathsObject>>> {
  /// Async provider to list all maths objects in a workspace
  ///
  /// Copied from [mathsObjectsList].
  const MathsObjectsListFamily();

  /// Async provider to list all maths objects in a workspace
  ///
  /// Copied from [mathsObjectsList].
  MathsObjectsListProvider call(String workspaceId) {
    return MathsObjectsListProvider(workspaceId);
  }

  @override
  MathsObjectsListProvider getProviderOverride(
    covariant MathsObjectsListProvider provider,
  ) {
    return call(provider.workspaceId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mathsObjectsListProvider';
}

/// Async provider to list all maths objects in a workspace
///
/// Copied from [mathsObjectsList].
class MathsObjectsListProvider
    extends AutoDisposeFutureProvider<List<MathsObject>> {
  /// Async provider to list all maths objects in a workspace
  ///
  /// Copied from [mathsObjectsList].
  MathsObjectsListProvider(String workspaceId)
    : this._internal(
        (ref) => mathsObjectsList(ref as MathsObjectsListRef, workspaceId),
        from: mathsObjectsListProvider,
        name: r'mathsObjectsListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$mathsObjectsListHash,
        dependencies: MathsObjectsListFamily._dependencies,
        allTransitiveDependencies:
            MathsObjectsListFamily._allTransitiveDependencies,
        workspaceId: workspaceId,
      );

  MathsObjectsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workspaceId,
  }) : super.internal();

  final String workspaceId;

  @override
  Override overrideWith(
    FutureOr<List<MathsObject>> Function(MathsObjectsListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MathsObjectsListProvider._internal(
        (ref) => create(ref as MathsObjectsListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workspaceId: workspaceId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MathsObject>> createElement() {
    return _MathsObjectsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MathsObjectsListProvider &&
        other.workspaceId == workspaceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workspaceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MathsObjectsListRef on AutoDisposeFutureProviderRef<List<MathsObject>> {
  /// The parameter `workspaceId` of this provider.
  String get workspaceId;
}

class _MathsObjectsListProviderElement
    extends AutoDisposeFutureProviderElement<List<MathsObject>>
    with MathsObjectsListRef {
  _MathsObjectsListProviderElement(super.provider);

  @override
  String get workspaceId => (origin as MathsObjectsListProvider).workspaceId;
}

String _$mathsObjectNotifierProviderHash() =>
    r'56bf5a7680289c9a85630c193189c7ca753d5cc8';

abstract class _$MathsObjectNotifierProvider
    extends BuildlessAutoDisposeAsyncNotifier<MathsObject> {
  late final String workspaceId;
  late final String mathsObjectId;

  FutureOr<MathsObject> build({
    required String workspaceId,
    required String mathsObjectId,
  });
}

/// Provider for managing a specific maths object with operations
///
/// Copied from [MathsObjectNotifierProvider].
@ProviderFor(MathsObjectNotifierProvider)
const mathsObjectNotifierProviderProvider = MathsObjectNotifierProviderFamily();

/// Provider for managing a specific maths object with operations
///
/// Copied from [MathsObjectNotifierProvider].
class MathsObjectNotifierProviderFamily
    extends Family<AsyncValue<MathsObject>> {
  /// Provider for managing a specific maths object with operations
  ///
  /// Copied from [MathsObjectNotifierProvider].
  const MathsObjectNotifierProviderFamily();

  /// Provider for managing a specific maths object with operations
  ///
  /// Copied from [MathsObjectNotifierProvider].
  MathsObjectNotifierProviderProvider call({
    required String workspaceId,
    required String mathsObjectId,
  }) {
    return MathsObjectNotifierProviderProvider(
      workspaceId: workspaceId,
      mathsObjectId: mathsObjectId,
    );
  }

  @override
  MathsObjectNotifierProviderProvider getProviderOverride(
    covariant MathsObjectNotifierProviderProvider provider,
  ) {
    return call(
      workspaceId: provider.workspaceId,
      mathsObjectId: provider.mathsObjectId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mathsObjectNotifierProviderProvider';
}

/// Provider for managing a specific maths object with operations
///
/// Copied from [MathsObjectNotifierProvider].
class MathsObjectNotifierProviderProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          MathsObjectNotifierProvider,
          MathsObject
        > {
  /// Provider for managing a specific maths object with operations
  ///
  /// Copied from [MathsObjectNotifierProvider].
  MathsObjectNotifierProviderProvider({
    required String workspaceId,
    required String mathsObjectId,
  }) : this._internal(
         () => MathsObjectNotifierProvider()
           ..workspaceId = workspaceId
           ..mathsObjectId = mathsObjectId,
         from: mathsObjectNotifierProviderProvider,
         name: r'mathsObjectNotifierProviderProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$mathsObjectNotifierProviderHash,
         dependencies: MathsObjectNotifierProviderFamily._dependencies,
         allTransitiveDependencies:
             MathsObjectNotifierProviderFamily._allTransitiveDependencies,
         workspaceId: workspaceId,
         mathsObjectId: mathsObjectId,
       );

  MathsObjectNotifierProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workspaceId,
    required this.mathsObjectId,
  }) : super.internal();

  final String workspaceId;
  final String mathsObjectId;

  @override
  FutureOr<MathsObject> runNotifierBuild(
    covariant MathsObjectNotifierProvider notifier,
  ) {
    return notifier.build(
      workspaceId: workspaceId,
      mathsObjectId: mathsObjectId,
    );
  }

  @override
  Override overrideWith(MathsObjectNotifierProvider Function() create) {
    return ProviderOverride(
      origin: this,
      override: MathsObjectNotifierProviderProvider._internal(
        () => create()
          ..workspaceId = workspaceId
          ..mathsObjectId = mathsObjectId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workspaceId: workspaceId,
        mathsObjectId: mathsObjectId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    MathsObjectNotifierProvider,
    MathsObject
  >
  createElement() {
    return _MathsObjectNotifierProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MathsObjectNotifierProviderProvider &&
        other.workspaceId == workspaceId &&
        other.mathsObjectId == mathsObjectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workspaceId.hashCode);
    hash = _SystemHash.combine(hash, mathsObjectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MathsObjectNotifierProviderRef
    on AutoDisposeAsyncNotifierProviderRef<MathsObject> {
  /// The parameter `workspaceId` of this provider.
  String get workspaceId;

  /// The parameter `mathsObjectId` of this provider.
  String get mathsObjectId;
}

class _MathsObjectNotifierProviderProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          MathsObjectNotifierProvider,
          MathsObject
        >
    with MathsObjectNotifierProviderRef {
  _MathsObjectNotifierProviderProviderElement(super.provider);

  @override
  String get workspaceId =>
      (origin as MathsObjectNotifierProviderProvider).workspaceId;
  @override
  String get mathsObjectId =>
      (origin as MathsObjectNotifierProviderProvider).mathsObjectId;
}

String _$activeMathsWorkspaceHash() =>
    r'429c03fc3f4b8b2fef90895f8b4f2f1cab1fc053';

/// Provider for the active maths workspace
///
/// Copied from [ActiveMathsWorkspace].
@ProviderFor(ActiveMathsWorkspace)
final activeMathsWorkspaceProvider =
    AutoDisposeNotifierProvider<ActiveMathsWorkspace, String>.internal(
      ActiveMathsWorkspace.new,
      name: r'activeMathsWorkspaceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeMathsWorkspaceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveMathsWorkspace = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
