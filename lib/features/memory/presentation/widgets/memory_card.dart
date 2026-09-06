import 'package:flutter/material.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/memory.dart';
import '../../domain/entities/memory_source_type.dart';
import 'category_chip.dart';

class MemoryCard extends StatelessWidget {
  final Memory memory;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const MemoryCard({
    super.key,
    required this.memory,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      memory.content,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (memory.sourceType == MemorySourceType.voice)
                    Tooltip(
                      message: 'Recorded via Voice',
                      child: Icon(
                        Icons.mic_none,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CategoryChip(category: memory.category),
                  const SizedBox(width: 8),
                  Text(
                    DateFormatter.formatRelative(memory.createdAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  if (memory.reminderDate != null)
                    Icon(
                      Icons.notifications_active_outlined,
                      size: 16,
                      color: theme.colorScheme.tertiary,
                    ),
                ],
              ),
              if (memory.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: memory.tags.map((tag) {
                    return Text(
                      '#$tag',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
