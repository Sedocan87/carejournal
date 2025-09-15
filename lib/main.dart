import 'package:carejournal/screens/auth_screen.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      title: 'CareJournal',
      theme: ThemeData(
        colorScheme: LegacyColorSchemes.darkBlue(),
        radius: 0.5,
      ),
      home: const AuthScreen(),
    );
  }
}
