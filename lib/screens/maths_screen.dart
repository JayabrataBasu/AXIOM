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
                GraphVisualizerTab(
                  workspaceId: widget.workspaceId,
                  mathsObjectId: widget.mathsObjectId,
                  graph: obj,
                ),
                GraphEquationsTab(
                  workspaceId: widget.workspaceId,
                  mathsObjectId: widget.mathsObjectId,
                  graph: obj,
                ),
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

// ════════════════════════════════════════════════════════════════════
// GRAPH VISUALIZER TAB — CustomPainter-based equation rendering
// ════════════════════════════════════════════════════════════════════

class GraphVisualizerTab extends ConsumerStatefulWidget {
  final String workspaceId;
  final String mathsObjectId;
  final GraphObject graph;

  const GraphVisualizerTab({
    super.key,
    required this.workspaceId,
    required this.mathsObjectId,
    required this.graph,
  });

  @override
  ConsumerState<GraphVisualizerTab> createState() => _GraphVisualizerTabState();
}

class _GraphVisualizerTabState extends ConsumerState<GraphVisualizerTab> {
  late TransformationController _transformController;

  @override
  void initState() {
    super.initState();
    _transformController = TransformationController();
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  /// Generate all plot data for current equations
  List<List<Offset>> _generateAllPlots(GraphData data) {
    final plots = <List<Offset>>[];

    debugPrint('═══ Graph Plot Generation ═══');
    debugPrint('Equations: ${data.equations}');
    debugPrint('Domain: [${data.domainMin}, ${data.domainMax}]');
    debugPrint('Range: [${data.rangeMin}, ${data.rangeMax}]');

    for (final eq in data.equations) {
      if (eq.trim().isEmpty) continue;
      try {
        final points = MathsService.generatePlotPoints(
          equation: eq,
          xMin: data.domainMin,
          xMax: data.domainMax,
          points: data.plotPoints,
        );
        final offsets = points.map((p) => Offset(p['x']!, p['y']!)).toList();
        debugPrint('Equation "$eq": Generated ${offsets.length} points');
        if (offsets.isNotEmpty) {
          debugPrint('  First point: ${offsets.first}, Last point: ${offsets.last}');
        }
        plots.add(offsets);
      } catch (e, stack) {
        // Log error for debugging
        debugPrint('❌ Error plotting equation "$eq": $e');
        debugPrint('Stack: $stack');
        plots.add([]);
      }
    }
    debugPrint('═══════════════════════════════');
    return plots;
  }

  Future<void> _updateDomain(double min, double max) async {
    final notifier = ref.read(
      mathsObjectNotifierProvider((
        widget.workspaceId,
        widget.mathsObjectId,
      )).notifier,
    );
    final mathsObj = await ref.read(
      mathsObjectProvider(widget.mathsObjectId).future,
    );
    if (mathsObj is! GraphObject) return;
    await notifier.updateGraphData(
      mathsObj.data.copyWith(domainMin: min, domainMax: max),
    );
  }

  Future<void> _updateRange(double min, double max) async {
    final notifier = ref.read(
      mathsObjectNotifierProvider((
        widget.workspaceId,
        widget.mathsObjectId,
      )).notifier,
    );
    final mathsObj = await ref.read(
      mathsObjectProvider(widget.mathsObjectId).future,
    );
    if (mathsObj is! GraphObject) return;
    await notifier.updateGraphData(
      mathsObj.data.copyWith(rangeMin: min, rangeMax: max),
    );
  }

  Future<void> _autoFit() async {
    final mathsObj = await ref.read(
      mathsObjectProvider(widget.mathsObjectId).future,
    );
    if (mathsObj is! GraphObject) return;

    final data = mathsObj.data;
    double minX = data.domainMin;
    double maxX = data.domainMax;
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    // Sample all equations to find Y range
    for (final eq in data.equations) {
      if (eq.trim().isEmpty) continue;
      try {
        final points = MathsService.generatePlotPoints(
          equation: eq,
          xMin: minX,
          xMax: maxX,
          points: 100,
        );
        for (final p in points) {
          final y = p['y']!;
          if (y.isFinite) {
            if (y < minY) minY = y;
            if (y > maxY) maxY = y;
          }
        }
      } catch (_) {}
    }

    if (!minY.isFinite || !maxY.isFinite) return;

    // Add 10% padding
    final yPadding = (maxY - minY) * 0.1;
    minY -= yPadding;
    maxY += yPadding;

    final notifier = ref.read(
      mathsObjectNotifierProvider((
        widget.workspaceId,
        widget.mathsObjectId,
      )).notifier,
    );
    await notifier.updateGraphData(
      data.copyWith(rangeMin: minY, rangeMax: maxY),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider so we rebuild when equations change
    final mathsObjAsync = ref.watch(mathsObjectProvider(widget.mathsObjectId));

    return mathsObjAsync.when(
      data: (mathsObj) {
        if (mathsObj is! GraphObject) {
          return const Center(child: Text('Not a graph object'));
        }

        final data = mathsObj.data;
        final plots = _generateAllPlots(data);

        final curveColors = [
          AxiomColors.aqua,
          AxiomColors.purple,
          AxiomColors.orange,
          AxiomColors.blue,
          AxiomColors.red,
          AxiomColors.green,
        ];

        return Column(
          children: [
            // Domain / Range controls
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AxiomSpacing.md,
                vertical: AxiomSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AxiomColors.bg1,
                border: Border(
                  bottom: BorderSide(color: AxiomColors.bg3, width: 1),
                ),
              ),
              child: Row(
                children: [
                  _DomainChip(
                    label: 'x',
                    min: data.domainMin,
                    max: data.domainMax,
                    onChanged: _updateDomain,
                  ),
                  const SizedBox(width: AxiomSpacing.sm),
                  _DomainChip(
                    label: 'y',
                    min: data.rangeMin,
                    max: data.rangeMax,
                    onChanged: _updateRange,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.fit_screen, size: 20),
                    tooltip: 'Auto Fit',
                    onPressed: _autoFit,
                    color: AxiomColors.aqua,
                  ),
                  IconButton(
                    icon: const Icon(Icons.center_focus_strong, size: 20),
                    tooltip: 'Reset View',
                    onPressed: () =>
                        _transformController.value = Matrix4.identity(),
                    color: AxiomColors.grey1,
                  ),
                ],
              ),
            ),

            // Graph canvas
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return InteractiveViewer(
                    transformationController: _transformController,
                    boundaryMargin: const EdgeInsets.all(100),
                    minScale: 0.3,
                    maxScale: 5.0,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: CustomPaint(
                        painter: _GraphPainter(
                          plots: plots,
                          colors: curveColors,
                          domainMin: data.domainMin,
                          domainMax: data.domainMax,
                          rangeMin: data.rangeMin,
                          rangeMax: data.rangeMax,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Equation legend
            if (data.equations.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(AxiomSpacing.sm),
                decoration: BoxDecoration(
                  color: AxiomColors.bg1,
                  border: Border(
                    top: BorderSide(color: AxiomColors.bg3, width: 1),
                  ),
                ),
                child: Wrap(
                  spacing: AxiomSpacing.md,
                  children: List.generate(data.equations.length, (i) {
                    final color = curveColors[i % curveColors.length];
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 14, height: 3, color: color),
                        const SizedBox(width: 4),
                        Text(
                          'y = ${data.equations[i]}',
                          style: AxiomTypography.labelSmall.copyWith(
                            color: color,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text('Error: $e', style: TextStyle(color: AxiomColors.red)),
      ),
    );
  }
}

/// Compact domain/range editor chip
class _DomainChip extends StatelessWidget {
  final String label;
  final double min;
  final double max;
  final void Function(double min, double max) onChanged;

  const _DomainChip({
    required this.label,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final minC = TextEditingController(text: min.toStringAsFixed(1));
        final maxC = TextEditingController(text: max.toStringAsFixed(1));
        final result = await showDialog<(double, double)?>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('$label range'),
            content: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minC,
                    decoration: const InputDecoration(
                      labelText: 'Min',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: maxC,
                    decoration: const InputDecoration(
                      labelText: 'Max',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final newMin = double.tryParse(minC.text);
                  final newMax = double.tryParse(maxC.text);
                  if (newMin != null && newMax != null && newMin < newMax) {
                    Navigator.pop(ctx, (newMin, newMax));
                  }
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        );
        if (result != null) onChanged(result.$1, result.$2);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.sm,
          vertical: AxiomSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AxiomColors.bg2,
          borderRadius: BorderRadius.circular(AxiomRadius.sm),
        ),
        child: Text(
          '$label: [${min.toStringAsFixed(1)}, ${max.toStringAsFixed(1)}]',
          style: AxiomTypography.labelSmall.copyWith(color: AxiomColors.fg),
        ),
      ),
    );
  }
}

/// CustomPainter that draws the coordinate grid and equation curves
class _GraphPainter extends CustomPainter {
  final List<List<Offset>> plots;
  final List<Color> colors;
  final double domainMin, domainMax, rangeMin, rangeMax;

  _GraphPainter({
    required this.plots,
    required this.colors,
    required this.domainMin,
    required this.domainMax,
    required this.rangeMin,
    required this.rangeMax,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Coordinate mapping
    double toX(double val) => (val - domainMin) / (domainMax - domainMin) * w;
    double toY(double val) => h - (val - rangeMin) / (rangeMax - rangeMin) * h;

    // ── Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFFFDF6E3),
    );

    // ── Grid lines (light)
    final gridPaint = Paint()
      ..color = const Color(0xFFE6E2CC)
      ..strokeWidth = 0.5;

    // Vertical grid
    for (double x = domainMin.ceilToDouble(); x <= domainMax; x += 1) {
      final px = toX(x);
      canvas.drawLine(Offset(px, 0), Offset(px, h), gridPaint);
    }
    // Horizontal grid
    for (double y = rangeMin.ceilToDouble(); y <= rangeMax; y += 1) {
      final py = toY(y);
      canvas.drawLine(Offset(0, py), Offset(w, py), gridPaint);
    }

    // ── Axes (bold)
    final axisPaint = Paint()
      ..color = const Color(0xFF5C6A72)
      ..strokeWidth = 1.5;

    // X-axis
    if (rangeMin <= 0 && rangeMax >= 0) {
      final y0 = toY(0);
      canvas.drawLine(Offset(0, y0), Offset(w, y0), axisPaint);
    }
    // Y-axis
    if (domainMin <= 0 && domainMax >= 0) {
      final x0 = toX(0);
      canvas.drawLine(Offset(x0, 0), Offset(x0, h), axisPaint);
    }

    // ── Tick labels
    final textStyle = const TextStyle(color: Color(0xFF829181), fontSize: 9);
    final xStep = _niceStep(domainMax - domainMin);
    for (
      double x = (domainMin / xStep).ceilToDouble() * xStep;
      x <= domainMax;
      x += xStep
    ) {
      if (x.abs() < xStep * 0.01) continue; // skip 0
      final tp = TextPainter(
        text: TextSpan(
          text: x.toStringAsFixed(x == x.roundToDouble() ? 0 : 1),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final px = toX(x);
      final y0 = rangeMin <= 0 && rangeMax >= 0 ? toY(0) : h - 2;
      tp.paint(canvas, Offset(px - tp.width / 2, y0 + 2));
    }
    final yStep = _niceStep(rangeMax - rangeMin);
    for (
      double y = (rangeMin / yStep).ceilToDouble() * yStep;
      y <= rangeMax;
      y += yStep
    ) {
      if (y.abs() < yStep * 0.01) continue;
      final tp = TextPainter(
        text: TextSpan(
          text: y.toStringAsFixed(y == y.roundToDouble() ? 0 : 1),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final py = toY(y);
      final x0 = domainMin <= 0 && domainMax >= 0 ? toX(0) : 2.0;
      tp.paint(canvas, Offset(x0 + 3, py - tp.height / 2));
    }

    // ── Curves
    for (int i = 0; i < plots.length; i++) {
      final pts = plots[i];
      if (pts.length < 2) continue;

      final curvePaint = Paint()
        ..color = colors[i % colors.length]
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path();
      bool started = false;

      for (final pt in pts) {
        // Clip to visible range
        if (pt.dy < rangeMin || pt.dy > rangeMax) {
          started = false;
          continue;
        }
        final sx = toX(pt.dx);
        final sy = toY(pt.dy);
        if (!started) {
          path.moveTo(sx, sy);
          started = true;
        } else {
          path.lineTo(sx, sy);
        }
      }
      canvas.drawPath(path, curvePaint);
    }
  }

  double _niceStep(double range) {
    final rough = range / 10;
    final mag = _pow10(rough.abs().floor().toString().length - 1);
    final norm = rough / mag;
    if (norm < 1.5) return mag.toDouble();
    if (norm < 3.5) return (2 * mag).toDouble();
    if (norm < 7.5) return (5 * mag).toDouble();
    return (10 * mag).toDouble();
  }

  int _pow10(int exp) {
    int result = 1;
    for (int i = 0; i < exp; i++) {
      result *= 10;
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant _GraphPainter old) =>
      old.plots != plots ||
      old.domainMin != domainMin ||
      old.domainMax != domainMax;
}

// ════════════════════════════════════════════════════════════════════
// GRAPH EQUATIONS TAB — equation input and management
// ════════════════════════════════════════════════════════════════════

class GraphEquationsTab extends ConsumerStatefulWidget {
  final String workspaceId;
  final String mathsObjectId;
  final GraphObject graph;

  const GraphEquationsTab({
    super.key,
    required this.workspaceId,
    required this.mathsObjectId,
    required this.graph,
  });

  @override
  ConsumerState<GraphEquationsTab> createState() => _GraphEquationsTabState();
}

class _GraphEquationsTabState extends ConsumerState<GraphEquationsTab> {
  late List<TextEditingController> _eqControllers;
  List<String> _lastEquations = [];

  @override
  void initState() {
    super.initState();
    _lastEquations = widget.graph.data.equations;
    _initControllers();
  }

  void _initControllers() {
    _eqControllers = _lastEquations
        .map((eq) => TextEditingController(text: eq))
        .toList();
  }

  void _disposeControllers() {
    for (final c in _eqControllers) {
      c.dispose();
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  Future<void> _saveEquations() async {
    final equations = _eqControllers
        .map((c) => c.text.trim())
        .where((eq) => eq.isNotEmpty)
        .toList();

    final notifier = ref.read(
      mathsObjectNotifierProvider((
        widget.workspaceId,
        widget.mathsObjectId,
      )).notifier,
    );

    final mathsObj = await ref.read(
      mathsObjectProvider(widget.mathsObjectId).future,
    );
    if (mathsObj is! GraphObject) return;

    await notifier.updateGraphData(
      mathsObj.data.copyWith(equations: equations),
    );

    if (!mounted) return;

    // Clear any existing snackbars first
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${equations.length} equation(s) saved'),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            if (mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              DefaultTabController.of(context).animateTo(0);
            }
          },
        ),
      ),
    );
  }

  void _addEquation() {
    setState(() {
      _eqControllers.add(TextEditingController());
    });
  }

  void _removeEquation(int index) {
    setState(() {
      _eqControllers[index].dispose();
      _eqControllers.removeAt(index);
    });
    _saveEquations();
  }

  bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider to rebuild when equations change from elsewhere
    final mathsObjAsync = ref.watch(
      mathsObjectProvider(widget.mathsObjectId),
    );

    // Update controllers if the saved equations differ from what we're editing
    mathsObjAsync.whenData((obj) {
      if (obj is GraphObject) {
        final savedEquations = obj.data.equations;
        // Only update if saved equations differ and we're not currently editing
        if (!_listsEqual(_lastEquations, savedEquations)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _lastEquations = savedEquations;
                _disposeControllers();
                _initControllers();
              });
            }
          });
        }
      }
    });

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
              Text(
                'Equations',
                style: AxiomTypography.heading3.copyWith(color: AxiomColors.fg),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _saveEquations,
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AxiomColors.green,
                  foregroundColor: AxiomColors.bg0,
                ),
              ),
              const SizedBox(width: AxiomSpacing.sm),
              IconButton(
                onPressed: _addEquation,
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'Add Equation',
                color: AxiomColors.aqua,
              ),
            ],
          ),
        ),

        // Equation list
        Expanded(
          child: _eqControllers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.functions, size: 48, color: AxiomColors.grey1),
                      const SizedBox(height: AxiomSpacing.md),
                      Text(
                        'No equations yet',
                        style: AxiomTypography.bodyMedium.copyWith(
                          color: AxiomColors.grey1,
                        ),
                      ),
                      const SizedBox(height: AxiomSpacing.sm),
                      TextButton.icon(
                        onPressed: _addEquation,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Equation'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AxiomSpacing.md),
                  itemCount: _eqControllers.length,
                  itemBuilder: (context, index) {
                    final curveColors = [
                      AxiomColors.aqua,
                      AxiomColors.purple,
                      AxiomColors.orange,
                      AxiomColors.blue,
                      AxiomColors.red,
                      AxiomColors.green,
                    ];
                    final color = curveColors[index % curveColors.length];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AxiomSpacing.sm),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: AxiomSpacing.sm),
                          Text(
                            'y =',
                            style: AxiomTypography.bodyMedium.copyWith(
                              color: AxiomColors.grey1,
                            ),
                          ),
                          const SizedBox(width: AxiomSpacing.sm),
                          Expanded(
                            child: TextField(
                              controller: _eqControllers[index],
                              style: AxiomTypography.bodyMedium,
                              decoration: InputDecoration(
                                hintText: 'e.g. x^2, sin(x), 2*x+1',
                                hintStyle: AxiomTypography.bodyMedium.copyWith(
                                  color: AxiomColors.grey2,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AxiomRadius.sm,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AxiomSpacing.sm,
                                  vertical: AxiomSpacing.sm,
                                ),
                              ),
                              onSubmitted: (_) => _saveEquations(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 18,
                              color: AxiomColors.red,
                            ),
                            onPressed: () => _removeEquation(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),

        // Help hint
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AxiomSpacing.sm),
          color: AxiomColors.bg1,
          child: Text(
            'Supported: x, +, -, *, /, ^, sin(), cos(), tan(), log(), exp()',
            style: AxiomTypography.labelSmall.copyWith(
              color: AxiomColors.grey1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
