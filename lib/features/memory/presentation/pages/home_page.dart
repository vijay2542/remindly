import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../about/presentation/pages/about_page.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/memory_providers.dart';
import '../widgets/memory_card.dart';

import '../../../../core/localization/language_provider.dart';
import '../../../settings/presentation/widgets/language_selector_dialog.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recentMemoriesAsync = ref.watch(recentMemoriesProvider);
    final l10n = ref.watch(localizationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Remindly', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: l10n.get('languageSetting'),
            onPressed: () => LanguageSelectorDialog.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            tooltip: 'Voice Search',
            onPressed: () => context.push('/search?voice=true'),
          ),
          IconButton(
            icon: const Icon(Icons.lock_outline),
            tooltip: 'Lock App',
            onPressed: () {
              ref.read(authNotifierProvider.notifier).lockApp();
              context.go('/lock');
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: l10n.get('aboutTab'),
            onPressed: () => showAppAboutDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.refresh(recentMemoriesProvider),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ask Anything Search Bar Banner
                GestureDetector(
                  onTap: () => context.push('/search'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: theme.colorScheme.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 12),
                        Text(
                          l10n.get('searchHint'),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(Icons.mic, color: theme.colorScheme.primary),
                          onPressed: () => context.push('/search?voice=true'),
                          tooltip: 'Voice command search',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Remember Something Action CTA
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: () => context.push('/add'),
                    icon: const Icon(Icons.add_comment_outlined),
                    label: Text(
                      l10n.get('addMemoryTitle'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Recent Memories Section Header
                Row(
                  children: [
                    Text(
                      l10n.get('memoriesTab'),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.search_outlined),
                      onPressed: () => context.push('/search'),
                      tooltip: 'Search all memories',
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Recent Memories List
                recentMemoriesAsync.when(
                  data: (memories) {
                    if (memories.isEmpty) {
                      return _buildEmptyState(context, ref);
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: memories.length,
                      itemBuilder: (context, index) {
                        final memory = memories[index];
                        return MemoryCard(
                          memory: memory,
                          onTap: () => context.push('/memory/${memory.id}'),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stack) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Error loading memories: $error'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = ref.watch(localizationsProvider);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(Icons.psychology_outlined, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              l10n.get('noMemories'),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "Remember something" or use the microphone to save keys, dates, items, or notes.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
