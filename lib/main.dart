import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_emergency_response_app/homepage.dart';
import 'package:health_emergency_response_app/welcome_page.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HERA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomePage(), // Set the splash screen as the home route
    );
  }

  void _navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WelcomePage()),
    );
  }
}
