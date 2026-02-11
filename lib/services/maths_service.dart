import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../models/maths.dart';
import 'file_service.dart';

/// Service for managing mathematical objects and computations
class MathsService {
  MathsService._();
  static final MathsService instance = MathsService._();

  final FileService _fileService = FileService.instance;
  static const _uuid = Uuid();

  /// Get the maths directory for a workspace
  Future<String> _getMathsDir(String workspaceId) async {
    final dir = await _fileService.getSubdirectory(
      'workspaces/$workspaceId/maths',
    );
    return dir.path;
  }

  /// Create a new matrix object
  Future<MatrixObject> createMatrix({
    required String workspaceId,
    required String name,
    required int rows,
    required int cols,
    List<List<double>>? initialValues,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    // Initialize with zeros if no values provided
    final values =
        initialValues ?? List.generate(rows, (_) => List.filled(cols, 0.0));

    final matrix = MatrixObject(
      id: id,
      name: name,
      workspaceId: workspaceId,
      data: MatrixData(rows: rows, cols: cols, values: values),
      createdAt: now,
      updatedAt: now,
    );

    await saveMathsObject(matrix);
    return matrix;
  }

  /// Create a new graph object
  Future<GraphObject> createGraph({
    required String workspaceId,
    required String name,
    List<String>? equations,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    final graph = GraphObject(
      id: id,
      name: name,
      workspaceId: workspaceId,
      data: GraphData(equations: equations ?? ['x']),
      createdAt: now,
      updatedAt: now,
    );

    await saveMathsObject(graph);
    return graph;
  }

  /// Save a maths object to disk
  Future<void> saveMathsObject(MathsObject object) async {
    final dir = await _getMathsDir(object.workspaceId);
    await Directory(dir).create(recursive: true);

    final file = File(path.join(dir, '${object.id}.json'));
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(object.toJson()),
    );
  }

  /// Load a maths object from disk
  Future<MathsObject?> loadMathsObject({
    required String workspaceId,
    required String objectId,
  }) async {
    try {
      final file = File(
        path.join(await _getMathsDir(workspaceId), '$objectId.json'),
      );
      if (!await file.exists()) return null;

      final json =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      return MathsObject.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  /// List all maths objects in a workspace
  Future<List<MathsObject>> listMathsObjects(String workspaceId) async {
    final dir = Directory(await _getMathsDir(workspaceId));
    if (!await dir.exists()) return [];

    final objects = <MathsObject>[];
    await for (final entity in dir.list()) {
      if (entity is File && entity.path.endsWith('.json')) {
        try {
          final json =
              jsonDecode(await entity.readAsString()) as Map<String, dynamic>;
          objects.add(MathsObject.fromJson(json));
        } catch (e) {
          // Skip invalid files
        }
      }
    }

    // Sort by last updated
    objects.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return objects;
  }

  /// Delete a maths object
  Future<bool> deleteMathsObject({
    required String workspaceId,
    required String objectId,
  }) async {
    try {
      final file = File(
        path.join(await _getMathsDir(workspaceId), '$objectId.json'),
      );
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ============================================================================
  // Matrix Operations with Efficient Algorithms
  // ============================================================================

  /// Transpose a matrix
  static List<List<double>> transpose(List<List<double>> matrix) {
    if (matrix.isEmpty || matrix[0].isEmpty) {
      throw ArgumentError('Matrix cannot be empty');
    }

    final rows = matrix.length;
    final cols = matrix[0].length;
    final result = List.generate(cols, (i) => List.filled(rows, 0.0));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[j][i] = matrix[i][j];
      }
    }

    return result;
  }

  /// Multiply two matrices
  static List<List<double>> multiply(
    List<List<double>> a,
    List<List<double>> b,
  ) {
    if (a.isEmpty || b.isEmpty || a[0].length != b.length) {
      throw ArgumentError('Invalid matrices for multiplication');
    }

    final m = a.length;
    final n = b[0].length;
    final p = a[0].length;
    final result = List.generate(m, (i) => List.filled(n, 0.0));

    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        double sum = 0.0;
        for (int k = 0; k < p; k++) {
          sum += a[i][k] * b[k][j];
        }
        result[i][j] = sum;
      }
    }

    return result;
  }

  /// Add two matrices
  static List<List<double>> add(List<List<double>> a, List<List<double>> b) {
    if (a.length != b.length || a[0].length != b[0].length) {
      throw ArgumentError('Matrices must have same dimensions');
    }

    final rows = a.length;
    final cols = a[0].length;
    final result = List.generate(rows, (i) => List.filled(cols, 0.0));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[i][j] = a[i][j] + b[i][j];
      }
    }

    return result;
  }

  /// Subtract two matrices
  static List<List<double>> subtract(
    List<List<double>> a,
    List<List<double>> b,
  ) {
    if (a.length != b.length || a[0].length != b[0].length) {
      throw ArgumentError('Matrices must have same dimensions');
    }

    final rows = a.length;
    final cols = a[0].length;
    final result = List.generate(rows, (i) => List.filled(cols, 0.0));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[i][j] = a[i][j] - b[i][j];
      }
    }

    return result;
  }

  /// Multiply matrix by scalar
  static List<List<double>> scalarMultiply(
    List<List<double>> matrix,
    double scalar,
  ) {
    final rows = matrix.length;
    final cols = matrix[0].length;
    final result = List.generate(rows, (i) => List.filled(cols, 0.0));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[i][j] = matrix[i][j] * scalar;
      }
    }

    return result;
  }

  /// Calculate determinant using LU decomposition (O(n³))
  static double determinant(List<List<double>> matrix) {
    final n = matrix.length;
    if (n != matrix[0].length) {
      throw ArgumentError('Matrix must be square');
    }

    // Create copy for LU decomposition
    final lu = List.generate(n, (i) => List<double>.from(matrix[i]));
    int swapCount = 0;

    // LU decomposition with partial pivoting
    for (int k = 0; k < n; k++) {
      // Find pivot
      double maxVal = lu[k][k].abs();
      int maxRow = k;
      for (int i = k + 1; i < n; i++) {
        if (lu[i][k].abs() > maxVal) {
          maxVal = lu[i][k].abs();
          maxRow = i;
        }
      }

      // Swap rows if needed
      if (maxRow != k) {
        final temp = lu[k];
        lu[k] = lu[maxRow];
        lu[maxRow] = temp;
        swapCount++;
      }

      // Check for singular matrix
      if (lu[k][k].abs() < 1e-10) {
        return 0.0;
      }

      // Eliminate below
      for (int i = k + 1; i < n; i++) {
        lu[i][k] /= lu[k][k];
        for (int j = k + 1; j < n; j++) {
          lu[i][j] -= lu[i][k] * lu[k][j];
        }
      }
    }

    // Calculate determinant as product of diagonal
    double det = swapCount % 2 == 0 ? 1.0 : -1.0;
    for (int i = 0; i < n; i++) {
      det *= lu[i][i];
    }

    return det;
  }

  /// Invert matrix using Gaussian elimination (O(n³))
  static List<List<double>> inverse(List<List<double>> matrix) {
    final n = matrix.length;
    if (n != matrix[0].length) {
      throw ArgumentError('Matrix must be square');
    }

    // Create augmented matrix [A | I]
    final aug = List.generate(
      n,
      (i) => List<double>.from(matrix[i])..addAll(List.filled(n, 0.0)),
    );
    for (int i = 0; i < n; i++) {
      aug[i][n + i] = 1.0;
    }

    // Forward elimination with partial pivoting
    for (int k = 0; k < n; k++) {
      // Find pivot
      double maxVal = aug[k][k].abs();
      int maxRow = k;
      for (int i = k + 1; i < n; i++) {
        if (aug[i][k].abs() > maxVal) {
          maxVal = aug[i][k].abs();
          maxRow = i;
        }
      }

      // Swap rows
      if (maxRow != k) {
        final temp = aug[k];
        aug[k] = aug[maxRow];
        aug[maxRow] = temp;
      }

      // Check for singular matrix
      if (aug[k][k].abs() < 1e-10) {
        throw ArgumentError('Matrix is singular and cannot be inverted');
      }

      // Scale pivot row
      final pivot = aug[k][k];
      for (int j = 0; j < 2 * n; j++) {
        aug[k][j] /= pivot;
      }

      // Eliminate column
      for (int i = 0; i < n; i++) {
        if (i != k) {
          final factor = aug[i][k];
          for (int j = 0; j < 2 * n; j++) {
            aug[i][j] -= factor * aug[k][j];
          }
        }
      }
    }

    // Extract inverse from augmented matrix
    final result = List.generate(n, (i) => List.filled(n, 0.0));
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        result[i][j] = aug[i][n + j];
      }
    }

    return result;
  }

  /// Convert matrix to row echelon form
  static List<List<double>> rowEchelon(List<List<double>> matrix) {
    final m = matrix.length;
    final n = matrix[0].length;
    final result = List.generate(m, (i) => List<double>.from(matrix[i]));

    int lead = 0;
    for (int r = 0; r < m; r++) {
      if (lead >= n) break;

      // Find pivot
      int i = r;
      while (result[i][lead].abs() < 1e-10) {
        i++;
        if (i == m) {
          i = r;
          lead++;
          if (lead == n) break;
        }
      }
      if (lead == n) break;

      // Swap rows
      final temp = result[i];
      result[i] = result[r];
      result[r] = temp;

      // Scale row
      final pivot = result[r][lead];
      for (int j = 0; j < n; j++) {
        result[r][j] /= pivot;
      }

      // Eliminate below
      for (int i = r + 1; i < m; i++) {
        final factor = result[i][lead];
        for (int j = 0; j < n; j++) {
          result[i][j] -= factor * result[r][j];
        }
      }

      lead++;
    }

    return result;
  }

  // ============================================================================
  // Graph Operations
  // ============================================================================

  /// Evaluate a simple polynomial expression at x
  /// Supports: numbers, x, +, -, *, /, ^, sin, cos, tan, log, exp
  static double evaluateExpression(String expr, double x) {
    try {
      // Replace 'x' with the value — be careful not to replace 'x' inside
      // 'exp' by temporarily replacing function names.
      String processed = expr.replaceAll(' ', '');
      processed = processed.replaceAll('exp', '\u0001');

      // Add implicit multiplication: 2x → 2*x, 2sin → 2*sin, etc.
      processed = processed.replaceAllMapped(
        RegExp(r'(\d)([a-zA-Z(])'),
        (m) => '${m.group(1)}*${m.group(2)}',
      );

      processed = processed.replaceAll('x', '($x)');
      processed = processed.replaceAll('\u0001', 'exp');

      return _ExprParser(processed).parse();
    } catch (e) {
      return double.nan;
    }
  }

  /// Generate plot points for a graph equation
  static List<Map<String, double>> generatePlotPoints({
    required String equation,
    required double xMin,
    required double xMax,
    int points = 200,
  }) {
    final plotPoints = <Map<String, double>>[];
    final step = (xMax - xMin) / points;

    for (int i = 0; i <= points; i++) {
      final x = xMin + i * step;
      final y = evaluateExpression(equation, x);

      if (!y.isNaN && !y.isInfinite) {
        plotPoints.add({'x': x, 'y': y});
      }
    }

    return plotPoints;
  }
}

// ════════════════════════════════════════════════════════════════════
// Recursive-descent expression parser
// Supports: +, -, *, /, ^, unary minus, parentheses,
//           sin, cos, tan, log, exp, sqrt, abs, pi, e
// ════════════════════════════════════════════════════════════════════

class _ExprParser {
  _ExprParser(this._src);

  final String _src;
  int _pos = 0;

  double parse() {
    final result = _expr();
    if (_pos < _src.length) {
      throw FormatException('Unexpected character at $_pos: ${_src[_pos]}');
    }
    return result;
  }

  // expr = term (('+' | '-') term)*
  double _expr() {
    double result = _term();
    while (_pos < _src.length) {
      if (_match('+')) {
        result += _term();
      } else if (_match('-')) {
        result -= _term();
      } else {
        break;
      }
    }
    return result;
  }

  // term = power (('*' | '/') power)*
  double _term() {
    double result = _power();
    while (_pos < _src.length) {
      if (_match('*')) {
        result *= _power();
      } else if (_match('/')) {
        result /= _power();
      } else {
        break;
      }
    }
    return result;
  }

  // power = unary ('^' unary)*   (right-associative)
  double _power() {
    double base = _unary();
    if (_match('^')) {
      final exp = _power(); // right-associative via recursion
      return math.pow(base, exp).toDouble();
    }
    return base;
  }

  // unary = '-' unary | '+' unary | atom
  double _unary() {
    if (_match('-')) return -_unary();
    if (_match('+')) return _unary();
    return _atom();
  }

  // atom = number | '(' expr ')' | function '(' expr ')' | constant
  double _atom() {
    // Parenthesised expression
    if (_match('(')) {
      final result = _expr();
      _expect(')');
      return result;
    }

    // Functions
    if (_matchWord('sin')) return _funcArg(math.sin);
    if (_matchWord('cos')) return _funcArg(math.cos);
    if (_matchWord('tan')) return _funcArg(math.tan);
    if (_matchWord('log')) return _funcArg(math.log);
    if (_matchWord('ln')) return _funcArg(math.log);
    if (_matchWord('exp')) return _funcArg(math.exp);
    if (_matchWord('sqrt')) return _funcArg(math.sqrt);
    if (_matchWord('abs')) return _funcArg((v) => v.abs());

    // Constants
    if (_matchWord('pi')) return math.pi;
    if (_pos < _src.length &&
        _src[_pos] == 'e' &&
        (_pos + 1 >= _src.length || !_isAlpha(_src[_pos + 1]))) {
      _pos++;
      return math.e;
    }

    // Number literal
    return _number();
  }

  double _funcArg(double Function(double) fn) {
    _expect('(');
    final arg = _expr();
    _expect(')');
    return fn(arg);
  }

  double _number() {
    final start = _pos;
    while (_pos < _src.length && (_src[_pos].contains(RegExp(r'[0-9.]')))) {
      _pos++;
    }
    if (_pos == start) {
      throw FormatException(
        'Expected number at $_pos: "${_src.substring(_pos)}"',
      );
    }
    return double.parse(_src.substring(start, _pos));
  }

  bool _match(String ch) {
    if (_pos < _src.length && _src[_pos] == ch) {
      _pos++;
      return true;
    }
    return false;
  }

  bool _matchWord(String word) {
    if (_pos + word.length <= _src.length &&
        _src.substring(_pos, _pos + word.length) == word) {
      // Make sure it's not a prefix of a longer identifier
      if (_pos + word.length < _src.length &&
          _isAlpha(_src[_pos + word.length]) &&
          word != 'e') {
        return false;
      }
      _pos += word.length;
      return true;
    }
    return false;
  }

  void _expect(String ch) {
    if (!_match(ch)) {
      throw FormatException('Expected "$ch" at $_pos');
    }
  }

  bool _isAlpha(String ch) => ch.contains(RegExp(r'[a-zA-Z]'));
}
