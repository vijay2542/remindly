import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SecureStorageService {
  Future<bool> hasDiaryPin();
  Future<void> saveDiaryPinHash(String pin);
  Future<bool> verifyDiaryPin(String pin);
  Future<void> resetDiaryPin();
  Future<int> getLockTimeoutMinutes();
  Future<void> setLockTimeoutMinutes(int minutes);
}

class SecureStorageServiceImpl implements SecureStorageService {
  static const String _keyPinHash = 'diary_pin_hash_v1';
  static const String _keyPinSalt = 'diary_pin_salt_v1';
  static const String _keyLockTimeout = 'diary_lock_timeout_mins';

  final SharedPreferences? _prefsInstance;

  SecureStorageServiceImpl([this._prefsInstance]);

  Future<SharedPreferences> _getPrefs() async {
    return _prefsInstance ?? await SharedPreferences.getInstance();
  }

  String _hashPin(String pin, String salt) {
    final bytes = utf8.encode('$salt:$pin:$salt');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<bool> hasDiaryPin() async {
    final prefs = await _getPrefs();
    final hash = prefs.getString(_keyPinHash);
    return hash != null && hash.isNotEmpty;
  }

  @override
  Future<void> saveDiaryPinHash(String pin) async {
    final prefs = await _getPrefs();
    final salt = DateTime.now().microsecondsSinceEpoch.toString();
    final hash = _hashPin(pin, salt);
    await prefs.setString(_keyPinSalt, salt);
    await prefs.setString(_keyPinHash, hash);
  }

  @override
  Future<bool> verifyDiaryPin(String pin) async {
    final prefs = await _getPrefs();
    final storedHash = prefs.getString(_keyPinHash);
    final storedSalt = prefs.getString(_keyPinSalt);
    if (storedHash == null || storedSalt == null) {
      return false;
    }
    final calculatedHash = _hashPin(pin, storedSalt);
    return storedHash == calculatedHash;
  }

  @override
  Future<void> resetDiaryPin() async {
    final prefs = await _getPrefs();
    await prefs.remove(_keyPinHash);
    await prefs.remove(_keyPinSalt);
  }

  @override
  Future<int> getLockTimeoutMinutes() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_keyLockTimeout) ?? 0; // 0 = Immediately
  }

  @override
  Future<void> setLockTimeoutMinutes(int minutes) async {
    final prefs = await _getPrefs();
    await prefs.setInt(_keyLockTimeout, minutes);
  }
}
