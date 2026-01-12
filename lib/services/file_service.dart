import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Low-level file I/O operations for Axiom's data persistence.
/// All data lives under a single root directory (axiom_data).
///
/// Directory structure:
/// ```
/// axiom_data/
/// ├── canvas.json          # Canvas viewport state
/// ├── settings.json        # App settings (Stage 10)
/// ├── nodes/               # IdeaNode files
/// │   └── {uuid}.json
/// ├── sessions/            # Workspace sessions (Stage 7)
/// │   └── {uuid}.json
/// ├── pdfs/                # Immutable PDFs (Stage 8)
/// │   └── {sha256}.pdf
/// └── media/               # Media files
///     ├── sketches/        # Sketch data (Stage 5)
///     └── audio/           # Audio recordings (Stage 6)
/// ```
class FileService {
  FileService._();
  static final instance = FileService._();

  Directory? _rootDir;

  /// Get the root data directory, creating it if necessary.
  Future<Directory> get rootDirectory async {
    if (_rootDir != null) return _rootDir!;

    final appDir = await getApplicationDocumentsDirectory();
    _rootDir = Directory(p.join(appDir.path, 'axiom_data'));

    if (!await _rootDir!.exists()) {
      await _rootDir!.create(recursive: true);
    }

    return _rootDir!;
  }

  /// Get a subdirectory, creating it if necessary.
  Future<Directory> getSubdirectory(String name) async {
    final root = await rootDirectory;
    final subDir = Directory(p.join(root.path, name));

    if (!await subDir.exists()) {
      await subDir.create(recursive: true);
    }

    return subDir;
  }

  /// Get the nodes directory.
  Future<Directory> get nodesDirectory => getSubdirectory('nodes');

  /// Get the sessions directory.
  Future<Directory> get sessionsDirectory => getSubdirectory('sessions');

  /// Get the PDFs directory.
  Future<Directory> get pdfsDirectory => getSubdirectory('pdfs');

  /// Get the media directory.
  Future<Directory> get mediaDirectory => getSubdirectory('media');

  /// Read a JSON file and return parsed content.
  /// Returns null if file doesn't exist or is invalid.
  Future<Map<String, dynamic>?> readJson(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return null;

    try {
      final content = await file.readAsString();
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      // Log error but don't crash - corruption isolation
      print('Error reading JSON from $filePath: $e');
      return null;
    }
  }

  /// Write JSON to a file atomically (write to .tmp, then rename).
  /// This prevents partial writes on crash.
  Future<void> writeJson(String filePath, Map<String, dynamic> data) async {
    final file = File(filePath);
    final tempFile = File('$filePath.tmp');

    // Ensure parent directory exists
    final parent = file.parent;
    if (!await parent.exists()) {
      await parent.create(recursive: true);
    }

    // Write to temp file first
    final content = const JsonEncoder.withIndent('  ').convert(data);
    await tempFile.writeAsString(content);

    // Atomic rename
    await tempFile.rename(filePath);
  }

  /// Delete a file if it exists.
  Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// List all JSON files in a directory.
  Future<List<File>> listJsonFiles(Directory directory) async {
    if (!await directory.exists()) return [];

    final files = <File>[];
    await for (final entity in directory.list()) {
      if (entity is File && entity.path.endsWith('.json')) {
        files.add(entity);
      }
    }
    return files;
  }

  /// Get the canvas state file path.
  Future<String> get canvasFilePath async {
    final root = await rootDirectory;
    return p.join(root.path, 'canvas.json');
  }

  /// Get the settings file path.
  Future<String> get settingsFilePath async {
    final root = await rootDirectory;
    return p.join(root.path, 'settings.json');
  }

  /// Get the file path for a node by ID.
  Future<String> nodeFilePath(String nodeId) async {
    final nodesDir = await nodesDirectory;
    return p.join(nodesDir.path, '$nodeId.json');
  }

  /// Get the file path for a session by ID.
  Future<String> sessionFilePath(String sessionId) async {
    final sessionsDir = await sessionsDirectory;
    return p.join(sessionsDir.path, '$sessionId.json');
  }
}
