import '../models/models.dart';
import '../services/file_service.dart';

/// Repository for canvas state persistence.
class CanvasRepository {
  CanvasRepository({FileService? fileService})
      : _fileService = fileService ?? FileService.instance;

  final FileService _fileService;

  /// Load canvas state from disk.
  Future<CanvasState> load() async {
    final filePath = await _fileService.canvasFilePath;
    final json = await _fileService.readJson(filePath);

    if (json != null) {
      try {
        return CanvasState.fromJson(json);
      } catch (e) {
        print('Error parsing canvas state: $e');
      }
    }

    // Return default state if file doesn't exist or is corrupted
    return CanvasState(updatedAt: DateTime.now());
  }

  /// Save canvas state to disk.
  Future<void> save(CanvasState state) async {
    final filePath = await _fileService.canvasFilePath;
    final updated = state.copyWith(updatedAt: DateTime.now());
    await _fileService.writeJson(filePath, updated.toJson());
  }
}
