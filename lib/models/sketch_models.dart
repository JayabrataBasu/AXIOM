import 'dart:ui';
import '../providers/sketch_tools_provider.dart';

/// Point sample for a sketch stroke.
class SketchPoint {
  SketchPoint({required this.x, required this.y, this.pressure = 1.0});

  final double x;
  final double y;
  final double pressure;

  factory SketchPoint.fromOffset(Offset offset, {double pressure = 1.0}) {
    return SketchPoint(x: offset.dx, y: offset.dy, pressure: pressure);
  }

  factory SketchPoint.fromJson(Map<String, dynamic> json) {
    return SketchPoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      pressure: (json['pressure'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Offset toOffset() => Offset(x, y);

  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'pressure': pressure};

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SketchPoint &&
        other.x == x &&
        other.y == y &&
        other.pressure == pressure;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ pressure.hashCode;
}

/// A stroke composed of multiple sampled points with color and width.
class SketchStroke {
  SketchStroke({
    required this.points,
    this.color = const Color(0xFF000000),
    this.width = 2.0,
    this.tool = SketchTool.pen,
  });

  final List<SketchPoint> points;
  final Color color;
  final double width;
  final SketchTool tool;

  factory SketchStroke.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['points'] as List<dynamic>? ?? [];

    // Parse tool with backward compatibility
    SketchTool tool = SketchTool.pen; // Default for legacy strokes
    if (json['tool'] != null) {
      final toolName = json['tool'] as String;
      tool = SketchTool.values.firstWhere(
        (t) => t.toString().split('.').last == toolName,
        orElse: () => SketchTool.pen,
      );
    }

    return SketchStroke(
      points: rawPoints
          .map((p) => SketchPoint.fromJson(p as Map<String, dynamic>))
          .toList(),
      // Support new format with color
      color: json['color'] != null
          ? Color(json['color'] as int)
          : const Color(0xFF000000),
      width: (json['width'] as num?)?.toDouble() ?? 2.0,
      tool: tool,
    );
  }

  Map<String, dynamic> toJson() => {
    'points': points.map((p) => p.toJson()).toList(),
    'color': color.toARGB32(),
    'width': width,
    'tool': tool.toString().split('.').last,
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SketchStroke) return false;
    return other.points == points &&
        other.color == color &&
        other.width == width &&
        other.tool == tool;
  }

  @override
  int get hashCode =>
      points.hashCode ^ color.hashCode ^ width.hashCode ^ tool.hashCode;
}

/// Helper to serialize a list of strokes.
List<Map<String, dynamic>> sketchStrokesToJson(List<SketchStroke> strokes) {
  return strokes.map((s) => s.toJson()).toList();
}

List<SketchStroke> sketchStrokesFromJson(List<dynamic> raw) {
  return raw
      .map((e) => SketchStroke.fromJson(e as Map<String, dynamic>))
      .toList();
}
