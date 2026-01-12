import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';
part 'position.g.dart';

/// Represents a 2D position on the canvas.
@freezed
class Position with _$Position {
  const factory Position({
    @Default(0.0) double x,
    @Default(0.0) double y,
  }) = _Position;

  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);
}
