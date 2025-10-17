import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsService {
  final _secureStorage = const FlutterSecureStorage();

  static const _biometricLockKey = 'biometric_lock_enabled';

  Future<bool> isBiometricLockEnabled() async {
    final value = await _secureStorage.read(key: _biometricLockKey);
    return value == 'true';
  }

  Future<void> setBiometricLockEnabled(bool isEnabled) async {
    await _secureStorage.write(
      key: _biometricLockKey,
      value: isEnabled.toString(),
    );
  }
}