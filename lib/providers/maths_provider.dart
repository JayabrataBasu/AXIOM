import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/maths.dart';
import '../services/maths_service.dart';

/// Provider for a specific maths object
final mathsObjectProvider = FutureProvider.family<MathsObject?, String>((
  ref,
  mathsObjectId,
) async {
  final workspaceId = ref.watch(activeMathsWorkspaceProvider);
  if (workspaceId == null) return null;

  return await MathsService.instance.loadMathsObject(
    workspaceId: workspaceId,
    objectId: mathsObjectId,
  );
});

/// Provider for listing all maths objects in a workspace
final mathsObjectsListProvider =
    FutureProvider.family<List<MathsObject>, String>((ref, workspaceId) async {
      return await MathsService.instance.listMathsObjects(workspaceId);
    });

/// Provider for the active workspace ID for maths objects
final activeMathsWorkspaceProvider = StateProvider<String?>((ref) => null);

/// State notifier for managing maths object operations
class MathsObjectNotifier extends StateNotifier<AsyncValue<MathsObject>> {
  MathsObjectNotifier(this.workspaceId, this.mathsObjectId)
    : super(const AsyncValue.loading()) {
    _loadObject();
  }

  final String workspaceId;
  final String mathsObjectId;
  final MathsService _service = MathsService.instance;

  Future<void> _loadObject() async {
    try {
      final obj = await _service.loadMathsObject(
        workspaceId: workspaceId,
        objectId: mathsObjectId,
      );
      if (obj != null) {
        state = AsyncValue.data(obj);
      } else {
        state = AsyncValue.error('Maths object not found', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> _saveObject(MathsObject obj) async {
    await _service.saveMathsObject(obj);
  }

  /// Save the current maths object state
  Future<void> updateMathsObject(MathsObject updated) async {
    try {
      state = const AsyncValue.loading();
      await _saveObject(updated);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Reload the object from disk
  Future<void> reload() async {
    try {
      state = const AsyncValue.loading();
      final obj = await _service.loadMathsObject(
        workspaceId: workspaceId,
        objectId: mathsObjectId,
      );
      if (obj != null) {
        state = AsyncValue.data(obj);
      } else {
        state = AsyncValue.error('Maths object not found', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Add an operation to the maths object
  Future<void> addOperation(MathsOperation operation) async {
    try {
      final current = state.valueOrNull;
      if (current == null) return;

      late final MathsObject updated;
      if (current is MatrixObject) {
        final newOps = [...current.operations, operation];
        updated = current.copyWith(
          operations: newOps,
          updatedAt: DateTime.now(),
        );
      } else if (current is GraphObject) {
        final newOps = [...current.operations, operation];
        updated = current.copyWith(
          operations: newOps,
          updatedAt: DateTime.now(),
        );
      } else {
        return;
      }

      await updateMathsObject(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update matrix data directly
  Future<void> updateMatrixData(MatrixData data) async {
    try {
      final current = state.valueOrNull;
      if (current is! MatrixObject) return;

      final updated = current.copyWith(data: data, updatedAt: DateTime.now());

      await updateMathsObject(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update graph data directly
  Future<void> updateGraphData(GraphData data) async {
    try {
      final current = state.valueOrNull;
      if (current is! GraphObject) return;

      final updated = current.copyWith(data: data, updatedAt: DateTime.now());

      await updateMathsObject(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Clear all operations
  Future<void> clearOperations() async {
    try {
      final current = state.valueOrNull;
      if (current == null) return;

      late final MathsObject updated;
      if (current is MatrixObject) {
        updated = current.copyWith(operations: [], updatedAt: DateTime.now());
      } else if (current is GraphObject) {
        updated = current.copyWith(operations: [], updatedAt: DateTime.now());
      } else {
        return;
      }

      await updateMathsObject(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// StateNotifierProvider for managing maths objects with full operations support
final mathsObjectNotifierProvider =
    StateNotifierProvider.family<
      MathsObjectNotifier,
      AsyncValue<MathsObject>,
      (String workspaceId, String mathsObjectId)
    >((ref, params) {
      return MathsObjectNotifier(params.$1, params.$2);
    });
