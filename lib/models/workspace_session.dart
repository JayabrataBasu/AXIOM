import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_session.freezed.dart';
part 'workspace_session.g.dart';

/// Base class for workspace sessions.
/// Each workspace type extends this with its own data structure.
@freezed
class WorkspaceSession with _$WorkspaceSession {
  const WorkspaceSession._();

  const factory WorkspaceSession({
    /// Unique identifier for this session
    required String id,

    /// Type of workspace (matrix_calculator, pdf_viewer, graph_plotter, etc.)
    required String workspaceType,

    /// When this session was created
    required DateTime createdAt,

    /// When this session was last modified
    required DateTime updatedAt,

    /// Parent session ID if this is a fork (null for original sessions)
    String? parentSessionId,

    /// Workspace-specific data (serialized as JSON)
    required Map<String, dynamic> data,

    /// Optional label/title for the session
    @Default('') String label,
  }) = _WorkspaceSession;

  /// Get a preview/summary of the session for display
  String get preview {
    if (label.isNotEmpty) return label;
    return switch (workspaceType) {
      'matrix_calculator' => _matrixPreview(data),
      'pdf_viewer' => 'PDF Document',
      'graph_plotter' => 'Graph Plot',
      'code_viewer' => 'Code Snippet',
      _ => 'Session',
    };
  }

  static String _matrixPreview(Map<String, dynamic> data) {
    final matrices = data['matrices'] as List<dynamic>? ?? [];
    if (matrices.isEmpty) return 'Empty workspace';
    return '${matrices.length} matrix${matrices.length != 1 ? 'ces' : ''}';
  }

  factory WorkspaceSession.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceSessionFromJson(json);
}
