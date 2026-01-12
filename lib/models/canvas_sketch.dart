/// Canvas-level sketches - doodles drawn directly on the infinite canvas.
/// These are separate from node-contained sketches.
class CanvasSketch {
  CanvasSketch({
    required this.id,
    required this.strokes,
    required this.createdAt,
    required DateTime updatedAt,
  }) : updatedAt = updatedAt;

  final String id;
  final List<CanvasSketchStroke> strokes;
  final DateTime createdAt;
  DateTime updatedAt;

  factory CanvasSketch.fromJson(Map<String, dynamic> json) {
    final rawStrokes = json['strokes'] as List<dynamic>? ?? [];
    return CanvasSketch(
      id: json['id'] as String? ?? '',
      strokes: rawStrokes
          .map((s) => CanvasSketchStroke.fromJson(s as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'strokes': strokes.map((s) => s.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// A stroke on the canvas with absolute coordinates (not relative to a node).
class CanvasSketchStroke {
  CanvasSketchStroke({
    required this.points,
    required this.color,
    required this.width,
  });

  final List<CanvasSketchPoint> points;
  final int color; // Stored as int (Color.value)
  final double width;

  factory CanvasSketchStroke.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['points'] as List<dynamic>? ?? [];
    return CanvasSketchStroke(
      points: rawPoints
          .map((p) => CanvasSketchPoint.fromJson(p as Map<String, dynamic>))
          .toList(),
      color: json['color'] as int? ?? 0xFF000000,
      width: (json['width'] as num?)?.toDouble() ?? 2.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'points': points.map((p) => p.toJson()).toList(),
      'color': color,
      'width': width,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CanvasSketchStroke) return false;
    return other.points == points &&
        other.color == color &&
        other.width == width;
  }

  @override
  int get hashCode => points.hashCode ^ color.hashCode ^ width.hashCode;
}

/// A point in canvas-relative coordinates.
class CanvasSketchPoint {
  CanvasSketchPoint({
    required this.x,
    required this.y,
    this.pressure = 1.0,
  });

  final double x;
  final double y;
  final double pressure;

  factory CanvasSketchPoint.fromJson(Map<String, dynamic> json) {
    return CanvasSketchPoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      pressure: (json['pressure'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'pressure': pressure,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CanvasSketchPoint &&
        other.x == x &&
        other.y == y &&
        other.pressure == pressure;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ pressure.hashCode;
}
