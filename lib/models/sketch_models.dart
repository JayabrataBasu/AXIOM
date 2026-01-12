import 'dart:ui';

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

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'pressure': pressure,
      };
}

/// A stroke composed of multiple sampled points with color and width.
class SketchStroke {
  SketchStroke({
    required this.points,
    this.color = const Color(0xFF000000),
    this.width = 2.0,
  });

  final List<SketchPoint> points;
  final Color color;
  final double width;

  factory SketchStroke.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['points'] as List<dynamic>? ?? [];
    return SketchStroke(
      points: rawPoints.map((p) => SketchPoint.fromJson(p as Map<String, dynamic>)).toList(),
      // Support new format with color
      color: json['color'] != null 
        ? Color(json['color'] as int) 
        : const Color(0xFF000000),
      width: (json['width'] as num?)?.toDouble() ?? 2.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'points': points.map((p) => p.toJson()).toList(),
        'color': color.value,
        'width': width,
      };
}

/// Helper to serialize a list of strokes.
List<Map<String, dynamic>> sketchStrokesToJson(List<SketchStroke> strokes) {
  return strokes.map((s) => s.toJson()).toList();
}

List<SketchStroke> sketchStrokesFromJson(List<dynamic> raw) {
  return raw.map((e) => SketchStroke.fromJson(e as Map<String, dynamic>)).toList();
}

