import 'package:carejournal/services/settings_service.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  final SettingsService _settingsService = SettingsService();
  bool _isBiometricLockEnabled = false;

  bool get isBiometricLockEnabled => _isBiometricLockEnabled;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _isBiometricLockEnabled = await _settingsService.isBiometricLockEnabled();
    notifyListeners();
  }

  Future<void> setBiometricLockEnabled(bool isEnabled) async {
    await _settingsService.setBiometricLockEnabled(isEnabled);
    _isBiometricLockEnabled = isEnabled;
    notifyListeners();
  }
}