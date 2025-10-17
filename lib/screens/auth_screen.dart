import 'package:carejournal/services/database_service.dart';
import 'package:carejournal/services/settings_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:carejournal/screens/timeline_screen.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleAuth();
    });
  }

  Future<void> _handleAuth() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (settings.isBiometricLockEnabled) {
      await _authenticate();
    } else {
      _navigateToTimeline();
    }
  }

  void _navigateToTimeline() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const TimelineScreen()),
    );
  }

  Future<void> _authenticate() async {
    try {
      final bool authenticated = await _localAuthentication.authenticate(
        localizedReason: 'Please authenticate to access CareJournal',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (authenticated) {
        _navigateToTimeline();
      } else {
        _showPasswordDialog();
      }
    } catch (e) {
      _showPasswordDialog();
    }
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final passwordController = TextEditingController();
        return AlertDialog(
          title: const Text('Enter Password'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final password = await DatabaseService.instance.getDatabasePassword();
                if (passwordController.text == password) {
                  Navigator.of(context).pop();
                  _navigateToTimeline();
                }
              },
              child: const Text('Unlock'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
