import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_emergency_response_app/homepage.dart';
import 'package:health_emergency_response_app/splash_video_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models/user.dart';
import 'theme_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'HERA',
          theme: themeNotifier.currentTheme,
          home:
              const AuthCheck(), // Directly set the login page as the home route
          routes: {
            '/splash': (context) => const SplashVideoScreen(),
            '/user': (context) => const HomePage(),
            '/profile': (context) => const ProfilePage(),
            '/map': (context) => const MapScreen(),
            '/settings': (context) => const SettingsPage(),
            '/changeEmail': (context) => const ChangeEmailPage(),
            '/changePassword': (context) => ChangePasswordPage(),
            '/preferences': (context) => PreferencesPage(),
          },
        );
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            final uid = snapshot.data!.uid;
            return FutureBuilder<DocumentSnapshot>(
              future:
                  FirebaseFirestore.instance.collection('users').doc(uid).get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (userSnapshot.hasData && userSnapshot.data != null) {
                    final user = HeraUser.fromMap(
                        userSnapshot.data!.data() as Map<String, dynamic>);
                    // Load preferences after creating the user
                    user.loadPreferences();
                    return const HomePage();
                  } else {
                    return const SplashVideoScreen();
                  }
                }
              },
            );
          } else {
            return const SplashVideoScreen();
          }
        }
      },
    );
  }
}
