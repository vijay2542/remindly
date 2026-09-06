import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../voice/presentation/widgets/speech_dialog.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/memory_source_type.dart';
import '../providers/memory_providers.dart';
import '../widgets/category_chip.dart';
import '../widgets/tag_input.dart';

class AddMemoryPage extends ConsumerStatefulWidget {
  final bool startVoice;
  const AddMemoryPage({super.key, this.startVoice = false});

  @override
  ConsumerState<AddMemoryPage> createState() => _AddMemoryPageState();
}

class _AddMemoryPageState extends ConsumerState<AddMemoryPage> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() {
      ref.read(addMemoryNotifierProvider.notifier).setContent(_contentController.text);
    });

    if (widget.startVoice) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerVoiceRecording();
      });
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _triggerVoiceRecording() async {
    final recognizedText = await SpeechDialog.show(context);
    if (recognizedText != null && recognizedText.isNotEmpty) {
      setState(() {
        _contentController.text = recognizedText;
      });
      ref.read(addMemoryNotifierProvider.notifier).setSourceType(MemorySourceType.voice);
    }
  }

  Future<void> _pickReminderDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        final reminderDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        ref.read(addMemoryNotifierProvider.notifier).setReminderDate(reminderDateTime);
      }
    }
  }

  void _onSave() async {
    final saved = await ref.read(addMemoryNotifierProvider.notifier).save();
    if (saved != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Memory saved successfully!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(addMemoryNotifierProvider);
    final notifier = ref.read(addMemoryNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Memory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic),
            tooltip: 'Record Speech',
            onPressed: _triggerVoiceRecording,
          ),
          TextButton.icon(
            onPressed: state.isSaving ? null : _onSave,
            icon: state.isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: theme.colorScheme.onErrorContainer),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: TextStyle(color: theme.colorScheme.onErrorContainer),
                      ),
                    ),
                  ],
                ),
              ),

            // Content text area with embedded Mic button action banner
            Stack(
              children: [
                TextField(
                  controller: _contentController,
                  maxLines: 5,
                  minLines: 3,
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'What would you like to remember?\ne.g. "The spare key is inside the blue cupboard."',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerLow,
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: IconButton.filledTonal(
                    icon: const Icon(Icons.mic),
                    tooltip: 'Tap to speak',
                    onPressed: _triggerVoiceRecording,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Category selector
            Text('Category', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: Category.values.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: CategoryChip(
                      category: cat,
                      isSelected: state.category == cat,
                      onTap: () => notifier.setCategory(cat),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Tags section
            Text('Tags', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TagInput(
              tags: state.tags,
              onTagAdded: notifier.addTag,
              onTagRemoved: notifier.removeTag,
            ),
            const SizedBox(height: 20),

            // Optional Reminder section
            Text('Reminder (Optional)', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Icon(
                  Icons.notifications_active_outlined,
                  color: state.reminderDate != null ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                ),
                title: Text(
                  state.reminderDate != null
                      ? DateFormatter.formatDateTime(state.reminderDate!)
                      : 'Set Reminder Date & Time',
                ),
                subtitle: state.reminderDate != null
                    ? const Text('Notification will be scheduled')
                    : const Text('Tap to choose notification date'),
                trailing: state.reminderDate != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => notifier.setReminderDate(null),
                      )
                    : IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _pickReminderDate,
                      ),
                onTap: _pickReminderDate,
              ),
            ),
            const SizedBox(height: 20),

            // Security Lock Option
            Text('Security & Privacy', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: state.isSecure
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : theme.colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: SwitchListTile(
                secondary: Icon(
                  state.isSecure ? Icons.lock : Icons.lock_open,
                  color: state.isSecure ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                ),
                title: const Text('Mark as Secure / Private 🔒', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Protects this memory & reminder requiring security unlock'),
                value: state.isSecure,
                onChanged: (val) => notifier.setSecure(val),
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: state.isSaving ? null : _onSave,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Confirm & Save Memory', style: TextStyle(fontSize: 16)),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
