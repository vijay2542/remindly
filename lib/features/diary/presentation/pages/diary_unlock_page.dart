import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/diary_auth_provider.dart';

class DiaryUnlockPage extends ConsumerStatefulWidget {
  const DiaryUnlockPage({super.key});

  @override
  ConsumerState<DiaryUnlockPage> createState() => _DiaryUnlockPageState();
}

class _DiaryUnlockPageState extends ConsumerState<DiaryUnlockPage> {
  final List<String> _enteredPin = [];
  final List<String> _confirmPin = [];
  bool _isConfirming = false;
  String _pinSetupFirst = '';
  String? _errorMessage;

  void _onKeyPress(String digit) {
    if (digit == 'CLEAR') {
      setState(() {
        if (_isConfirming) {
          if (_confirmPin.isNotEmpty) _confirmPin.removeLast();
        } else {
          if (_enteredPin.isNotEmpty) _enteredPin.removeLast();
        }
        _errorMessage = null;
      });
      return;
    }

    final activePin = _isConfirming ? _confirmPin : _enteredPin;
    if (activePin.length < 4) {
      setState(() {
        activePin.add(digit);
        _errorMessage = null;
      });
    }

    if (activePin.length == 4) {
      _handleCompletePin();
    }
  }

  void _handleCompletePin() async {
    final authState = ref.read(diaryAuthNotifierProvider);
    final notifier = ref.read(diaryAuthNotifierProvider.notifier);

    if (!authState.hasPin) {
      // Setup Mode
      if (!_isConfirming) {
        _pinSetupFirst = _enteredPin.join();
        setState(() {
          _isConfirming = true;
        });
      } else {
        final secondPin = _confirmPin.join();
        if (_pinSetupFirst == secondPin) {
          final created = await notifier.createPin(secondPin);
          if (created && mounted) {
            context.go('/diary');
          }
        } else {
          setState(() {
            _confirmPin.clear();
            _enteredPin.clear();
            _isConfirming = false;
            _pinSetupFirst = '';
            _errorMessage = 'PINs do not match. Start again.';
          });
        }
      }
    } else {
      // Unlock Mode
      final pin = _enteredPin.join();
      final success = await notifier.unlockWithPin(pin);
      if (success && mounted) {
        context.go('/diary');
      } else {
        setState(() {
          _enteredPin.clear();
          _errorMessage = 'Incorrect PIN code.';
        });
      }
    }
  }

  void _tryBiometricUnlock() async {
    final notifier = ref.read(diaryAuthNotifierProvider.notifier);
    final success = await notifier.unlockWithBiometrics();
    if (success && mounted) {
      context.go('/diary');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(diaryAuthNotifierProvider);

    String titleText = 'Enter Diary PIN';
    String subtitleText = 'Protect your private daily journal';

    if (!authState.hasPin) {
      if (!_isConfirming) {
        titleText = 'Protect Your Diary';
        subtitleText = 'Create a 4-digit PIN for your journal';
      } else {
        titleText = 'Confirm Diary PIN';
        subtitleText = 'Re-enter your 4-digit PIN to confirm';
      }
    }

    final activePin = _isConfirming ? _confirmPin : _enteredPin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Security'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_stories,
                  size: 40,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                titleText,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitleText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // PIN Indicator Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isFilled = index < activePin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled ? Colors.teal : theme.colorScheme.outlineVariant,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              if (_errorMessage != null || authState.error != null)
                Text(
                  _errorMessage ?? authState.error!,
                  style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

              const Spacer(),

              // Custom Numeric Keypad
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  if (index == 9) {
                    if (authState.hasPin) {
                      return IconButton(
                        icon: const Icon(Icons.fingerprint, size: 32, color: Colors.teal),
                        onPressed: _tryBiometricUnlock,
                      );
                    }
                    return const SizedBox.shrink();
                  }

                  if (index == 11) {
                    return IconButton(
                      icon: const Icon(Icons.backspace_outlined),
                      onPressed: () => _onKeyPress('CLEAR'),
                    );
                  }

                  final digit = index == 10 ? '0' : '${index + 1}';
                  return OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(color: theme.colorScheme.outlineVariant),
                    ),
                    onPressed: () => _onKeyPress(digit),
                    child: Text(
                      digit,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
