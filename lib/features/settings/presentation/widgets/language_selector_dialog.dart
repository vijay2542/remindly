import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_language.dart';
import '../../../../core/localization/language_provider.dart';

class LanguageSelectorDialog extends ConsumerWidget {
  const LanguageSelectorDialog({super.key});

  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => const LanguageSelectorDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);
    final l10n = ref.watch(localizationsProvider);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.language, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(child: Text(l10n.get('selectLanguage'))),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: AppLanguage.values.map((lang) {
          final isSelected = currentLanguage == lang;
          return ListTile(
            leading: Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? Colors.blue : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(
              '${lang.englishName} (${lang.nativeName})',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(lang.nativeName),
            trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
            onTap: () {
              ref.read(languageProvider.notifier).setLanguage(lang);
              Navigator.of(context).pop();
            },
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.get('cancel')),
        ),
      ],
    );
  }
}
