import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/maths.dart';
import '../services/file_service.dart';
import '../services/maths_service.dart';

part 'maths_provider.g.dart';

/// Provider for MathsService
@riverpod
MathsService mathsService(MathsServiceRef ref) {
  final fileService = ref.watch(fileServiceProvider);
  return MathsService(fileService);
}

/// Async provider to load a specific maths object
@riverpod
Future<MathsObject?> mathsObject(
  MathsObjectRef ref, {
  required String workspaceId,
  required String mathsObjectId,
}) async {
  final service = ref.watch(mathsServiceProvider);
  return service.loadMathsObject(
    workspaceId: workspaceId,
    objectId: mathsObjectId,
  );
}

/// Async provider to list all maths objects in a workspace
@riverpod
Future<List<MathsObject>> mathsObjectsList(
  MathsObjectsListRef ref,
  String workspaceId,
) async {
  final service = ref.watch(mathsServiceProvider);
  return service.listMathsObjects(workspaceId);
}

/// State notifier for managing a maths object's operations
class MathsObjectNotifier extends AsyncNotifier<MathsObject> {
  late String _workspaceId;
  late String _mathsObjectId;

  @override
  Future<MathsObject> build({
    required String workspaceId,
    required String mathsObjectId,
  }) async {
    _workspaceId = workspaceId;
    _mathsObjectId = mathsObjectId;

    final service = ref.watch(mathsServiceProvider);
    final loaded = await service.loadMathsObject(
      workspaceId: workspaceId,
      objectId: mathsObjectId,
    );

    if (loaded == null) {
      throw Exception('Maths object not found');
    }

    return loaded;
  }

  /// Update the maths object
  Future<void> updateMathsObject(MathsObject updated) async {
    final service = ref.read(mathsServiceProvider);
    await service.saveMathsObject(updated);
    state = AsyncValue.data(updated);
  }

  /// Reload the maths object from disk
  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(mathsServiceProvider);
      final loaded = await service.loadMathsObject(
        workspaceId: _workspaceId,
        objectId: _mathsObjectId,
      );

      if (loaded == null) {
        throw Exception('Maths object not found');
      }

      return loaded;
    });
  }

  /// Add an operation to the maths object
  Future<void> addOperation(MathsOperation operation) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = current.map(
      matrix: (m) => m.copyWith(operations: [...m.operations, operation]),
      graph: (g) => g.copyWith(operations: [...g.operations, operation]),
    );

    await updateMathsObject(updated);
  }

  /// Update matrix data
  Future<void> updateMatrixData(MatrixData data) async {
    final current = state.valueOrNull;
    if (current is! MatrixObject) return;

    final updated = current.copyWith(data: data, updatedAt: DateTime.now());
    await updateMathsObject(updated);
  }

  /// Update graph data
  Future<void> updateGraphData(GraphData data) async {
    final current = state.valueOrNull;
    if (current is! GraphObject) return;

    final updated = current.copyWith(data: data, updatedAt: DateTime.now());
    await updateMathsObject(updated);
  }

  /// Clear all operations
  Future<void> clearOperations() async {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = current.map(
      matrix: (m) => m.copyWith(operations: [], updatedAt: DateTime.now()),
      graph: (g) => g.copyWith(operations: [], updatedAt: DateTime.now()),
    );

    await updateMathsObject(updated);
  }
}

/// Provider for managing a specific maths object with operations
@riverpod
class MathsObjectNotifierProvider
    extends _$MathsObjectNotifierProvider
    implements AsyncNotifier<MathsObject> {
  late String _workspaceId;
  late String _mathsObjectId;

  @override
  Future<MathsObject> build({
    required String workspaceId,
    required String mathsObjectId,
  }) async {
    _workspaceId = workspaceId;
    _mathsObjectId = mathsObjectId;

    final service = ref.watch(mathsServiceProvider);
    final loaded = await service.loadMathsObject(
      workspaceId: workspaceId,
      objectId: mathsObjectId,
    );

    if (loaded == null) {
      throw Exception('Maths object not found');
    }

    return loaded;
  }

  /// Update the maths object
  Future<void> updateMathsObject(MathsObject updated) async {
    final service = ref.read(mathsServiceProvider);
    await service.saveMathsObject(updated);
    state = AsyncValue.data(updated);
  }

  /// Reload the maths object from disk
  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(mathsServiceProvider);
      final loaded = await service.loadMathsObject(
        workspaceId: _workspaceId,
        objectId: _mathsObjectId,
      );

      if (loaded == null) {
        throw Exception('Maths object not found');
      }

      return loaded;
    });
  }

  /// Add an operation to the maths object
  Future<void> addOperation(MathsOperation operation) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = current.map(
      matrix: (m) => m.copyWith(operations: [...m.operations, operation]),
      graph: (g) => g.copyWith(operations: [...g.operations, operation]),
    );

    await updateMathsObject(updated);
  }

  /// Update matrix data
  Future<void> updateMatrixData(MatrixData data) async {
    final current = state.valueOrNull;
    if (current is! MatrixObject) return;

    final updated = current.copyWith(data: data, updatedAt: DateTime.now());
    await updateMathsObject(updated);
  }

  /// Update graph data
  Future<void> updateGraphData(GraphData data) async {
    final current = state.valueOrNull;
    if (current is! GraphObject) return;

    final updated = current.copyWith(data: data, updatedAt: DateTime.now());
    await updateMathsObject(updated);
  }

  /// Clear all operations
  Future<void> clearOperations() async {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = current.map(
      matrix: (m) => m.copyWith(operations: [], updatedAt: DateTime.now()),
      graph: (g) => g.copyWith(operations: [], updatedAt: DateTime.now()),
    );

    await updateMathsObject(updated);
  }
}

/// Provider for the active maths workspace
@riverpod
class ActiveMathsWorkspace extends _$ActiveMathsWorkspace {
  @override
  String build() => '';

  void setWorkspace(String workspaceId) {
    state = workspaceId;
  }
}
