import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

/// An infinite, pannable, zoomable canvas surface.
class InfiniteCanvas extends StatefulWidget {
  const InfiniteCanvas({
    super.key,
    required this.child,
    this.initialScale = 1.0,
    this.minScale = 0.1,
    this.maxScale = 4.0,
    this.onScaleChanged,
    this.transformationController,
    this.panEnabled = true,
  });

  final Widget child;
  final double initialScale;
  final double minScale;
  final double maxScale;
  final ValueChanged<double>? onScaleChanged;
  final TransformationController? transformationController;
  final bool panEnabled;

  @override
  State<InfiniteCanvas> createState() => InfiniteCanvasState();
}

class InfiniteCanvasState extends State<InfiniteCanvas> {
  late TransformationController _controller;
  bool _ownController = false;

  @override
  void initState() {
    super.initState();
    if (widget.transformationController != null) {
      _controller = widget.transformationController!;
    } else {
      _controller = TransformationController();
      _ownController = true;
    }
  }

  @override
  void dispose() {
    if (_ownController) {
      _controller.dispose();
    }
    super.dispose();
  }

  /// Get current scale/zoom level.
  double get currentScale {
    return _controller.value.getMaxScaleOnAxis();
  }

  /// Get the current viewport center in scene coordinates.
  Offset get viewportCenter {
    final matrix = _controller.value;
    final scale = matrix.getMaxScaleOnAxis();
    final translation = matrix.getTranslation();

    // Get the viewport size
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return Offset.zero;

    final viewportSize = renderBox.size;
    final centerX = (viewportSize.width / 2 - translation.x) / scale;
    final centerY = (viewportSize.height / 2 - translation.y) / scale;

    return Offset(centerX, centerY);
  }

  /// Convert screen coordinates to canvas coordinates.
  Offset screenToCanvas(Offset screenPosition) {
    final matrix = _controller.value.clone()..invert();
    final result = MatrixUtils.transformPoint(matrix, screenPosition);
    return result;
  }

  /// Convert canvas coordinates to screen coordinates.
  Offset canvasToScreen(Offset canvasPosition) {
    return MatrixUtils.transformPoint(_controller.value, canvasPosition);
  }

  /// Center the viewport on a specific canvas position.
  void centerOn(Offset position, {bool animate = true}) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final viewportSize = renderBox.size;
    final scale = currentScale;

    final newX = viewportSize.width / 2 - position.dx * scale;
    final newY = viewportSize.height / 2 - position.dy * scale;

    final matrix = Matrix4.identity()
      ..translateByVector3(Vector3(newX, newY, 0))
      ..scaleByVector3(Vector3(scale, scale, 1));

    _controller.value = matrix;
  }

  /// Set zoom level.
  void setZoom(double scale) {
    final clampedScale = scale.clamp(widget.minScale, widget.maxScale);
    final center = viewportCenter;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final viewportSize = renderBox.size;
    final newX = viewportSize.width / 2 - center.dx * clampedScale;
    final newY = viewportSize.height / 2 - center.dy * clampedScale;

    final matrix = Matrix4.identity()
      ..translateByVector3(Vector3(newX, newY, 0))
      ..scaleByVector3(Vector3(clampedScale, clampedScale, 1));

    _controller.value = matrix;
    widget.onScaleChanged?.call(clampedScale);
  }

  /// Zoom to fit all content with given bounds and padding.
  void zoomToFit(Rect contentBounds, {double padding = 100.0}) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final viewportSize = renderBox.size;

    // Add padding to content bounds
    final paddedBounds = contentBounds.inflate(padding);

    // Calculate scale to fit content in viewport
    final scaleX = viewportSize.width / paddedBounds.width;
    final scaleY = viewportSize.height / paddedBounds.height;
    final scale = (scaleX < scaleY ? scaleX : scaleY).clamp(
      widget.minScale,
      widget.maxScale,
    );

    // Center on the middle of content bounds
    final centerX = paddedBounds.left + paddedBounds.width / 2;
    final centerY = paddedBounds.top + paddedBounds.height / 2;

    final newX = viewportSize.width / 2 - centerX * scale;
    final newY = viewportSize.height / 2 - centerY * scale;

    final matrix = Matrix4.identity()
      ..translateByVector3(Vector3(newX, newY, 0))
      ..scaleByVector3(Vector3(scale, scale, 1));

    _controller.value = matrix;
    widget.onScaleChanged?.call(scale);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      // Handle mouse wheel zoom
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          final delta = event.scrollDelta.dy;
          final scaleFactor = delta > 0 ? 0.9 : 1.1;
          final newScale = (currentScale * scaleFactor).clamp(
            widget.minScale,
            widget.maxScale,
          );

          // Zoom towards cursor position
          final focalPoint = event.localPosition;
          final focalPointScene = screenToCanvas(focalPoint);

          final matrix = Matrix4.identity()
            ..translateByVector3(Vector3(focalPoint.dx, focalPoint.dy, 0))
            ..scaleByVector3(Vector3(newScale, newScale, 1))
            ..translateByVector3(
              Vector3(-focalPointScene.dx, -focalPointScene.dy, 0),
            );

          _controller.value = matrix;
          widget.onScaleChanged?.call(newScale);
        }
      },
      child: InteractiveViewer(
        transformationController: _controller,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        constrained: false,
        panEnabled: widget.panEnabled,
        // Disable scale gestures to let canvas handle double-tap for node creation
        scaleEnabled: false,
        trackpadScrollCausesScale: false,
        onInteractionEnd: (details) {
          widget.onScaleChanged?.call(currentScale);
        },
        child: widget.child,
      ),
    );
  }
}
