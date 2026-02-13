import 'rich_text_editor.dart';

/// Base class for all editable commands that support undo/redo
abstract class EditCommand {
  /// Execute the command (apply the change)
  void execute();

  /// Undo the command (revert the change)
  void undo();

  /// Get a description of what this command does (for UI/logging)
  String get description;
}

/// Command to apply or remove formatting
class FormatCommand extends EditCommand {
  final RichTextController controller;
  final TextFormat format;
  final bool isApplying; // true = apply, false = remove
  
  late List<TextFormat> _previousFormats;

  FormatCommand({
    required this.controller,
    required this.format,
    required this.isApplying,
  });

  @override
  void execute() {
    _previousFormats = List<TextFormat>.from(controller.formats);
    
    if (isApplying) {
      controller.applyFormat(format);
    } else {
      controller.clearFormat();
    }
  }

  @override
  void undo() {
    controller.formats = _previousFormats;
    controller.refreshUI();
  }

  @override
  String get description => isApplying ? 'Apply formatting' : 'Remove formatting';
}

/// Command to change text content
class TextChangeCommand extends EditCommand {
  final RichTextController controller;
  final String newText;
  late String _previousText;
  late List<TextFormat> _previousFormats;

  TextChangeCommand({
    required this.controller,
    required this.newText,
  });

  @override
  void execute() {
    _previousText = controller.text;
    _previousFormats = List<TextFormat>.from(controller.formats);
    
    controller.text = newText;
  }

  @override
  void undo() {
    controller.text = _previousText;
    controller.formats = _previousFormats;
    controller.refreshUI();
  }

  @override
  String get description => 'Text edit';
}

/// Manages command history for undo/redo
class CommandHistory {
  final List<EditCommand> _undoStack = [];
  final List<EditCommand> _redoStack = [];
  
  static const int maxHistorySize = 100;

  /// Execute a command and add it to history
  void execute(EditCommand command) {
    command.execute();
    _undoStack.add(command);
    _redoStack.clear(); // Clear redo stack when new command executed
    
    // Limit history size to prevent memory bloat
    if (_undoStack.length > maxHistorySize) {
      _undoStack.removeAt(0);
    }
  }

  /// Undo the last command
  bool undo() {
    if (_undoStack.isEmpty) return false;
    
    final command = _undoStack.removeLast();
    command.undo();
    _redoStack.add(command);
    return true;
  }

  /// Redo the last undone command
  bool redo() {
    if (_redoStack.isEmpty) return false;
    
    final command = _redoStack.removeLast();
    command.execute();
    _undoStack.add(command);
    return true;
  }

  /// Check if undo is available
  bool get canUndo => _undoStack.isNotEmpty;

  /// Check if redo is available
  bool get canRedo => _redoStack.isNotEmpty;

  /// Clear all history
  void clear() {
    _undoStack.clear();
    _redoStack.clear();
  }

  /// Get description of what will be undone
  String? getUndoDescription() {
    if (_undoStack.isEmpty) return null;
    return _undoStack.last.description;
  }

  /// Get description of what will be redone
  String? getRedoDescription() {
    if (_redoStack.isEmpty) return null;
    return _redoStack.last.description;
  }
}
