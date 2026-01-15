/// Pure matrix computation service with no Flutter dependencies
/// All functions are static and can be tested independently
class MatrixService {
  /// Multiply two matrices: A (m×n) × B (n×p) = C (m×p)
  static List<List<double>> multiply(
    List<List<double>> a,
    List<List<double>> b,
  ) {
    if (a.isEmpty || b.isEmpty || a[0].isEmpty || b[0].isEmpty) {
      throw 'Matrices cannot be empty';
    }

    final aRows = a.length;
    final aCols = a[0].length;
    final bRows = b.length;
    final bCols = b[0].length;

    if (aCols != bRows) {
      throw 'Dimension mismatch: (${aRows}×$aCols) · (${bRows}×$bCols). Inner dimensions must match.';
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

  /// Transpose matrix: A (m×n) → A^T (n×m)
  static List<List<double>> transpose(List<List<double>> a) {
    if (a.isEmpty || a[0].isEmpty) {
      throw 'Matrix cannot be empty';
    }

    final rows = a.length;
    final cols = a[0].length;
    final result = List.generate(cols, (_) => List.filled(rows, 0.0));

    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < cols; j++) {
        result[j][i] = a[i][j];
      }
    }

    return result;
  }

  /// Calculate determinant of square matrix (recursively for small matrices)
  static double determinant(List<List<double>> a) {
    if (a.isEmpty || a[0].isEmpty) {
      throw 'Matrix cannot be empty';
    }

    final n = a.length;
    if (a[0].length != n) {
      throw 'Matrix must be square for determinant. Got ${a.length}×${a[0].length}';
    }

    if (n == 1) return a[0][0];
    if (n == 2) return a[0][0] * a[1][1] - a[0][1] * a[1][0];

    double det = 0;
    for (var j = 0; j < n; j++) {
      det += a[0][j] * (j % 2 == 0 ? 1 : -1) * determinant(_minor(a, 0, j));
    }
    return det;
  }

  /// Calculate matrix inverse: A^-1 (only for square matrices with non-zero determinant)
  static List<List<double>> invert(List<List<double>> a) {
    if (a.isEmpty || a[0].isEmpty) {
      throw 'Matrix cannot be empty';
    }

    final n = a.length;
    if (a[0].length != n) {
      throw 'Only square matrices can be inverted. Got ${a.length}×${a[0].length}';
    }

    final det = determinant(a);
    if (det.abs() < 1e-10) {
      throw 'Matrix is singular (determinant ≈ 0) and cannot be inverted';
    }

    if (n == 1) {
      return [
        [1.0 / a[0][0]],
      ];
    }

    if (n == 2) {
      return [
        [a[1][1] / det, -a[0][1] / det],
        [-a[1][0] / det, a[0][0] / det],
      ];
    }

    // For larger matrices, use Gaussian elimination (more practical)
    return _gaussianInverse(a, det);
  }

  /// Gaussian elimination for matrix inversion
  static List<List<double>> _gaussianInverse(List<List<double>> a, double det) {
    final n = a.length;
    // Create augmented matrix [A | I]
    final augmented = List.generate(
      n,
      (i) => [
        ...List<double>.from(a[i]),
        ...List.generate(n, (j) => i == j ? 1.0 : 0.0),
      ],
    );

    // Forward elimination
    for (var i = 0; i < n; i++) {
      // Find pivot
      var maxRow = i;
      for (var k = i + 1; k < n; k++) {
        if (augmented[k][i].abs() > augmented[maxRow][i].abs()) {
          maxRow = k;
        }
      }

      // Swap rows
      final temp = augmented[i];
      augmented[i] = augmented[maxRow];
      augmented[maxRow] = temp;

      // Make diagonal 1
      final pivot = augmented[i][i];
      for (var j = 0; j < 2 * n; j++) {
        augmented[i][j] /= pivot;
      }

      // Eliminate column
      for (var k = 0; k < n; k++) {
        if (k != i) {
          final factor = augmented[k][i];
          for (var j = 0; j < 2 * n; j++) {
            augmented[k][j] -= factor * augmented[i][j];
          }
        }
      }
    }

    // Extract inverse from right side
    return List.generate(n, (i) => augmented[i].sublist(n).cast<double>());
  }

  /// Get minor matrix (remove row i and column j)
  static List<List<double>> _minor(
    List<List<double>> a,
    int removeRow,
    int removeCol,
  ) {
    final result = <List<double>>[];
    for (var i = 0; i < a.length; i++) {
      if (i == removeRow) continue;
      final row = <double>[];
      for (var j = 0; j < a[i].length; j++) {
        if (j == removeCol) continue;
        row.add(a[i][j]);
      }
      result.add(row);
    }
    return result;
  }

  /// Add point (1×2 or 2×1 vector) to all matrix entries element-wise
  static List<List<double>> addPoint(
    List<List<double>> matrix,
    List<double> point,
  ) {
    if (point.length != 2) {
      throw 'Point must be 2D (x, y)';
    }

    return matrix.map((row) {
      return [
        row[0] + point[0],
        if (row.length > 1) row[1] + point[1],
        ...row.skip(2),
      ];
    }).toList();
  }

  /// Scale all matrix entries by scalar factor
  static List<List<double>> scaleMatrix(
    List<List<double>> matrix,
    double scale,
  ) {
    if (scale == 0) {
      throw 'Scale factor cannot be zero';
    }

    return matrix.map((row) => row.map((val) => val * scale).toList()).toList();
  }

  /// Dot product of two vectors (1D lists)
  static double dotProduct(List<double> a, List<double> b) {
    if (a.length != b.length) {
      throw 'Vectors must have same length for dot product';
    }
    return List.generate(a.length, (i) => a[i] * b[i]).fold(0, (p, n) => p + n);
  }

  /// Validate matrix dimensions are consistent
  static bool isValidMatrix(List<List<double>> matrix) {
    if (matrix.isEmpty) return false;
    final colCount = matrix[0].length;
    return matrix.every((row) => row.length == colCount);
  }

  /// Get matrix dimensions as "m×n" string
  static String getDimensions(List<List<double>> matrix) {
    if (matrix.isEmpty) return '0×0';
    return '${matrix.length}×${matrix[0].length}';
  }
}
