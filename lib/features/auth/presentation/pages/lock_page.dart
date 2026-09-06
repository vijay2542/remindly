import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class LockPage extends ConsumerStatefulWidget {
  const LockPage({super.key});

  @override
  ConsumerState<LockPage> createState() => _LockPageState();
}

class _LockPageState extends ConsumerState<LockPage> {
  String _enteredPin = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerBiometricAuth();
    });
  }

  void _navigateHome() {
    if (!mounted) return;
    if (GoRouter.maybeOf(context) != null) {
      context.go('/');
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Future<void> _triggerBiometricAuth() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final success = await authNotifier.authenticateWithDevice();
    if (success) {
      _navigateHome();
    }
  }

  void _onKeyPress(String digit) {
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += digit;
      });

      if (_enteredPin.length == 4) {
        _verifyPin();
      }
    }
  }

  void _onDelete() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  void _verifyPin() {
    final success = ref.read(authNotifierProvider.notifier).authenticateWithPin(_enteredPin);
    if (success) {
      _navigateHome();
    } else {
      setState(() {
        _enteredPin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              // App Logo / Lock Badge
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.tertiary,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 42,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Remindly Locked',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Authenticate to access your private memories',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Android Device Auth Button (Fingerprint, Pattern, Mobile Password)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: authState.isAuthenticating ? null : _triggerBiometricAuth,
                  icon: const Icon(Icons.fingerprint, size: 28),
                  label: const Text(
                    'Fingerprint / Mobile Password',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),

              if (authState.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  authState.errorMessage!,
                  style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),

              // Or Enter Security PIN Header
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'OR ENTER PASSCODE',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.outline,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),

              // PIN Indicator Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isFilled = index < _enteredPin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHigh,
                      border: Border.all(
                        color: isFilled ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                        width: 2,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Keypad
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.6,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  if (index == 9) {
                    return TextButton(
                      onPressed: () {
                        setState(() {
                          _enteredPin = '';
                        });
                      },
                      child: const Text('CLEAR', style: TextStyle(fontWeight: FontWeight.bold)),
                    );
                  }
                  if (index == 10) {
                    return _buildKeypadButton('0');
                  }
                  if (index == 11) {
                    return IconButton(
                      icon: const Icon(Icons.backspace_outlined),
                      onPressed: _onDelete,
                    );
                  }
                  final number = (index + 1).toString();
                  return _buildKeypadButton(number);
                },
              ),
              const SizedBox(height: 12),
              Text(
                'Default PIN: 1234',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String number) {
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: () => _onKeyPress(number),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Text(
        number,
        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
