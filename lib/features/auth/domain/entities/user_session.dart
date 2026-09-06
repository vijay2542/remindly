class AuthSession {
  final bool isLocked;
  final bool isBiometricAvailable;
  final bool isAuthenticating;
  final String? customPin;
  final String? errorMessage;

  const AuthSession({
    this.isLocked = true,
    this.isBiometricAvailable = true,
    this.isAuthenticating = false,
    this.customPin = '1234',
    this.errorMessage,
  });

  AuthSession copyWith({
    bool? isLocked,
    bool? isBiometricAvailable,
    bool? isAuthenticating,
    String? customPin,
    String? errorMessage,
  }) {
    return AuthSession(
      isLocked: isLocked ?? this.isLocked,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      customPin: customPin ?? this.customPin,
      errorMessage: errorMessage,
    );
  }
}
