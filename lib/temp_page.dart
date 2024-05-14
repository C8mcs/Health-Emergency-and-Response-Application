import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'models/signal.dart';

class TempPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to profile page (replace with your actual navigation logic)
                Navigator.pushNamed(context, 'profile_screen');
              },
              child: Text('Profile'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to preferences page (replace with your actual navigation logic)
                Navigator.pushNamed(context, 'preferences_screen'); // Replace with your preference screen route name
              },
              child: Text('Preferences'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try{
                  final user = FirebaseAuth.instance.currentUser;
                  final distressSignal = Signal(
                    emergencyType: 'Fire',
                    dateCreated: DateTime.now().toIso8601String(),
                  );
                  final signalRef = FirebaseFirestore.instance.collection('helpSignals').doc(user!.uid);
                  await signalRef.set(distressSignal.toMap());
                  Navigator.pushNamed(context, 'sos_screen'); // Replace with your preference screen route name
                }
                catch (e){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('SOS Signal failed.'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 5),
                    ),
                  );
                }

              },
              child: Text('SOS'),
            ),
          ],
        ),
      ),
    );
  }
}
