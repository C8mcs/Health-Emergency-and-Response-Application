import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
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
                Navigator.pushNamed(context, 'profile_screen');
              },
              child: Text('Profile'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'preferences_screen');
              },
              child: Text('Preferences'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try{
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    Location location = new Location();
                    LocationData locationData = await location.getLocation();
                    GeoPoint victimLocation = GeoPoint(
                        locationData.latitude ?? 0.0,
                        locationData.longitude ?? 0.0);
                    Signal helpSignal = Signal(emergencyType: "SOS",
                        dateCreated: DateTime.now().toString(),
                        victimLocation: victimLocation);

                    await FirebaseFirestore.instance
                        .collection('distressCalls')
                        .doc(user?.uid)
                        .set(helpSignal.toMap());
                    Navigator.pushNamed(context,
                        'sos_screen');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please log in to send SOS Signal.'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
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
