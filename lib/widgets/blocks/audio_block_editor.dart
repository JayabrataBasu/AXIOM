import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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

class _AudioBlockEditorState extends State<AudioBlockEditor> {
  late final AudioPlayer _player;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  bool _loadFailed = false;
  String _statusText = 'Loading...';

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
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
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duration = _duration == Duration.zero
        ? Duration(milliseconds: widget.durationMs)
        : _duration;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Playback controls
          Row(
            children: [
              FilledButton.icon(
                onPressed: _loadFailed ? null : _togglePlayback,
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                label: Text(_isPlaying ? 'Pause' : 'Play'),
              ),
              const SizedBox(width: 12),
              // Duration display
              Text(
                _formatDuration(duration),
                style: theme.textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress indicator
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
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _loadFailed
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Animated progress bar
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(
                      _loadFailed
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(clamped),
                        style: theme.textTheme.labelSmall,
                      ),
                      Text(
                        _formatDuration(duration),
                        style: theme.textTheme.labelSmall,
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
}
