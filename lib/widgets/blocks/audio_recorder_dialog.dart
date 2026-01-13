import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/audio_service.dart';

/// Dialog that records audio using [AudioService] and returns an [AudioRecordingResult].
class AudioRecorderDialog extends StatefulWidget {
  const AudioRecorderDialog({super.key});

  @override
  State<AudioRecorderDialog> createState() => _AudioRecorderDialogState();
}

class _AudioRecorderDialogState extends State<AudioRecorderDialog> {
  final AudioService _audioService = AudioService.instance;

  bool _isRecording = false;
  Duration _elapsed = Duration.zero;
  Timer? _ticker;
  AudioRecordingResult? _result;
  String? _error;
  bool _saved = false;

  @override
  void dispose() {
    _ticker?.cancel();
    // If user closes dialog without saving, clean up.
    if (!_saved) {
      if (_isRecording) {
        _audioService.cancelRecording();
      } else if (_result != null) {
        _audioService.deleteRecording(_result!.filePath);
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Record Audio'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isRecording ? 'Recording…' : (_result != null ? 'Recorded clip ready' : 'Ready to record'),
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            _formatDuration(_isRecording ? _elapsed : Duration(milliseconds: _result?.durationMs ?? 0)),
            style: theme.textTheme.displaySmall?.copyWith(fontSize: 28),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _handleCancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: !_isRecording && _result == null ? _startRecording : null,
          child: const Text('Start'),
        ),
        TextButton(
          onPressed: _isRecording ? _stopRecording : null,
          child: const Text('Stop'),
        ),
        FilledButton(
          onPressed: _result != null
              ? () {
                  _saved = true;
                  Navigator.of(context).pop(_result);
                }
              : null,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _startRecording() async {
    setState(() {
      _error = null;
    });
    try {
      await _audioService.startRecording();
      _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) {
        setState(() {
          _elapsed += const Duration(milliseconds: 200);
        });
      });
      setState(() {
        _isRecording = true;
        _elapsed = Duration.zero;
        _result = null;
      });
    } on PlatformException catch (e) {
      setState(() {
        _error = 'Recording failed: ${e.message ?? e.code}';
      });
    } catch (e) {
      setState(() {
        _error = 'Recording failed: $e';
      });
    }
  }

  Future<void> _stopRecording() async {
    try {
      final result = await _audioService.stopRecording();
      _ticker?.cancel();
      setState(() {
        _isRecording = false;
        _result = result;
        _elapsed = Duration(milliseconds: result?.durationMs ?? 0);
      });
    } catch (e) {
      setState(() {
        _error = 'Stop failed: $e';
      });
    }
  }

  Future<void> _handleCancel() async {
    _ticker?.cancel();
    if (_isRecording) {
      await _audioService.cancelRecording();
    } else if (_result != null) {
      await _audioService.deleteRecording(_result!.filePath);
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
