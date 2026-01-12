import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

/// Provider for the CanvasRepository singleton.
final canvasRepositoryProvider = Provider<CanvasRepository>((ref) {
  return CanvasRepository();
});

/// Notifier for managing canvas state.
class CanvasStateNotifier extends AsyncNotifier<CanvasState> {
  late CanvasRepository _repository;

  @override
  Future<CanvasState> build() async {
    _repository = ref.watch(canvasRepositoryProvider);
    return _repository.load();
  }

  /// Update viewport position.
  Future<void> updateViewport(Position center) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = current.copyWith(viewportCenter: center);
    await _repository.save(updated);
    state = AsyncData(updated);
  }

  /// Update zoom level.
  Future<void> updateZoom(double zoom) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final clamped = zoom.clamp(0.1, 4.0);
    final updated = current.copyWith(zoom: clamped);
    await _repository.save(updated);
    state = AsyncData(updated);
  }

  /// Update both viewport and zoom.
  Future<void> updateViewportAndZoom(Position center, double zoom) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final clamped = zoom.clamp(0.1, 4.0);
    final updated = current.copyWith(
      viewportCenter: center,
      zoom: clamped,
    );
    await _repository.save(updated);
    state = AsyncData(updated);
  }
}

/// Provider for the CanvasStateNotifier.
final canvasStateProvider =
    AsyncNotifierProvider<CanvasStateNotifier, CanvasState>(() {
  return CanvasStateNotifier();
});
