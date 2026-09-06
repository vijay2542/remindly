import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/voice_state.dart';
import '../providers/voice_providers.dart';

class SpeechDialog extends ConsumerStatefulWidget {
  const SpeechDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const SpeechDialog(),
    );
  }

  @override
  ConsumerState<SpeechDialog> createState() => _SpeechDialogState();
}

class _SpeechDialogState extends ConsumerState<SpeechDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(voiceStateNotifierProvider.notifier).startListening();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final voiceState = ref.watch(voiceStateNotifierProvider);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Row(
        children: [
          Icon(
            Icons.mic,
            color: voiceState.status == VoiceStatus.listening
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          const Text('Voice Input'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (voiceState.status == VoiceStatus.listening) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Speak clearly into microphone...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (voiceState.status == VoiceStatus.permissionDenied) ...[
            Icon(Icons.mic_off, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(
              voiceState.errorMessage ?? 'Microphone permission denied.',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ],
          if (voiceState.status == VoiceStatus.error) ...[
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(
              voiceState.errorMessage ?? 'Recognition error occurred.',
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              voiceState.transcription.isNotEmpty
                  ? voiceState.transcription
                  : 'Listening for speech...',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: voiceState.transcription.isEmpty ? FontStyle.italic : FontStyle.normal,
              ),
              maxLines: 6,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(voiceStateNotifierProvider.notifier).reset();
            Navigator.of(context).pop(null);
          },
          child: const Text('Cancel'),
        ),
        if (voiceState.status == VoiceStatus.listening)
          FilledButton.icon(
            onPressed: () async {
              await ref.read(voiceStateNotifierProvider.notifier).stopListening();
            },
            icon: const Icon(Icons.stop),
            label: const Text('Stop Recording'),
          ),
        if (voiceState.status == VoiceStatus.success || voiceState.transcription.isNotEmpty)
          FilledButton.icon(
            onPressed: () {
              final text = voiceState.transcription;
              ref.read(voiceStateNotifierProvider.notifier).reset();
              Navigator.of(context).pop(text);
            },
            icon: const Icon(Icons.check),
            label: const Text('Use Recognized Text'),
          ),
      ],
    );
  }
}
