import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Editor for LaTeX math expressions (Stage 4).
/// Shows both raw LaTeX input and rendered preview.
class MathBlockEditor extends StatefulWidget {
  const MathBlockEditor({
    super.key,
    required this.latex,
    required this.onChanged,
  });

  final String latex;
  final ValueChanged<String> onChanged;

  @override
  State<MathBlockEditor> createState() => _MathBlockEditorState();
}

class _MathBlockEditorState extends State<MathBlockEditor> {
  late TextEditingController _controller;
  bool _showPreview = true;
  String? _parseError;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.latex);
  }

  @override
  void didUpdateWidget(MathBlockEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.latex != widget.latex) {
      _controller.text = widget.latex;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LaTeX input field
        TextField(
          controller: _controller,
          maxLines: 3,
          minLines: 1,
          onChanged: (value) {
            widget.onChanged(value);
            _validateLatex(value);
          },
          decoration: InputDecoration(
            hintText: r'Enter LaTeX (e.g., \int_0^1 x^2 dx)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: IconButton(
              icon: Icon(_showPreview ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() => _showPreview = !_showPreview);
              },
            ),
            errorText: _parseError,
          ),
        ),
        const SizedBox(height: 12),
        // Preview section
        if (_showPreview && _controller.text.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: _buildMathPreview(),
          ),
      ],
    );
  }

  Widget _buildMathPreview() {
    if (_controller.text.isEmpty) {
      return const Text('Preview');
    }

    try {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Math.tex(
          _controller.text,
          mathStyle: MathStyle.display,
          onErrorFallback: (error) {
            return Text('Error: ${error.toString()}',
                style: const TextStyle(color: Colors.red));
          },
        ),
      );
    } catch (e) {
      return Text('Render error: ${e.toString()}',
          style: const TextStyle(color: Colors.red));
    }
  }

  void _validateLatex(String latex) {
    if (latex.isEmpty) {
      setState(() => _parseError = null);
      return;
    }

    try {
      // Try to parse the LaTeX
      Math.tex(latex);
      setState(() => _parseError = null);
    } catch (e) {
      setState(() => _parseError = 'Invalid LaTeX');
    }
  }
}
