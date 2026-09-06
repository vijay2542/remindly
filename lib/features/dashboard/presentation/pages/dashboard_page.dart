import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../about/presentation/pages/about_page.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../settings/presentation/widgets/language_selector_dialog.dart';
import '../widgets/module_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = ref.watch(localizationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.get('appName'),
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: l10n.get('languageSetting'),
            onPressed: () => LanguageSelectorDialog.show(context),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.tertiaryContainer.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.grid_view_rounded,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Personal Life Management',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your central workspace to organize memories, reminders, and daily journals.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Modules',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 1. Remindly Module Card
              ModuleCard(
                title: 'Remindly',
                description: 'Remember anything. Find it when you need it.',
                icon: Icons.psychology,
                iconColor: theme.colorScheme.primary,
                badgeText: 'Personal Memory Assistant',
                onTap: () => context.push('/remindly'),
              ),

              // 2. Diary Module Card
              ModuleCard(
                title: 'Diary',
                description: 'Your private space for everyday thoughts and memories.',
                icon: Icons.auto_stories,
                iconColor: Colors.teal,
                badgeText: 'Private Daily Journal',
                onTap: () => context.push('/diary'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
