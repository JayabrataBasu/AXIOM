import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../models/matrix_models.dart';
import '../../models/workspace_session.dart';

/// Matrix calculator workspace. Focuses on a minimal but functional
/// set of operations: create/edit matrices, transpose, invert, multiply.
class MatrixWorkspace extends ConsumerStatefulWidget {
  const MatrixWorkspace({
    super.key,
    required this.session,
    required this.onSessionChanged,
  });

  final WorkspaceSession session;
  final Future<void> Function(WorkspaceSession updated) onSessionChanged;

  @override
  ConsumerState<MatrixWorkspace> createState() => _MatrixWorkspaceState();
}

class _MatrixWorkspaceState extends ConsumerState<MatrixWorkspace> {
  late MatrixCalculatorData _data;
  final _uuid = const Uuid();
  String? _selectedA;
  String? _selectedB;

  @override
  void initState() {
    super.initState();
    _data = MatrixCalculatorData.fromJson(widget.session.data);
    if (_data.matrices.isNotEmpty) {
      _selectedA = _data.matrices.first.id;
      if (_data.matrices.length > 1) _selectedB = _data.matrices[1].id;
    }
  }

  Future<void> _persist() async {
    final updatedSession = widget.session.copyWith(
      data: _data.toJson(),
      updatedAt: DateTime.now(),
    );
    await widget.onSessionChanged(updatedSession);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.session.label.isNotEmpty
              ? widget.session.label
              : 'Matrix Workspace',
        ),
        actions: [
          IconButton(
            tooltip: 'Save',
            icon: const Icon(Icons.save_outlined),
            onPressed: _persist,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMatricesCard(theme),
            const SizedBox(height: 12),
            _buildOperationsCard(theme),
            const SizedBox(height: 12),
            _buildHistoryCard(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildMatricesCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Matrices', style: theme.textTheme.titleMedium),
                const Spacer(),
                TextButton.icon(
                  onPressed: _showAddMatrixDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_data.matrices.isEmpty)
              Text(
                'No matrices yet. Add one to begin.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              )
            else
              Column(
                children: _data.matrices.map((m) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.grid_on),
                    title: Text(
                      m.name.isNotEmpty
                          ? m.name
                          : 'Matrix ${m.id.substring(0, 6)}',
                    ),
                    subtitle: Text(
                      '${m.dimensions} • preview: ${_previewRow(m)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit matrix',
                          onPressed: () => _showAddMatrixDialog(editing: m),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Delete matrix',
                          onPressed: () => _deleteMatrix(m.id),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationsCard(ThemeData theme) {
    final matrices = _data.matrices;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Operations', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            if (matrices.isEmpty)
              Text(
                'Add at least one matrix to perform operations.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              )
            else ...[
              // Matrix selection
              Row(
                children: [
                  Expanded(
                    child: _matrixDropdown(
                      label: 'Matrix A',
                      value: _selectedA,
                      onChanged: (v) => setState(() => _selectedA = v),
                      matrices: matrices,
                    ),
                  ),
                  Expanded(
                    child: _matrixDropdown(
                      label: 'Matrix B',
                      value: _selectedB,
                      onChanged: (v) => setState(() => _selectedB = v),
                      matrices: matrices,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Unary operations
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _transpose,
                      icon: const Icon(Icons.flip),
                      label: const Text('Transpose'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _invert,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Invert'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Binary and point operations
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _multiply,
                      icon: const Icon(Icons.grid_on),
                      label: const Text('Multiply'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pointAdd,
                      icon: const Icon(Icons.add_location),
                      label: const Text('+ Point'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pointScale,
                      icon: const Icon(Icons.zoom_in),
                      label: const Text('× Point'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pointDot,
                      icon: const Icon(Icons.circle),
                      label: const Text('· Dot'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('History', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (_data.operations.isEmpty)
              Text(
                'No operations yet.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              )
            else
              Column(
                children: _data.operations.map((op) {
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.history),
                    title: Text(
                      op.description.isNotEmpty
                          ? op.description
                          : op.type.toUpperCase(),
                    ),
                    subtitle: Text('Created ${op.createdAt.toLocal()}'),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _matrixDropdown({
    required String label,
    required String? value,
    required ValueChanged<String?> onChanged,
    required List<Matrix> matrices,
  }) {
    return DropdownButton<String>(
      value: value ?? (matrices.isNotEmpty ? matrices.first.id : null),
      hint: Text(label),
      items: matrices
          .map(
            (m) => DropdownMenuItem(
              value: m.id,
              child: Text(
                m.name.isNotEmpty ? m.name : 'Matrix ${m.id.substring(0, 6)}',
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _showAddMatrixDialog({Matrix? editing}) async {
    final nameController = TextEditingController(text: editing?.name ?? '');
    final dataController = TextEditingController(
      text: editing != null ? _matrixToText(editing.data) : '1 0\n0 1',
    );

    final result = await showDialog<Matrix>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(editing == null ? 'Add Matrix' : 'Edit Matrix'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dataController,
                  decoration: const InputDecoration(
                    labelText: 'Rows (space/comma separated)',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    helperText: 'Example 2x2:\n1 0\n0 1',
                  ),
                  maxLines: 6,
                  minLines: 4,
                  keyboardType: TextInputType.multiline,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              try {
                final parsed = _parseMatrixText(dataController.text);
                final matrix = Matrix(
                  id: editing?.id ?? _uuid.v4(),
                  data: parsed,
                  name: nameController.text.trim(),
                );
                Navigator.pop(context, matrix);
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Invalid matrix: $e')));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        final existingIndex = _data.matrices.indexWhere(
          (m) => m.id == result.id,
        );
        if (existingIndex >= 0) {
          _data = _data.copyWith(
            matrices: List.of(_data.matrices)..[existingIndex] = result,
          );
        } else {
          _data = _data.copyWith(matrices: [..._data.matrices, result]);
        }
      });
      await _persist();
    }
  }

  void _deleteMatrix(String id) {
    setState(() {
      _data = _data.copyWith(
        matrices: _data.matrices.where((m) => m.id != id).toList(),
      );
      _selectedA = _data.matrices.isNotEmpty ? _data.matrices.first.id : null;
      _selectedB = _data.matrices.length > 1
          ? _data.matrices[1].id
          : _selectedA;
    });
    _persist();
  }

  void _transpose() {
    if (_selectedA == null) return;
    final matrix = _data.matrices.firstWhere((m) => m.id == _selectedA);
    final transposed = _transposeMatrix(matrix.data);
    _addResultMatrix(
      '${matrix.name}ᵀ',
      transposed,
      type: 'transpose',
      inputs: [matrix.id],
    );
  }

  void _invert() {
    if (_selectedA == null) return;
    final matrix = _data.matrices.firstWhere((m) => m.id == _selectedA);
    try {
      final inverted = _invertMatrix(matrix.data);
      _addResultMatrix(
        '${matrix.name.isNotEmpty ? matrix.name : 'A'}⁻¹',
        inverted,
        type: 'invert',
        inputs: [matrix.id],
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cannot invert matrix: $e')));
    }
  }

  void _multiply() {
    if (_selectedA == null || _selectedB == null) return;
    final a = _data.matrices.firstWhere((m) => m.id == _selectedA);
    final b = _data.matrices.firstWhere((m) => m.id == _selectedB);
    try {
      final product = _multiplyMatrices(a.data, b.data);
      _addResultMatrix(
        '(${a.name.isNotEmpty ? a.name : 'A'})×(${b.name.isNotEmpty ? b.name : 'B'})',
        product,
        type: 'multiply',
        inputs: [a.id, b.id],
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cannot multiply: $e')));
    }
  }

  Future<void> _pointAdd() async {
    if (_selectedA == null) return;
    final matrix = _data.matrices.firstWhere((m) => m.id == _selectedA);
    final result = await _showPointOperationDialog(
      'Add Point to ${matrix.name}',
      matrix,
    );
    if (result != null) {
      _addResultMatrix(
        '${matrix.name.isNotEmpty ? matrix.name : 'A'} + pt',
        result,
        type: 'point_add',
        inputs: [matrix.id],
      );
    }
  }

  Future<void> _pointScale() async {
    if (_selectedA == null) return;
    final matrix = _data.matrices.firstWhere((m) => m.id == _selectedA);
    final result = await _showPointOperationDialog(
      'Scale Points in ${matrix.name}',
      matrix,
      isScale: true,
    );
    if (result != null) {
      _addResultMatrix(
        '${matrix.name.isNotEmpty ? matrix.name : 'A'} × scale',
        result,
        type: 'point_scale',
        inputs: [matrix.id],
      );
    }
  }

  Future<void> _pointDot() async {
    if (_selectedA == null || _selectedB == null) return;
    final a = _data.matrices.firstWhere((m) => m.id == _selectedA);
    final b = _data.matrices.firstWhere((m) => m.id == _selectedB);
    try {
      final result = _dotProduct(a.data, b.data);
      _addResultMatrix(
        '${a.name.isNotEmpty ? a.name : 'A'} · ${b.name.isNotEmpty ? b.name : 'B'}',
        [
          [result],
        ],
        type: 'point_dot',
        inputs: [a.id, b.id],
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cannot compute dot product: $e')));
    }
  }

  Future<List<List<double>>?> _showPointOperationDialog(
    String title,
    Matrix matrix, {
    bool isScale = false,
  }) async {
    final xController = TextEditingController();
    final yController = TextEditingController();

    return showDialog<List<List<double>>?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: xController,
                decoration: InputDecoration(
                  labelText: isScale ? 'Scale X' : 'X',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: yController,
                decoration: InputDecoration(
                  labelText: isScale ? 'Scale Y' : 'Y',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              try {
                final x = double.parse(xController.text);
                final y = double.parse(yController.text);
                final result = isScale
                    ? _scalePoints(matrix.data, x, y)
                    : _addToPoints(matrix.data, x, y);
                Navigator.pop(context, result);
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Invalid input: $e')));
              }
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  static List<List<double>> _addToPoints(
    List<List<double>> matrix,
    double x,
    double y,
  ) {
    return matrix.map((row) {
      if (row.length >= 2) {
        return [row[0] + x, row[1] + y, ...row.sublist(2)];
      }
      return row;
    }).toList();
  }

  static List<List<double>> _scalePoints(
    List<List<double>> matrix,
    double sx,
    double sy,
  ) {
    return matrix.map((row) {
      if (row.length >= 2) {
        return [row[0] * sx, row[1] * sy, ...row.sublist(2)];
      }
      return row;
    }).toList();
  }

  static double _dotProduct(List<List<double>> a, List<List<double>> b) {
    if (a.isEmpty || b.isEmpty) throw 'Matrices cannot be empty';
    if (a[0].isEmpty || b[0].isEmpty) throw 'Matrices must have columns';

    double result = 0;
    for (int i = 0; i < a.length && i < b.length; i++) {
      for (int j = 0; j < a[i].length && j < b[i].length; j++) {
        result += a[i][j] * b[i][j];
      }
    }
    return result;
  }

  void _addResultMatrix(
    String name,
    List<List<double>> data, {
    required String type,
    required List<String> inputs,
  }) {
    final result = Matrix(id: _uuid.v4(), data: data, name: name);
    final op = MatrixOperation(
      id: _uuid.v4(),
      type: type,
      inputMatrixIds: inputs,
      outputMatrixId: result.id,
      description: name,
      createdAt: DateTime.now(),
    );

    setState(() {
      _data = _data.copyWith(
        matrices: [..._data.matrices, result],
        operations: [..._data.operations, op],
      );
      _selectedA = result.id;
    });
    _persist();
  }

  static List<List<double>> _parseMatrixText(String text) {
    final lines = text
        .trim()
        .split('\n')
        .where((l) => l.trim().isNotEmpty)
        .toList();
    if (lines.isEmpty) {
      throw 'Matrix cannot be empty';
    }
    final matrix = <List<double>>[];
    int? width;
    for (final line in lines) {
      final parts = line
          .split(RegExp('[ ,]+'))
          .where((p) => p.trim().isNotEmpty)
          .map(double.parse)
          .toList();
      width ??= parts.length;
      if (parts.length != width) {
        throw 'All rows must have the same number of columns';
      }
      matrix.add(parts);
    }
    return matrix;
  }

  static String _matrixToText(List<List<double>> data) {
    return data.map((row) => row.join(' ')).join('\n');
  }

  static List<List<double>> _transposeMatrix(List<List<double>> m) {
    if (m.isEmpty || m[0].isEmpty) return [];
    final rows = m.length;
    final cols = m[0].length;
    return List.generate(cols, (c) => List.generate(rows, (r) => m[r][c]));
  }

  static List<List<double>> _multiplyMatrices(
    List<List<double>> a,
    List<List<double>> b,
  ) {
    if (a.isEmpty || b.isEmpty) throw 'Empty matrices';
    final aRows = a.length;
    final aCols = a[0].length;
    final bRows = b.length;
    final bCols = b[0].length;
    if (aCols != bRows) {
      throw 'Dimension mismatch (${aRows}x$aCols) · (${bRows}x$bCols)';
    }

    final result = List.generate(aRows, (_) => List.filled(bCols, 0.0));
    for (var i = 0; i < aRows; i++) {
      for (var k = 0; k < aCols; k++) {
        for (var j = 0; j < bCols; j++) {
          result[i][j] += a[i][k] * b[k][j];
        }
      }
    }
    return result;
  }

  static List<List<double>> _invertMatrix(List<List<double>> m) {
    final n = m.length;
    if (n == 0 || m[0].length != n) throw 'Matrix must be square';

    // Create augmented matrix [m | I]
    final aug = List.generate(n, (i) {
      return [
        ...m[i].map((e) => e.toDouble()),
        ...List.generate(n, (j) => i == j ? 1.0 : 0.0),
      ];
    });

    // Gauss-Jordan elimination
    for (var i = 0; i < n; i++) {
      // Find pivot
      var pivot = aug[i][i];
      var pivotRow = i;
      for (var r = i + 1; r < n; r++) {
        if (aug[r][i].abs() > pivot.abs()) {
          pivot = aug[r][i];
          pivotRow = r;
        }
      }
      if (pivot.abs() < 1e-12) throw 'Matrix is singular';

      // Swap rows
      if (pivotRow != i) {
        final tmp = aug[i];
        aug[i] = aug[pivotRow];
        aug[pivotRow] = tmp;
      }

      // Normalize pivot row
      final pivotVal = aug[i][i];
      for (var c = 0; c < 2 * n; c++) {
        aug[i][c] /= pivotVal;
      }

      // Eliminate other rows
      for (var r = 0; r < n; r++) {
        if (r == i) continue;
        final factor = aug[r][i];
        for (var c = 0; c < 2 * n; c++) {
          aug[r][c] -= factor * aug[i][c];
        }
      }
    }

    // Extract inverse
    final inv = List.generate(n, (r) => List.generate(n, (c) => aug[r][n + c]));
    return inv;
  }

  static String _previewRow(Matrix m) {
    if (m.data.isEmpty) return 'empty';
    final firstRow = m.data.first;
    return firstRow.take(3).map((v) => v.toStringAsFixed(2)).join(', ');
  }
}
