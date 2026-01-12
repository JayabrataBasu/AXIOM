import 'package:freezed_annotation/freezed_annotation.dart';
import 'position.dart';

part 'canvas_state.freezed.dart';
part 'canvas_state.g.dart';

/// Persisted canvas state including viewport position and zoom.
@freezed
class CanvasState with _$CanvasState {
  const factory CanvasState({
    /// Schema version for migration support
    @Default(1) int version,

    /// Viewport center position
    @Default(Position()) Position viewportCenter,

    /// Zoom level (1.0 = 100%)
    @Default(1.0) double zoom,

    /// Last modified timestamp
    required DateTime updatedAt,
  }) = _CanvasState;

  factory CanvasState.fromJson(Map<String, dynamic> json) =>
      _$CanvasStateFromJson(json);
}
