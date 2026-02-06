import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../theme/design_tokens.dart';

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
    final cs = Theme.of(context).colorScheme;
    // Everforest styled math editor
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LaTeX input field - Everforest styled
        TextField(
          controller: _controller,
          maxLines: 3,
          minLines: 1,
          style: AxiomTypography.code.copyWith(color: cs.onSurface),
          onChanged: (value) {
            widget.onChanged(value);
            _validateLatex(value);
          },
          decoration: InputDecoration(
            hintText: r'Enter LaTeX (e.g., \int_0^1 x^2 dx)',
            hintStyle: AxiomTypography.code.copyWith(color: cs.onSurfaceVariant),
            filled: true,
            fillColor: cs.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AxiomRadius.sm),
              borderSide: BorderSide(color: cs.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AxiomRadius.sm),
              borderSide: BorderSide(color: cs.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AxiomRadius.sm),
              borderSide: BorderSide(color: cs.tertiary, width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _showPreview ? Icons.visibility : Icons.visibility_off,
                color: cs.onSurfaceVariant,
              ),
              onPressed: () {
                setState(() => _showPreview = !_showPreview);
              },
            ),
            errorText: _parseError,
            errorStyle: TextStyle(color: cs.error),
          ),
        ),
        SizedBox(height: AxiomSpacing.sm + 2),
        // Preview section - Everforest styled
        if (_showPreview && _controller.text.isNotEmpty)
          Container(
            padding: EdgeInsets.all(AxiomSpacing.sm + 2),
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: BorderRadius.circular(AxiomRadius.sm),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: _buildMathPreview(),
          ),
      ],
    );
  }

  Widget _buildMathPreview() {
    final cs = Theme.of(context).colorScheme;
    if (_controller.text.isEmpty) {
      return Text(
        'Preview',
        style: AxiomTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant),
      );
    }

    try {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Math.tex(
          _controller.text,
          mathStyle: MathStyle.display,
          textStyle: TextStyle(color: cs.onSurface, fontSize: 18),
          onErrorFallback: (error) {
            return Text(
              'Error: ${error.toString()}',
              style: AxiomTypography.bodySmall.copyWith(color: cs.error),
            );
          },
        ),
      );
    } catch (e) {
      return Text(
        'Render error: ${e.toString()}',
        style: AxiomTypography.bodySmall.copyWith(color: cs.error),
      );
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
