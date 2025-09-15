import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:carejournal/screens/timeline_screen.dart';

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
    _authenticate();
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: 'Please authenticate to access CareJournal',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } catch (e) {
      // Handle error
    }

    if (authenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TimelineScreen()),
      );
    } else {
      // Handle authentication failure
    }
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
