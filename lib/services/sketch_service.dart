import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import '../models/sketch_models.dart';
import 'file_service.dart';

/// Service for sketch stroke storage and retrieval.
class SketchService {
  SketchService._();
  static final instance = SketchService._();

  final FileService _fileService = FileService.instance;

  Future<Directory> get _sketchDir async {
    final media = await _fileService.mediaDirectory;
    final dir = Directory(p.join(media.path, 'sketches'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Returns the JSON stroke file path for a block id.
  Future<String> strokeFilePath(String blockId) async {
    final dir = await _sketchDir;
    return p.join(dir.path, '$blockId.json');
  }

  /// Returns the PNG thumbnail path for a block id.
  Future<String> thumbnailFilePath(String blockId) async {
    final dir = await _sketchDir;
    return p.join(dir.path, '$blockId.png');
  }

  /// Ensure an empty stroke file exists.
  Future<String> ensureStrokeFile(String blockId) async {
    final path = await strokeFilePath(blockId);
    final file = File(path);
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode(<dynamic>[]));
    }
    return path;
  }

  /// Save strokes to disk.
  Future<void> saveStrokes(String blockId, List<SketchStroke> strokes) async {
    final path = await strokeFilePath(blockId);
    final file = File(path);
    await file.writeAsString(jsonEncode(sketchStrokesToJson(strokes)));
  }

  /// Load strokes from disk; returns empty list if missing.
  Future<List<SketchStroke>> loadStrokes(String blockId) async {
    final path = await strokeFilePath(blockId);
    final file = File(path);
    if (!await file.exists()) return [];

    try {
      final content = await file.readAsString();
      final raw = jsonDecode(content) as List<dynamic>;
      return sketchStrokesFromJson(raw);
    } catch (_) {
      return [];
    }
  }

  /// Delete sketch assets for a block.
  Future<void> deleteSketchAssets({required String blockId, String? strokeFile, String? thumbnailFile}) async {
    final strokePath = strokeFile ?? await strokeFilePath(blockId);
    final thumbPath = thumbnailFile ?? await thumbnailFilePath(blockId);
    await _fileService.deleteFile(strokePath);
    await _fileService.deleteFile(thumbPath);
  }
}
