import 'package:carejournal/services/database_service.dart';
import 'package:carejournal/services/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsProvider _settingsProvider;
  bool _isPasswordSet = false;

  @override
  void initState() {
    super.initState();
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _checkPasswordStatus();
  }

  Future<void> _checkPasswordStatus() async {
    final isPasswordSet = await DatabaseService.instance.isPasswordSet();
    if (mounted) {
      setState(() {
        _isPasswordSet = isPasswordSet;
      });
    }
  }

  void _showPasswordRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Password Required'),
        content: const Text(
            'You must set a password for the app before enabling the biometric lock.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Enable Biometric Lock'),
                subtitle: const Text(
                    'Secure the app with your face or fingerprint.'),
                value: settings.isBiometricLockEnabled,
                onChanged: (bool value) {
                  if (value && !_isPasswordSet) {
                    _showPasswordRequiredDialog();
                  } else {
                    settings.setBiometricLockEnabled(value);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}