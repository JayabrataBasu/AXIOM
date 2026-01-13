import 'dart:io';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;
import '../services/file_service.dart';

/// Result of a completed audio recording.
class AudioRecordingResult {
  AudioRecordingResult({required this.filePath, required this.durationMs});

  final String filePath;
  final int durationMs;
}

/// Service that owns audio recording lifecycle (Stage 6).
/// Handles permissions, file paths, recording start/stop, and cleanup.
class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  final AudioRecorder _recorder = AudioRecorder();
  final FileService _fileService = FileService.instance;

  String? _currentFilePath;
  DateTime? _startTime;

  /// Begin recording into a uniquely named file in media/audio/.
  Future<void> startRecording() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      throw Exception('Microphone permission denied');
    }

    final audioDir = await _fileService.audioDirectory;
      // Use WAV for widest desktop compatibility (GStreamer on Linux).
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.wav';
    final path = p.join(audioDir.path, fileName);

    await _recorder.start(
      RecordConfig(
          encoder: AudioEncoder.wav,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: path,
    );

    _currentFilePath = path;
    _startTime = DateTime.now();
  }

  /// Stop recording and return the file path + duration.
  Future<AudioRecordingResult?> stopRecording() async {
    if (!await _recorder.isRecording()) {
      return null;
    }

    final stopPath = await _recorder.stop();
    final path = stopPath ?? _currentFilePath;
    if (path == null) return null;

    final duration = _startTime != null
        ? DateTime.now().difference(_startTime!)
        : await _readDurationFromFile(path);

    _startTime = null;
    _currentFilePath = null;

    return AudioRecordingResult(
      filePath: path,
      durationMs: duration.inMilliseconds,
    );
  }

  /// Cancel and delete any in-progress recording.
  Future<void> cancelRecording() async {
    if (await _recorder.isRecording()) {
      final stopPath = await _recorder.stop();
      final path = stopPath ?? _currentFilePath;
      if (path != null) {
        await _fileService.deleteFile(path);
      }
    } else if (_currentFilePath != null) {
      await _fileService.deleteFile(_currentFilePath!);
    }
    _currentFilePath = null;
    _startTime = null;
  }

  /// Delete a specific recording file.
  Future<void> deleteRecording(String path) async {
    await _fileService.deleteFile(path);
  }

  Future<Duration> _readDurationFromFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        final stat = await file.stat();
        if (stat.modified.isAfter(stat.changed)) {
          return stat.modified.difference(stat.changed);
        }
      }
    } catch (_) {
      // Ignore and fallback below.
    }
    return Duration.zero;
  }
}
