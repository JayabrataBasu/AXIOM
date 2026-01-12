import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/canvas_sketch.dart';

/// Service for managing canvas-level sketch persistence.
class CanvasSketchService {
  static final CanvasSketchService _instance = CanvasSketchService._internal();

  factory CanvasSketchService() {
    return _instance;
  }

  CanvasSketchService._internal();

  static CanvasSketchService get instance => _instance;

  late Directory _sketchDir;
  CanvasSketch? _currentSketch;

  /// Initialize the service and load existing canvas sketches.
  Future<void> initialize() async {
    final appSupport = await getApplicationSupportDirectory();
    _sketchDir = Directory(path.join(appSupport.path, 'axiom_data', 'media', 'sketches'));
    if (!_sketchDir.existsSync()) {
      _sketchDir.createSync(recursive: true);
    }

    // Load the canvas sketch if it exists
    await _loadCanvasSketch();
  }

  /// Load the canvas doodles sketch from disk.
  Future<void> _loadCanvasSketch() async {
    try {
      final file = File(path.join(_sketchDir.path, 'canvas-doodles.json'));
      if (file.existsSync()) {
        final content = await file.readAsString();
        final json = jsonDecode(content) as Map<String, dynamic>;
        _currentSketch = CanvasSketch.fromJson(json);
      } else {
        _currentSketch = CanvasSketch(
          id: 'canvas-doodles',
          strokes: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      print('Error loading canvas sketch: $e');
      _currentSketch = CanvasSketch(
        id: 'canvas-doodles',
        strokes: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  /// Get the current canvas sketch (all doodles on canvas).
  Future<CanvasSketch> getCanvasSketch() async {
    if (_currentSketch == null) {
      await _loadCanvasSketch();
    }
    return _currentSketch!;
  }

  /// Add a stroke to the canvas sketch.
  Future<void> addStroke(CanvasSketchStroke stroke) async {
    if (_currentSketch == null) {
      await _loadCanvasSketch();
    }
    
    _currentSketch!.strokes.add(stroke);
    _currentSketch!.updatedAt = DateTime.now();
    await _saveCanvasSketch();
  }

  /// Remove the last stroke from canvas sketch.
  Future<void> undoStroke() async {
    if (_currentSketch == null) {
      await _loadCanvasSketch();
    }
    
    if (_currentSketch!.strokes.isNotEmpty) {
      _currentSketch!.strokes.removeLast();
      _currentSketch!.updatedAt = DateTime.now();
      await _saveCanvasSketch();
    }
  }

  /// Clear all canvas strokes.
  Future<void> clearCanvas() async {
    _currentSketch = CanvasSketch(
      id: 'canvas-doodles',
      strokes: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _saveCanvasSketch();
  }

  /// Replace the entire canvas sketch.
  Future<void> setCanvasSketch(CanvasSketch sketch) async {
    _currentSketch = sketch;
    await _saveCanvasSketch();
  }

  /// Save the current canvas sketch to disk.
  Future<void> _saveCanvasSketch() async {
    try {
      if (_currentSketch == null) return;
      
      final file = File(path.join(_sketchDir.path, 'canvas-doodles.json'));
      final json = jsonEncode(_currentSketch!.toJson());
      await file.writeAsString(json);
    } catch (e) {
      print('Error saving canvas sketch: $e');
    }
  }
}
