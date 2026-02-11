import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/maths.dart';
import '../providers/maths_provider.dart';
import '../services/maths_service.dart';
import '../theme/design_tokens.dart';

/// Screen for viewing and editing mathematical objects (matrices and graphs)
class MathsScreen extends ConsumerStatefulWidget {
  final String workspaceId;
  final String mathsObjectId;

  const MathsScreen({
    super.key,
    required this.workspaceId,
    required this.mathsObjectId,
  });

  @override
  ConsumerState<MathsScreen> createState() => _MathsScreenState();
}

class _MathsScreenState extends ConsumerState<MathsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Set active workspace
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activeMathsWorkspaceProvider.notifier).state =
          widget.workspaceId;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mathsObjectAsync = ref.watch(
      mathsObjectProvider(widget.mathsObjectId),
    );

    return Scaffold(
      backgroundColor: AxiomColors.bg0,
      appBar: AppBar(
        backgroundColor: AxiomColors.bg0,
        foregroundColor: AxiomColors.fg,
        elevation: 0,
        title: mathsObjectAsync.when(
          data: (obj) => Text(
            obj?.name ?? 'Maths Object',
            style: AxiomTypography.heading2,
          ),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
        bottom: mathsObjectAsync.maybeWhen(
          data: (obj) {
            if (obj is MatrixObject) {
              return TabBar(
                controller: _tabController,
                labelColor: AxiomColors.aqua,
                unselectedLabelColor: AxiomColors.grey1,
                indicatorColor: AxiomColors.aqua,
                tabs: const [
                  Tab(text: 'Matrix'),
                  Tab(text: 'Operations'),
                ],
              );
            } else if (obj is GraphObject) {
              return TabBar(
                controller: _tabController,
                labelColor: AxiomColors.aqua,
                unselectedLabelColor: AxiomColors.grey1,
                indicatorColor: AxiomColors.aqua,
                tabs: const [
                  Tab(text: 'Graph'),
                  Tab(text: 'Equations'),
                ],
              );
            }
            return null;
          },
          orElse: () => null,
        ),
      ),
      body: mathsObjectAsync.when(
        data: (obj) {
          if (obj == null) {
            return const Center(child: Text('Maths object not found'));
          }

          if (obj is MatrixObject) {
            return TabBarView(
              controller: _tabController,
              children: [
                MatrixEditorTab(
                  workspaceId: widget.workspaceId,
                  mathsObjectId: widget.mathsObjectId,
                  matrix: obj,
                ),
                MatrixOperationsTab(
                  workspaceId: widget.workspaceId,
                  mathsObjectId: widget.mathsObjectId,
                  matrix: obj,
                ),
              ],
            );
          } else if (obj is GraphObject) {
            return TabBarView(
              controller: _tabController,
              children: [
                GraphVisualizerTab(graph: obj),
                GraphEquationsTab(graph: obj),
              ],
            );
          }

          return const Center(child: Text('Unknown maths object type'));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

/// Tab for editing matrix values
class MatrixEditorTab extends ConsumerStatefulWidget {
  final String workspaceId;
  final String mathsObjectId;
  final MatrixObject matrix;

  const MatrixEditorTab({
    super.key,
    required this.workspaceId,
    required this.mathsObjectId,
    required this.matrix,
  });

  @override
  ConsumerState<MatrixEditorTab> createState() => _MatrixEditorTabState();
}

class _MatrixEditorTabState extends ConsumerState<MatrixEditorTab> {
  late List<List<TextEditingController>> _controllers;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _controllers = List.generate(
      widget.matrix.data.rows,
      (row) => List.generate(
        widget.matrix.data.cols,
        (col) => TextEditingController(
          text: widget.matrix.data.values[row][col].toString(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var row in _controllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _saveMatrix() async {
    setState(() => _isEditing = false);

    // Parse values from controllers
    final newValues = List.generate(
      widget.matrix.data.rows,
      (row) => List.generate(
        widget.matrix.data.cols,
        (col) => double.tryParse(_controllers[row][col].text) ?? 0.0,
      ),
    );

    // Update matrix data
    final newData = widget.matrix.data.copyWith(values: newValues);
    final notifier = ref.read(
      mathsObjectNotifierProvider((
        widget.workspaceId,
        widget.mathsObjectId,
      )).notifier,
    );
    await notifier.updateMatrixData(newData);
  }

  Future<void> _addRow() async {
    final newValues = [
      ...widget.matrix.data.values,
      List.filled(widget.matrix.data.cols, 0.0),
    ];

    final newData = widget.matrix.data.copyWith(
      rows: widget.matrix.data.rows + 1,
      values: newValues,
    );

    final notifier = ref.read(
      mathsObjectNotifierProvider((
        widget.workspaceId,
        widget.mathsObjectId,
      )).notifier,
    );
    await notifier.updateMatrixData(newData);
    _initControllers();
  }

  Future<void> _addColumn() async {
    final newValues = widget.matrix.data.values
        .map((row) => [...row, 0.0])
        .toList();

    final newData = widget.matrix.data.copyWith(
      cols: widget.matrix.data.cols + 1,
      values: newValues,
    );

    final notifier = ref.read(
      mathsObjectNotifierProvider((
        widget.workspaceId,
        widget.mathsObjectId,
      )).notifier,
    );
    await notifier.updateMatrixData(newData);
    _initControllers();
  }

  Future<void> _removeRow() async {
    if (widget.matrix.data.rows <= 1) return;

    final newValues = widget.matrix.data.values.sublist(
      0,
      widget.matrix.data.rows - 1,
    );

    final newData = widget.matrix.data.copyWith(
      rows: widget.matrix.data.rows - 1,
      values: newValues,
    );

    final notifier = ref.read(
      mathsObjectNotifierProvider((
        widget.workspaceId,
        widget.mathsObjectId,
      )).notifier,
    );
    await notifier.updateMatrixData(newData);
    _initControllers();
  }

  Future<void> _removeColumn() async {
    if (widget.matrix.data.cols <= 1) return;

    final newValues = widget.matrix.data.values
        .map((row) => row.sublist(0, widget.matrix.data.cols - 1))
        .toList();

    final newData = widget.matrix.data.copyWith(
      cols: widget.matrix.data.cols - 1,
      values: newValues,
    );

    final notifier = ref.read(
      mathsObjectNotifierProvider((
        widget.workspaceId,
        widget.mathsObjectId,
      )).notifier,
    );
    await notifier.updateMatrixData(newData);
    _initControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toolbar
        Container(
          padding: const EdgeInsets.all(AxiomSpacing.md),
          decoration: BoxDecoration(
            color: AxiomColors.bg1,
            border: Border(
              bottom: BorderSide(color: AxiomColors.bg3, width: 1),
            ),
          ),
          child: Row(
            children: [
              if (_isEditing) ...[
                ElevatedButton.icon(
                  onPressed: _saveMatrix,
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AxiomColors.green,
                    foregroundColor: AxiomColors.bg0,
                  ),
                ),
                const SizedBox(width: AxiomSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _isEditing = false);
                    _initControllers();
                  },
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Cancel'),
                ),
              ] else ...[
                OutlinedButton.icon(
                  onPressed: () => setState(() => _isEditing = true),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
              ],
              const Spacer(),
              Text(
                '${widget.matrix.data.rows}×${widget.matrix.data.cols}',
                style: AxiomTypography.bodyMedium.copyWith(
                  color: AxiomColors.grey1,
                ),
              ),
              const SizedBox(width: AxiomSpacing.md),
              IconButton(
                onPressed: _addRow,
                icon: const Icon(Icons.add_box, size: 20),
                tooltip: 'Add Row',
                color: AxiomColors.green,
              ),
              IconButton(
                onPressed: _addColumn,
                icon: const Icon(Icons.add_box_outlined, size: 20),
                tooltip: 'Add Column',
                color: AxiomColors.aqua,
              ),
              if (widget.matrix.data.rows > 1)
                IconButton(
                  onPressed: _removeRow,
                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                  tooltip: 'Remove Row',
                  color: AxiomColors.red,
                ),
              if (widget.matrix.data.cols > 1)
                IconButton(
                  onPressed: _removeColumn,
                  icon: const Icon(
                    Icons.indeterminate_check_box_outlined,
                    size: 20,
                  ),
                  tooltip: 'Remove Column',
                  color: AxiomColors.orange,
                ),
            ],
          ),
        ),

        // Matrix Grid
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AxiomSpacing.lg),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildMatrixGrid(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMatrixGrid() {
    return Container(
      padding: const EdgeInsets.all(AxiomSpacing.md),
      decoration: BoxDecoration(
        color: AxiomColors.bg1,
        borderRadius: BorderRadius.circular(AxiomRadius.md),
        border: Border.all(color: AxiomColors.bg3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          widget.matrix.data.rows,
          (row) => Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.matrix.data.cols,
              (col) => Container(
                width: 80,
                height: 50,
                margin: const EdgeInsets.all(4),
                child: TextField(
                  controller: _controllers[row][col],
                  enabled: _isEditing,
                  textAlign: TextAlign.center,
                  style: AxiomTypography.bodyMedium,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
                  ],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _isEditing ? AxiomColors.bg0 : AxiomColors.bg2,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AxiomRadius.sm),
                      borderSide: BorderSide(color: AxiomColors.bg3),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AxiomRadius.sm),
                      borderSide: BorderSide(color: AxiomColors.bg3),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AxiomRadius.sm),
                      borderSide: BorderSide(color: AxiomColors.aqua, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AxiomSpacing.sm,
                      vertical: AxiomSpacing.sm,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tab for matrix operations
class MatrixOperationsTab extends ConsumerWidget {
  final String workspaceId;
  final String mathsObjectId;
  final MatrixObject matrix;

  const MatrixOperationsTab({
    super.key,
    required this.workspaceId,
    required this.mathsObjectId,
    required this.matrix,
  });

  Future<void> _performOperation(
    BuildContext context,
    WidgetRef ref,
    MathsOperationType type,
  ) async {
    try {
      final notifier = ref.read(
        mathsObjectNotifierProvider((workspaceId, mathsObjectId)).notifier,
      );

      switch (type) {
        case MathsOperationType.transpose:
          final result = MathsService.transpose(matrix.data.values);
          await notifier.addOperation(
            MathsOperation(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              type: MathsOperationType.transpose,
              inputs: {'rows': matrix.data.rows, 'cols': matrix.data.cols},
              result: {
                'matrix': result.map((r) => r.map((v) => v).toList()).toList(),
              },
              timestamp: DateTime.now(),
            ),
          );
          break;

        case MathsOperationType.determinant:
          final result = MathsService.determinant(matrix.data.values);
          await notifier.addOperation(
            MathsOperation(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              type: MathsOperationType.determinant,
              inputs: {'rows': matrix.data.rows, 'cols': matrix.data.cols},
              result: {'value': result},
              timestamp: DateTime.now(),
            ),
          );
          break;

        case MathsOperationType.inverse:
          try {
            final result = MathsService.inverse(matrix.data.values);
            await notifier.addOperation(
              MathsOperation(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                type: MathsOperationType.inverse,
                inputs: {'rows': matrix.data.rows, 'cols': matrix.data.cols},
                result: {
                  'matrix': result
                      .map((r) => r.map((v) => v).toList())
                      .toList(),
                },
                timestamp: DateTime.now(),
              ),
            );
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
            }
          }
          break;

        case MathsOperationType.rowEchelon:
          final result = MathsService.rowEchelon(matrix.data.values);
          await notifier.addOperation(
            MathsOperation(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              type: MathsOperationType.rowEchelon,
              inputs: {'rows': matrix.data.rows, 'cols': matrix.data.cols},
              result: {
                'matrix': result.map((r) => r.map((v) => v).toList()).toList(),
              },
              timestamp: DateTime.now(),
            ),
          );
          break;

        default:
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Operation not yet implemented')),
            );
          }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Operations Panel
        Container(
          padding: const EdgeInsets.all(AxiomSpacing.md),
          decoration: BoxDecoration(
            color: AxiomColors.bg1,
            border: Border(
              bottom: BorderSide(color: AxiomColors.bg3, width: 1),
            ),
          ),
          child: Wrap(
            spacing: AxiomSpacing.sm,
            runSpacing: AxiomSpacing.sm,
            children: [
              _OperationButton(
                label: 'Transpose',
                icon: Icons.swap_horiz,
                color: AxiomColors.blue,
                onPressed: () => _performOperation(
                  context,
                  ref,
                  MathsOperationType.transpose,
                ),
              ),
              _OperationButton(
                label: 'Determinant',
                icon: Icons.calculate,
                color: AxiomColors.purple,
                onPressed: () => _performOperation(
                  context,
                  ref,
                  MathsOperationType.determinant,
                ),
              ),
              _OperationButton(
                label: 'Inverse',
                icon: Icons.functions,
                color: AxiomColors.green,
                onPressed: () =>
                    _performOperation(context, ref, MathsOperationType.inverse),
              ),
              _OperationButton(
                label: 'Row Echelon',
                icon: Icons.layers,
                color: AxiomColors.orange,
                onPressed: () => _performOperation(
                  context,
                  ref,
                  MathsOperationType.rowEchelon,
                ),
              ),
            ],
          ),
        ),

        // Operations History
        Expanded(
          child: matrix.operations.isEmpty
              ? Center(
                  child: Text(
                    'No operations yet',
                    style: AxiomTypography.bodyMedium.copyWith(
                      color: AxiomColors.grey1,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AxiomSpacing.md),
                  itemCount: matrix.operations.length,
                  itemBuilder: (context, index) {
                    final op =
                        matrix.operations[matrix.operations.length - 1 - index];
                    return _OperationResultCard(operation: op);
                  },
                ),
        ),
      ],
    );
  }
}

class _OperationButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _OperationButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.15),
        foregroundColor: color,
        elevation: 0,
      ),
    );
  }
}

class _OperationResultCard extends StatelessWidget {
  final MathsOperation operation;

  const _OperationResultCard({required this.operation});

  String _formatTimestamp() {
    final now = DateTime.now();
    final diff = now.difference(operation.timestamp);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AxiomSpacing.md),
      color: AxiomColors.bg1,
      child: Padding(
        padding: const EdgeInsets.all(AxiomSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AxiomSpacing.sm,
                    vertical: AxiomSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AxiomColors.aqua.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AxiomRadius.sm),
                  ),
                  child: Text(
                    operation.type.name.toUpperCase(),
                    style: AxiomTypography.labelSmall.copyWith(
                      color: AxiomColors.aqua,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTimestamp(),
                  style: AxiomTypography.labelSmall.copyWith(
                    color: AxiomColors.grey1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AxiomSpacing.sm),
            _buildResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    final result = operation.result;

    // Scalar result (determinant, etc.)
    if (result.containsKey('value')) {
      final value = result['value'];
      return Text(
        'Result: ${(value is num) ? value.toStringAsFixed(4) : value}',
        style: AxiomTypography.heading2,
      );
    }

    // Matrix result (transpose, inverse, row echelon)
    if (result.containsKey('matrix')) {
      final raw = result['matrix'];
      if (raw is List) {
        final matrix = raw
            .map(
              (row) => (row as List).map((v) => (v as num).toDouble()).toList(),
            )
            .toList();
        return _buildMatrixResult(matrix);
      }
    }

    // Fallback
    return Text('Result: $result', style: AxiomTypography.bodyMedium);
  }

  Widget _buildMatrixResult(List<List<double>> matrix) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: matrix
            .map(
              (row) => Row(
                children: row
                    .map(
                      (value) => Container(
                        width: 60,
                        padding: const EdgeInsets.all(AxiomSpacing.xs),
                        child: Text(
                          value.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: AxiomTypography.bodyMedium,
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}

// Placeholder tabs for graph functionality
class GraphVisualizerTab extends StatelessWidget {
  final GraphObject graph;

  const GraphVisualizerTab({super.key, required this.graph});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Graph visualizer coming soon'));
  }
}

class GraphEquationsTab extends StatelessWidget {
  final GraphObject graph;

  const GraphEquationsTab({super.key, required this.graph});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Graph equations editor coming soon'));
  }
}
