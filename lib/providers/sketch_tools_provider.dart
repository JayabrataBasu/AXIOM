import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/settings_service.dart';

/// Enum defining available sketch tools.
enum SketchTool {
  pen, // Standard pen (size 1-10, thinning 0.5)
  marker, // Wide marker (size 8-20, thinning 0.2, semi-transparent)
  pencil, // Thin pencil (size 1-3, thinning 0.8, precise)
  brush, // Artistic brush (size 10-30, thinning 0.5, smooth)
  eraser,
  selector, // For future selection/transformation
}

/// Immutable state for sketch tool settings.
class SketchToolState {
  final SketchTool tool;
  final Color color;
  final double brushSize; // 1.0 to 50.0
  final double opacity; // 0.0 to 1.0

  const SketchToolState({
    required this.tool,
    required this.color,
    required this.brushSize,
    required this.opacity,
  });

  /// Create a copy with optional overrides.
  SketchToolState copyWith({
    SketchTool? tool,
    Color? color,
    double? brushSize,
    double? opacity,
  }) {
    return SketchToolState(
      tool: tool ?? this.tool,
      color: color ?? this.color,
      brushSize: brushSize ?? this.brushSize,
      opacity: opacity ?? this.opacity,
    );
  }

  /// Convert to JSON for persistence.
  Map<String, dynamic> toJson() {
    return {
      'tool': tool.toString().split('.').last,
      'colorValue': color.toARGB32(),
      'brushSize': brushSize,
      'opacity': opacity,
    };
  }

  /// Construct from JSON with fallback defaults.
  factory SketchToolState.fromJson(Map<String, dynamic> json) {
    final toolName = json['tool'] as String? ?? 'pen';
    final tool = SketchTool.values.firstWhere(
      (t) => t.toString().split('.').last == toolName,
      orElse: () => SketchTool.pen,
    );

    return SketchToolState(
      tool: tool,
      color: Color(json['colorValue'] as int? ?? 0xFF000000),
      brushSize: (json['brushSize'] as num?)?.toDouble() ?? 2.0,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
    );
  }

  /// Default pen tool state.
  static const SketchToolState defaultPen = SketchToolState(
    tool: SketchTool.pen,
    color: Colors.black,
    brushSize: 2.0,
    opacity: 1.0,
  );
}

/// Notifier managing sketch tool state with persistence.
class SketchToolsNotifier extends StateNotifier<SketchToolState> {
  final SettingsService _settings = SettingsService.instance;
  final String? blockId; // null for global canvas tools

  SketchToolsNotifier({this.blockId}) : super(SketchToolState.defaultPen) {
    _loadToolState();
  }

  /// Get settings key for this instance (global or per-block)
  String get _settingsKey =>
      blockId != null ? 'sketchTools_$blockId' : 'sketchTools';

  /// Load saved tool state from settings.
  Future<void> _loadToolState() async {
    try {
      final json = await _settings.get(_settingsKey);
      if (json != null && json is Map<String, dynamic>) {
        state = SketchToolState.fromJson(json);
      }
    } catch (e) {
      debugPrint('Failed to load sketch tool state: $e');
    }
  }

  /// Save current state to settings.
  Future<void> _saveToolState() async {
    try {
      await _settings.set(_settingsKey, state.toJson());
    } catch (e) {
      debugPrint('Failed to save sketch tool state: $e');
    }
  }

  /// Update the current tool.
  void setTool(SketchTool tool) {
    state = state.copyWith(tool: tool);
    _saveToolState();
  }

  /// Update the brush color.
  void setColor(Color color) {
    state = state.copyWith(color: color);
    _saveToolState();
  }

  /// Update the brush size (clamped to 1.0-50.0).
  void setBrushSize(double size) {
    final clamped = size.clamp(1.0, 50.0);
    state = state.copyWith(brushSize: clamped);
    _saveToolState();
  }

  /// Update the opacity (clamped to 0.0-1.0).
  void setOpacity(double opacity) {
    final clamped = opacity.clamp(0.0, 1.0);
    state = state.copyWith(opacity: clamped);
    _saveToolState();
  }

  /// Quick switch to pen tool with default properties.
  void quickPen() {
    state = SketchToolState.defaultPen;
    _saveToolState();
  }

  /// Quick switch to eraser.
  void quickEraser() {
    state = state.copyWith(tool: SketchTool.eraser);
    _saveToolState();
  }

  /// Set all properties at once.
  void setState(SketchToolState newState) {
    state = newState;
    _saveToolState();
  }
}

/// Riverpod StateNotifier provider for sketch tools (global canvas-level).
/// For backward compatibility with existing canvas sketch functionality.
final sketchToolsProvider =
    StateNotifierProvider<SketchToolsNotifier, SketchToolState>((ref) {
      return SketchToolsNotifier();
    });

/// Per-block sketch tools provider using family pattern.
/// Each block gets its own independent tool state keyed by blockId.
/// Usage: ref.watch(sketchToolsBlockProvider(blockId))
final sketchToolsBlockProvider =
    StateNotifierProvider.family<SketchToolsNotifier, SketchToolState, String>((
      ref,
      blockId,
    ) {
      return SketchToolsNotifier(blockId: blockId);
    });
