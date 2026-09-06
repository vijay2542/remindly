import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../voice/presentation/widgets/speech_dialog.dart';
import '../../domain/entities/diary_entry.dart';
import '../providers/diary_providers.dart';

class DiaryEditorPage extends ConsumerStatefulWidget {
  final String? entryId;
  final String? initialText;
  const DiaryEditorPage({super.key, this.entryId, this.initialText});

  @override
  ConsumerState<DiaryEditorPage> createState() => _DiaryEditorPageState();
}

class _DiaryEditorPageState extends ConsumerState<DiaryEditorPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime _diaryDate = DateTime.now();
  bool _isLoading = false;
  bool _isSaving = false;
  DiaryEntry? _existingEntry;

  @override
  void initState() {
    super.initState();
    if (widget.initialText != null && widget.initialText!.isNotEmpty) {
      _contentController.text = widget.initialText!;
    }
    if (widget.entryId != null && widget.entryId!.isNotEmpty) {
      _loadExistingEntry();
    }
  }

  Future<void> _loadExistingEntry() async {
    setState(() => _isLoading = true);
    final getUseCase = ref.read(getDiaryEntryUseCaseProvider);
    final entry = await getUseCase(widget.entryId!);
    if (entry != null && mounted) {
      setState(() {
        _existingEntry = entry;
        _titleController.text = entry.title;
        if (_contentController.text.isEmpty) {
          _contentController.text = entry.content;
        }
        _diaryDate = entry.diaryDate;
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _triggerVoiceRecording() async {
    final recognizedText = await SpeechDialog.show(context);
    if (recognizedText != null && recognizedText.isNotEmpty) {
      setState(() {
        if (_contentController.text.trim().isEmpty) {
          _contentController.text = recognizedText;
        } else {
          _contentController.text = '${_contentController.text}\n$recognizedText';
        }
      });
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _diaryDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (date != null) {
      setState(() {
        _diaryDate = DateTime(date.year, date.month, date.day);
      });
    }
  }

  Future<void> _onSave() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write your diary thoughts before saving.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final title = _titleController.text.trim();

      if (_existingEntry != null) {
        final updated = _existingEntry!.copyWith(
          title: title,
          content: content,
          diaryDate: _diaryDate,
          updatedAt: now,
        );
        final updateUseCase = ref.read(updateDiaryEntryUseCaseProvider);
        await updateUseCase(updated);
      } else {
        final newEntry = DiaryEntry(
          id: now.millisecondsSinceEpoch.toString(),
          title: title,
          content: content,
          diaryDate: _diaryDate,
          createdAt: now,
          updatedAt: now,
        );
        final createUseCase = ref.read(createDiaryEntryUseCaseProvider);
        await createUseCase(newEntry);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Diary entry saved!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save diary entry.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_existingEntry != null ? 'Edit Entry' : 'Write Diary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.teal),
            tooltip: 'Voice Command / Dictation',
            onPressed: _triggerVoiceRecording,
          ),
          TextButton.icon(
            onPressed: _isSaving ? null : _onSave,
            icon: _isSaving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check),
            label: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Selector Chip
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_month, size: 18, color: Colors.teal),
                    const SizedBox(width: 8),
                    Text(
                      DateFormatter.formatDate(_diaryDate),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down, color: Colors.teal),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title Field
            TextField(
              controller: _titleController,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'Title (e.g. "Good Day")',
                border: InputBorder.none,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Content Editor Field
            TextField(
              controller: _contentController,
              maxLines: 18,
              minLines: 10,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
              decoration: const InputDecoration(
                hintText: 'Write freely or tap microphone for voice dictation...',
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _triggerVoiceRecording,
        icon: const Icon(Icons.mic),
        label: const Text('Voice Entry'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }
}
