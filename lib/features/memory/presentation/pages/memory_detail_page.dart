import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/memory.dart';
import '../providers/memory_providers.dart';
import '../widgets/category_chip.dart';

final memoryDetailFutureProvider =
    FutureProvider.family<Memory?, String>((ref, id) async {
  final repository = ref.watch(memoryRepositoryProvider);
  return repository.getMemoryById(id);
});

class MemoryDetailPage extends ConsumerWidget {
  final String id;
  const MemoryDetailPage({super.key, required this.id});

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Memory?'),
        content: const Text('Are you sure you want to delete this memory? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final deleteUseCase = ref.read(deleteMemoryUseCaseProvider);
              await deleteUseCase(id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Memory deleted.')),
                );
                context.pop();
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final memoryAsync = ref.watch(memoryDetailFutureProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete Memory',
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: memoryAsync.when(
        data: (memory) {
          if (memory == null) {
            return const Center(child: Text('Memory not found.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Memory Content Container
                Card(
                  elevation: 0,
                  color: theme.colorScheme.surfaceContainerHigh,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SelectableText(
                      memory.content,
                      style: theme.textTheme.titleMedium?.copyWith(
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Category & Source Type & Security
                Row(
                  children: [
                    CategoryChip(category: memory.category),
                    const SizedBox(width: 8),
                    Chip(
                      avatar: Icon(
                        memory.sourceType.name == 'voice' ? Icons.mic : Icons.short_text,
                        size: 16,
                      ),
                      label: Text('Source: ${memory.sourceType.label}'),
                      visualDensity: VisualDensity.compact,
                    ),
                    if (memory.isSecure) ...[
                      const SizedBox(width: 8),
                      Chip(
                        avatar: const Icon(
                          Icons.lock,
                          size: 16,
                          color: Colors.amber,
                        ),
                        label: const Text('Secure'),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // Tags
                if (memory.tags.isNotEmpty) ...[
                  Text('Tags', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outline)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: memory.tags.map((tag) {
                      return Chip(
                        label: Text('#$tag'),
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Dates & Details Card
                Card(
                  elevation: 0,
                  color: theme.colorScheme.surfaceContainerLow,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _detailRow(
                          context,
                          icon: Icons.calendar_today,
                          label: 'Created',
                          value: DateFormatter.formatDateTime(memory.createdAt),
                        ),
                        const Divider(height: 20),
                        _detailRow(
                          context,
                          icon: Icons.update,
                          label: 'Last Updated',
                          value: DateFormatter.formatDateTime(memory.updatedAt),
                        ),
                        if (memory.reminderDate != null) ...[
                          const Divider(height: 20),
                          _detailRow(
                            context,
                            icon: Icons.notifications_active,
                            label: 'Reminder Scheduled',
                            value: DateFormatter.formatDateTime(memory.reminderDate!),
                            color: theme.colorScheme.tertiary,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading memory: $err')),
      ),
    );
  }

  Widget _detailRow(BuildContext context,
      {required IconData icon, required String label, required String value, Color? color}) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const Spacer(),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
