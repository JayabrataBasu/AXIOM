import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:axiom/widgets/blocks/rich_text_editor.dart';
import 'package:axiom/widgets/blocks/rich_text_commands.dart';

void main() {
  group('RichTextController', () {
    late RichTextController controller;

    setUp(() {
      controller = RichTextController(text: 'Hello World');
    });

    test('should initialize with correct text', () {
      expect(controller.text, 'Hello World');
      expect(controller.formats, isEmpty);
    });

    test('should apply format to selection', () {
      controller.selection = TextSelection(baseOffset: 0, extentOffset: 5);
      
      final boldFormat = TextFormat(
        start: 0,
        end: 5,
        bold: true,
      );
      
      controller.applyFormat(boldFormat);
      
      expect(controller.formats, isNotEmpty);
      expect(controller.formats[0].bold, true);
      expect(controller.formats[0].start, 0);
      expect(controller.formats[0].end, 5);
    });

    test('should clear format from selection', () {
      controller.selection = TextSelection(baseOffset: 0, extentOffset: 5);
      
      final boldFormat = TextFormat(
        start: 0,
        end: 5,
        bold: true,
      );
      
      controller.applyFormat(boldFormat);
      expect(controller.formats, isNotEmpty);
      
      controller.clearFormat();
      expect(controller.formats, isEmpty);
    });

    test('should get format at cursor position', () {
      // Apply format to a range
      controller.selection = TextSelection(baseOffset: 0, extentOffset: 5);
      
      final boldFormat = TextFormat(
        start: 0,
        end: 5,
        bold: true,
      );
      
      controller.applyFormat(boldFormat);
      
      // Now check format at cursor within that range
      controller.selection = TextSelection.collapsed(offset: 2);
      
      final formatAtCursor = controller.getFormatAtCursor();
      expect(formatAtCursor, isNotNull);
      expect(formatAtCursor!.bold, true);
    });
  });

  group('CommandHistory', () {
    late RichTextController controller;
    late CommandHistory history;

    setUp(() {
      controller = RichTextController(text: 'Hello World');
      history = CommandHistory();
    });

    test('should execute command and add to undo stack', () {
      controller.selection = TextSelection(baseOffset: 0, extentOffset: 5);
      
      final command = FormatCommand(
        controller: controller,
        format: TextFormat(start: 0, end: 5, bold: true),
        isApplying: true,
      );
      
      history.execute(command);
      
      expect(controller.formats, isNotEmpty);
      expect(history.canUndo, true);
      expect(history.canRedo, false);
    });

    test('should undo command', () {
      controller.selection = TextSelection(baseOffset: 0, extentOffset: 5);
      
      final command = FormatCommand(
        controller: controller,
        format: TextFormat(start: 0, end: 5, bold: true),
        isApplying: true,
      );
      
      history.execute(command);
      expect(controller.formats, isNotEmpty);
      
      history.undo();
      expect(controller.formats, isEmpty);
      expect(history.canUndo, false);
      expect(history.canRedo, true);
    });

    test('should redo command', () {
      controller.selection = TextSelection(baseOffset: 0, extentOffset: 5);
      
      final command = FormatCommand(
        controller: controller,
        format: TextFormat(start: 0, end: 5, bold: true),
        isApplying: true,
      );
      
      history.execute(command);
      history.undo();
      
      expect(controller.formats, isEmpty);
      
      history.redo();
      expect(controller.formats, isNotEmpty);
      expect(history.canRedo, false);
    });

    test('should clear redo stack on new command after undo', () {
      controller.selection = TextSelection(baseOffset: 0, extentOffset: 5);
      
      final command1 = FormatCommand(
        controller: controller,
        format: TextFormat(start: 0, end: 5, bold: true),
        isApplying: true,
      );
      
      history.execute(command1);
      history.undo();
      expect(history.canRedo, true);
      
      controller.selection = TextSelection(baseOffset: 5, extentOffset: 11);
      final command2 = FormatCommand(
        controller: controller,
        format: TextFormat(start: 5, end: 11, italic: true),
        isApplying: true,
      );
      
      history.execute(command2);
      expect(history.canRedo, false);
    });
  });

  group('TextFormat', () {
    test('should serialize and deserialize correctly', () {
      final format = TextFormat(
        start: 0,
        end: 5,
        bold: true,
        italic: false,
        fontSize: 18.0,
      );
      
      final json = format.toJson();
      final deserialized = TextFormat.fromJson(json);
      
      expect(deserialized.start, format.start);
      expect(deserialized.end, format.end);
      expect(deserialized.bold, format.bold);
      expect(deserialized.italic, format.italic);
      expect(deserialized.fontSize, format.fontSize);
    });

    test('should copy with modifications', () {
      final format = TextFormat(
        start: 0,
        end: 5,
        bold: true,
      );
      
      final modified = format.copyWith(end: 10, italic: true);
      
      expect(modified.start, 0);
      expect(modified.end, 10);
      expect(modified.bold, true);
      expect(modified.italic, true);
    });
  });
}
