import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import '../../theme/design_tokens.dart';

/// Editor for audio recordings (Stage 6).
/// Provides recording, playback, and duration display.
class AudioBlockEditor extends StatefulWidget {
  const AudioBlockEditor({
    super.key,
    required this.audioFile,
    required this.durationMs,
  });

  final String audioFile;
  final int durationMs;

  @override
  State<AudioBlockEditor> createState() => _AudioBlockEditorState();
}

class _AudioBlockEditorState extends State<AudioBlockEditor>
    with TickerProviderStateMixin {
  late final AudioPlayer _player;
  late final AnimationController _visualizerController;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  bool _loadFailed = false;
  String _statusText = 'Loading...';
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _visualizerController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _initialized = true;
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    try {
      if (widget.audioFile.isEmpty) {
        throw Exception('No audio file path provided');
      }
      await _player.setSourceDeviceFile(widget.audioFile);

      // Listen for player state changes.
      _player.onPlayerStateChanged.listen((state) {
        if (!mounted) return;
        setState(() {
          _isPlaying = state == PlayerState.playing;
          _statusText = _getStatusText(state);
        });
      });

      _player.onDurationChanged.listen((d) {
        if (!mounted) return;
        setState(() => _duration = d);
      });

      _player.onPositionChanged.listen((p) {
        if (!mounted) return;
        setState(() => _position = p);
        // Pulse the visualizer during playback
        if (_initialized && _isPlaying && !_visualizerController.isAnimating) {
          _visualizerController.forward(from: 0);
        }
      });
    } catch (e) {
      _loadFailed = true;
      if (mounted) {
        setState(() {});
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error loading audio: $e')));
        });
      }
    }
  }

  @override
  void dispose() {
    _visualizerController.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Everforest styled audio player
    final duration = _duration == Duration.zero
        ? Duration(milliseconds: widget.durationMs)
        : _duration;

    return Container(
      padding: EdgeInsets.all(AxiomSpacing.sm + 2),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(AxiomRadius.sm),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Playback controls - Everforest styled
          Row(
            children: [
              FilledButton.icon(
                onPressed: _loadFailed ? null : _togglePlayback,
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                label: Text(_isPlaying ? 'Pause' : 'Play'),
                style: FilledButton.styleFrom(
                  backgroundColor: _loadFailed
                      ? cs.outlineVariant
                      : cs.secondary,
                  foregroundColor: cs.surface,
                ),
              ),
              SizedBox(width: AxiomSpacing.sm + 2),
              // Duration display
              Text(
                _formatDuration(duration),
                style: AxiomTypography.labelMedium.copyWith(
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: AxiomSpacing.sm + 2),
          // Waveform visualizer
          if (_initialized)
            Center(
              child: SizedBox(
                width: 200,
                height: 50,
                child: AnimatedBuilder(
                  animation: _visualizerController,
                  builder: (context, child) {
                    // Use playback progress as base animation value
                    final progress = _duration.inMilliseconds > 0
                        ? _position.inMilliseconds / _duration.inMilliseconds
                        : 0.0;
                    final animValue = _isPlaying
                        ? (progress + _visualizerController.value)
                        : progress;
                    return _buildWaveform(animValue);
                  },
                ),
              ),
            ),
          SizedBox(height: AxiomSpacing.sm + 2),
          // Progress indicator - Everforest styled
          StreamBuilder<Duration>(
            stream: _player.onPositionChanged,
            builder: (context, snapshot) {
              final position = snapshot.data ?? _position;
              final clamped =
                  position.inMilliseconds > duration.inMilliseconds &&
                      duration.inMilliseconds > 0
                  ? duration
                  : position;
              final progress = duration.inMilliseconds > 0
                  ? clamped.inMilliseconds / duration.inMilliseconds
                  : 0.0;
              return Column(
                children: [
                  // Status text
                  Text(
                    _statusText,
                    style: AxiomTypography.labelSmall.copyWith(
                      color: _loadFailed ? cs.error : cs.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AxiomSpacing.sm),
                  // Animated progress bar - Everforest colors
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: cs.surfaceContainerHigh,
                    valueColor: AlwaysStoppedAnimation(
                      _loadFailed ? cs.error : cs.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(clamped),
                        style: AxiomTypography.labelSmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        _formatDuration(duration),
                        style: AxiomTypography.labelSmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _togglePlayback() async {
    try {
      if (_isPlaying) {
        await _player.pause();
      } else {
        await _player.resume();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Playback error: $e')));
      }
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _getStatusText(PlayerState state) {
    switch (state) {
      case PlayerState.playing:
        return 'Playing...';
      case PlayerState.paused:
        return 'Paused';
      case PlayerState.stopped:
        return 'Stopped';
      case PlayerState.disposed:
        return 'Disposed';
      case PlayerState.completed:
        return 'Done';
    }
  }

  Widget _buildWaveform(double animationValue) {
    // Create a waveform visualization with 8 bars
    const barCount = 8;
    final random = math.Random(42); // Deterministic randomness

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(barCount, (index) {
        // Each bar has a different height based on a sine wave + playback progress
        final baseHeight =
            0.3 +
            0.4 * math.sin((index + animationValue * 2) * math.pi / barCount);
        final finalHeight =
            baseHeight + random.nextDouble() * 0.3 * (animationValue % 1.0);
        final clampedHeight = (finalHeight * 35).clamp(4.0, 35.0);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Container(
            width: 4,
            height: clampedHeight,
            decoration: BoxDecoration(
              color: Color.lerp(
                Colors.green[300],
                Colors.green[700],
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
