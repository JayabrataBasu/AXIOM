import 'package:uuid/uuid.dart';
import 'content_block.dart';

/// Predefined node templates for quick creation
class NodeTemplate {
  const NodeTemplate({
    required this.name,
    required this.description,
    required this.icon,
    required this.blocks,
  });

  final String name;
  final String description;
  final String icon;
  final List<ContentBlock> Function() blocks;

  /// Create blocks with proper IDs and timestamps
  List<ContentBlock> createBlocks(Uuid uuid, DateTime createdAt) {
    return blocks();
  }

  static final List<NodeTemplate> templates = [
    NodeTemplate(
      name: 'Blank',
      description: 'Empty node with single text block',
      icon: '📝',
      blocks: () => [
        TextBlock(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: '',
          createdAt: DateTime.now(),
        ),
      ],
    ),
    NodeTemplate(
      name: 'Meeting Notes',
      description: 'Structured note-taking for meetings',
      icon: '🤝',
      blocks: () => [
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-1',
          content: 'Meeting Notes',
          level: 1,
          createdAt: DateTime.now(),
        ),
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-2',
          content: 'Attendees',
          level: 2,
          createdAt: DateTime.now(),
        ),
        BulletListBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-3',
          items: [''],
          createdAt: DateTime.now(),
        ),
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-4',
          content: 'Key Points',
          level: 2,
          createdAt: DateTime.now(),
        ),
        BulletListBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-5',
          items: [''],
          createdAt: DateTime.now(),
        ),
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-6',
          content: 'Action Items',
          level: 2,
          createdAt: DateTime.now(),
        ),
        BulletListBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-7',
          items: [''],
          createdAt: DateTime.now(),
        ),
      ],
    ),
    NodeTemplate(
      name: 'Research Paper',
      description: 'Academic paper structure',
      icon: '📚',
      blocks: () => [
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-1',
          content: 'Title',
          level: 1,
          createdAt: DateTime.now(),
        ),
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-2',
          content: 'Abstract',
          level: 2,
          createdAt: DateTime.now(),
        ),
        TextBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-3',
          content: '',
          createdAt: DateTime.now(),
        ),
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-4',
          content: 'Introduction',
          level: 2,
          createdAt: DateTime.now(),
        ),
        TextBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-5',
          content: '',
          createdAt: DateTime.now(),
        ),
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-6',
          content: 'Methodology',
          level: 2,
          createdAt: DateTime.now(),
        ),
        TextBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-7',
          content: '',
          createdAt: DateTime.now(),
        ),
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-8',
          content: 'Results',
          level: 2,
          createdAt: DateTime.now(),
        ),
        TextBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-9',
          content: '',
          createdAt: DateTime.now(),
        ),
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-10',
          content: 'Conclusion',
          level: 2,
          createdAt: DateTime.now(),
        ),
        TextBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-11',
          content: '',
          createdAt: DateTime.now(),
        ),
      ],
    ),
    NodeTemplate(
      name: 'Project Plan',
      description: 'Project planning and tracking',
      icon: '🎯',
      blocks: () => [
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-1',
          content: 'Project Plan',
          level: 1,
          createdAt: DateTime.now(),
        ),
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-2',
          content: 'Goals',
          level: 2,
          createdAt: DateTime.now(),
        ),
        BulletListBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-3',
          items: [''],
          createdAt: DateTime.now(),
        ),
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-4',
          content: 'Milestones',
          level: 2,
          createdAt: DateTime.now(),
        ),
        BulletListBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-5',
          items: [''],
          createdAt: DateTime.now(),
        ),
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-6',
          content: 'Resources',
          level: 2,
          createdAt: DateTime.now(),
        ),
        BulletListBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-7',
          items: [''],
          createdAt: DateTime.now(),
        ),
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-8',
          content: 'Timeline',
          level: 2,
          createdAt: DateTime.now(),
        ),
        TextBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-9',
          content: '',
          createdAt: DateTime.now(),
        ),
      ],
    ),
    NodeTemplate(
      name: 'Code Snippet',
      description: 'Code with documentation',
      icon: '💻',
      blocks: () => [
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-1',
          content: 'Code Snippet',
          level: 2,
          createdAt: DateTime.now(),
        ),
        TextBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-2',
          content: 'Description:',
          createdAt: DateTime.now(),
        ),
        CodeBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-3',
          content: '// Your code here',
          language: 'dart',
          createdAt: DateTime.now(),
        ),
        HeadingBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-4',
          content: 'Notes',
          level: 3,
          createdAt: DateTime.now(),
        ),
        BulletListBlock(
          id: '${DateTime.now().millisecondsSinceEpoch}-5',
          items: [''],
          createdAt: DateTime.now(),
        ),
      ],
    ),
  ];
}
