import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../voice/presentation/widgets/speech_dialog.dart';
import '../../domain/entities/diary_entry.dart';
import '../providers/diary_auth_provider.dart';
import '../providers/diary_providers.dart';
import '../widgets/diary_entry_card.dart';

class DiaryHomePage extends ConsumerWidget {
  const DiaryHomePage({super.key});

  Future<void> _triggerVoiceEntry(BuildContext context) async {
    final recognizedText = await SpeechDialog.show(context);
    if (recognizedText != null && recognizedText.isNotEmpty && context.mounted) {
      context.push('/diary/editor', extra: recognizedText);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(diaryAuthNotifierProvider);
    final entriesAsync = ref.watch(diaryEntriesStreamProvider);

    // Redirect to unlock screen if locked
    if (authState.isLocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go('/diary/unlock');
        }
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Dashboard',
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.teal),
            tooltip: 'Voice Command Entry',
            onPressed: () => _triggerVoiceEntry(context),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: 'Calendar View',
            onPressed: () => context.push('/diary/calendar'),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search Entries',
            onPressed: () => context.push('/diary/entries'),
          ),
          IconButton(
            icon: const Icon(Icons.lock_outline),
            tooltip: 'Lock Diary',
            onPressed: () {
              ref.read(diaryAuthNotifierProvider.notifier).lock();
              context.go('/diary/unlock');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Diary Settings',
            onPressed: () => context.push('/diary/settings'),
          ),
        ],
      ),
      body: entriesAsync.when(
        data: (entries) {
          DiaryEntry? todayEntry;
          final previousEntries = <DiaryEntry>[];

          for (final entry in entries) {
            final entryDay = DateTime(entry.diaryDate.year, entry.diaryDate.month, entry.diaryDate.day);
            if (entryDay.isAtSameMomentAs(todayDate) && todayEntry == null) {
              todayEntry = entry;
            } else {
              previousEntries.add(entry);
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month Header
                Text(
                  DateFormatter.formatDate(now).split(',').first, // e.g. September 2026
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 16),

                // Today's Diary Section
                Row(
                  children: [
                    Text(
                      'Today',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormatter.formatDate(now),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (todayEntry != null) ...[
                  DiaryEntryCard(
                    entry: todayEntry,
                    onTap: () => context.push('/diary/entry/${todayEntry!.id}'),
                    onDelete: () => _confirmDelete(context, ref, todayEntry!.id),
                  ),
                ] else ...[
                  Card(
                    elevation: 0,
                    color: theme.colorScheme.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_note, size: 44, color: Colors.teal.withValues(alpha: 0.8)),
                          const SizedBox(height: 8),
                          Text(
                            'No entry for today yet.',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Preserve your thoughts and memories of today.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () => context.push('/diary/editor'),
                              icon: const Icon(Icons.add),
                              label: const Text('+ Write Today\'s Diary', style: TextStyle(fontWeight: FontWeight.bold)),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // Previous Entries Section
                Row(
                  children: [
                    Text(
                      'Previous Entries',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (previousEntries.isNotEmpty)
                      TextButton(
                        onPressed: () => context.push('/diary/entries'),
                        child: const Text('See All'),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                if (previousEntries.isEmpty) ...[
                  Card(
                    elevation: 0,
                    color: theme.colorScheme.surfaceContainerLow,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          'No previous diary entries yet.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: previousEntries.length > 5 ? 5 : previousEntries.length,
                    itemBuilder: (context, index) {
                      final entry = previousEntries[index];
                      return DiaryEntryCard(
                        entry: entry,
                        onTap: () => context.push('/diary/entry/${entry.id}'),
                        onDelete: () => _confirmDelete(context, ref, entry.id),
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading diary: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/diary/editor'),
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Write Entry'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Diary Entry?'),
        content: const Text('This entry will be permanently deleted. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final deleteUseCase = ref.read(deleteDiaryEntryUseCaseProvider);
              await deleteUseCase(id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Diary entry deleted.')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
