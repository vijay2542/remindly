import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/diary_auth_provider.dart';

class DiarySettingsPage extends ConsumerStatefulWidget {
  const DiarySettingsPage({super.key});

  @override
  ConsumerState<DiarySettingsPage> createState() => _DiarySettingsPageState();
}

class _DiarySettingsPageState extends ConsumerState<DiarySettingsPage> {
  int _selectedTimeout = 0; // 0 = Immediately

  @override
  void initState() {
    super.initState();
    _loadTimeout();
  }

  Future<void> _loadTimeout() async {
    final authService = ref.read(diaryAuthServiceProvider);
    final mins = await authService.getLockTimeout();
    if (mounted) {
      setState(() => _selectedTimeout = mins);
    }
  }

  Future<void> _updateTimeout(int mins) async {
    final authService = ref.read(diaryAuthServiceProvider);
    await authService.setLockTimeout(mins);
    if (mounted) {
      setState(() => _selectedTimeout = mins);
    }
  }

  void _confirmResetPin() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Diary Protection?'),
        content: const Text(
          'Resetting your PIN will remove password protection from your Diary.\n\n'
          'Important: If you forget your PIN in the future, resetting protection ensures your diary entries remain accessible on your device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(diaryAuthNotifierProvider.notifier).resetAuth();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Diary PIN reset successfully.')),
                );
                context.go('/diary');
              }
            },
            child: const Text('Reset PIN'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(diaryAuthNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Security Section
          Text('Diary Security', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.teal)),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_reset, color: Colors.teal),
                  title: Text(authState.hasPin ? 'Reset / Change Diary PIN' : 'Create Diary PIN'),
                  subtitle: Text(authState.hasPin ? 'PIN protection is active' : 'No PIN set'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    if (authState.hasPin) {
                      _confirmResetPin();
                    } else {
                      context.push('/diary/unlock');
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.fingerprint, color: Colors.teal),
                  title: const Text('Biometric Unlock'),
                  subtitle: const Text('Use Fingerprint or Face ID when opening Diary'),
                  trailing: const Icon(Icons.check_circle_outline, color: Colors.teal),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Lock Timeout Section
          Text('Lock Timeout', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.teal)),
          const SizedBox(height: 8),
          RadioGroup<int>(
            groupValue: _selectedTimeout,
            onChanged: (val) {
              if (val != null) _updateTimeout(val);
            },
            child: Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Radio<int>(value: 0),
                    title: const Text('Immediately'),
                    subtitle: const Text('Lock Diary as soon as app is closed'),
                    onTap: () => _updateTimeout(0),
                  ),
                  ListTile(
                    leading: const Radio<int>(value: 1),
                    title: const Text('After 1 Minute'),
                    onTap: () => _updateTimeout(1),
                  ),
                  ListTile(
                    leading: const Radio<int>(value: 5),
                    title: const Text('After 5 Minutes'),
                    onTap: () => _updateTimeout(5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Cloud Backup Section
          Text('Cloud Backup', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.teal)),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.cloud_queue, color: Colors.grey),
              title: const Text('Cloud Backup & Sync'),
              subtitle: const Text('Encrypt and back up diary entries to cloud storage'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Coming soon',
                  style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
