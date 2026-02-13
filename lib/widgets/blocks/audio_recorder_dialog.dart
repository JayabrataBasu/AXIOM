import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/audio_service.dart';

/// Dialog that records audio using [AudioService] and returns an [AudioRecordingResult].
class AudioRecorderDialog extends StatefulWidget {
  const AudioRecorderDialog({super.key});

  @override
  State<AudioRecorderDialog> createState() => _AudioRecorderDialogState();
}

class _AudioRecorderDialogState extends State<AudioRecorderDialog>
    with TickerProviderStateMixin {
  final AudioService _audioService = AudioService.instance;

  bool _isRecording = false;
  Duration _elapsed = Duration.zero;
  Timer? _ticker;
  AudioRecordingResult? _result;
  String? _error;
  bool _saved = false;
  late final AnimationController _visualizerController;

  @override
  void initState() {
    super.initState();
    _visualizerController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _visualizerController.dispose();
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
            _isRecording
                ? 'Recording…'
                : (_result != null ? 'Recorded clip ready' : 'Ready to record'),
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            _formatDuration(
              _isRecording
                  ? _elapsed
                  : Duration(milliseconds: _result?.durationMs ?? 0),
            ),
            style: theme.textTheme.displaySmall?.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 16),
          // Waveform visualizer
          Center(
            child: SizedBox(
              width: 200,
              height: 60,
              child: _isRecording
                  ? AnimatedBuilder(
                      animation: _visualizerController,
                      builder: (context, child) {
                        return _buildWaveform(_visualizerController.value);
                      },
                    )
                  : _buildWaveform(0),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: _handleCancel, child: const Text('Cancel')),
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
        // Pulse the visualizer
        _visualizerController.forward(from: 0);
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

  // Pre-computed random offsets for smooth, efficient animation
  static final List<double> _randomOffsets = List.generate(12, (i) {
    final random = math.Random(42 + i);
    return random.nextDouble();
  });

  Widget _buildWaveform(double animationValue) {
    // Create a waveform visualization with 12 bars
    const barCount = 12;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(barCount, (index) {
        // Each bar has a different height based on a sine wave
        final baseHeight =
            0.3 +
            0.4 * math.sin((index + animationValue * 2) * math.pi / barCount);
        final finalHeight =
            baseHeight + _randomOffsets[index] * 0.3 * animationValue;
        final clampedHeight = (finalHeight * 40).clamp(4.0, 40.0);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Container(
            width: 4,
            height: clampedHeight,
            decoration: BoxDecoration(
              color: Color.lerp(
                Colors.blue[300],
                Colors.blue[700],
                finalHeight,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
