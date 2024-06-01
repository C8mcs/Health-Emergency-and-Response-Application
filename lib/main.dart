import 'models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_emergency_response_app/homepage.dart';
import 'package:health_emergency_response_app/splash_video_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      home: AuthCheck(), // Directly set the login page as the home route
      routes: {
        '/splash': (context) => SplashVideoScreen(),
        '/user': (context) => HomePage(),
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        else {
          if (snapshot.hasData) {
            final uid = snapshot.data!.uid;
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                else {
                  if (userSnapshot.hasData && userSnapshot.data != null) {
                    final user = HeraUser.fromMap(userSnapshot.data!.data() as Map<String, dynamic>);
                    return HomePage();
                  }
                  else {
                    return SplashVideoScreen();
                  }
                }
              },
            );
          }

          else {
            return SplashVideoScreen();
          }
        }
      },
    );
  }
}
