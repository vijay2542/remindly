import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../memory/presentation/widgets/memory_card.dart';
import '../../domain/entities/ai_answer.dart';
import '../providers/search_providers.dart';

class AnswerCard extends ConsumerWidget {
  final AiAnswer answer;

  const AnswerCard({
    super.key,
    required this.answer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final searchState = ref.watch(searchNotifierProvider);
    final notifier = ref.read(searchNotifierProvider.notifier);

    return Card(
      elevation: 0,
      color: answer.isFound
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4)
          : theme.colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: answer.isFound
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  answer.isFound ? Icons.psychology : Icons.info_outline,
                  color: answer.isFound ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'Answer',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    searchState.isSpeaking ? Icons.stop_circle : Icons.volume_up_outlined,
                    color: searchState.isSpeaking ? theme.colorScheme.error : theme.colorScheme.primary,
                  ),
                  tooltip: searchState.isSpeaking ? 'Stop speaking' : 'Read answer aloud',
                  onPressed: () {
                    if (searchState.isSpeaking) {
                      notifier.stopSpeaking();
                    } else {
                      notifier.speakAnswerText(answer.answerText);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            SelectableText(
              answer.answerText,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),

            if (answer.isFound && answer.sourceMemories.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Sources:',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Column(
                children: answer.sourceMemories.map((mem) {
                  return MemoryCard(
                    memory: mem,
                    onTap: () => context.push('/memory/${mem.id}'),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
