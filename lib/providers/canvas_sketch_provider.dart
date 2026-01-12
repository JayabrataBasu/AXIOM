import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/canvas_sketch.dart';
import '../services/canvas_sketch_service.dart';

/// Provider for the CanvasSketchService singleton.
final canvasSketchServiceProvider = Provider<CanvasSketchService>((ref) {
  return CanvasSketchService.instance;
});

/// Async provider that loads the current canvas sketch.
final canvasSketchProvider = FutureProvider<CanvasSketch>((ref) async {
  final service = ref.watch(canvasSketchServiceProvider);
  return service.getCanvasSketch();
});

/// Notifier for managing canvas sketch operations.
class CanvasSketchNotifier extends StateNotifier<AsyncValue<CanvasSketch>> {
  late CanvasSketchService _service;

  CanvasSketchNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadSketch();
  }

  Future<void> _loadSketch() async {
    try {
      final sketch = await _service.getCanvasSketch();
      state = AsyncValue.data(sketch);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Add a stroke to the canvas sketch.
  Future<void> addStroke(CanvasSketchStroke stroke) async {
    try {
      await _service.addStroke(stroke);
      final sketch = await _service.getCanvasSketch();
      state = AsyncValue.data(sketch);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Undo the last stroke.
  Future<void> undoStroke() async {
    try {
      await _service.undoStroke();
      final sketch = await _service.getCanvasSketch();
      state = AsyncValue.data(sketch);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Clear all canvas strokes.
  Future<void> clearCanvas() async {
    try {
      await _service.clearCanvas();
      final sketch = await _service.getCanvasSketch();
      state = AsyncValue.data(sketch);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Reload the sketch from disk.
  Future<void> reload() async {
    _loadSketch();
  }
}

/// StateNotifier provider for canvas sketch operations.
final canvasSketchNotifierProvider =
    StateNotifierProvider<CanvasSketchNotifier, AsyncValue<CanvasSketch>>((ref) {
  final service = ref.watch(canvasSketchServiceProvider);
  return CanvasSketchNotifier(service);
});
