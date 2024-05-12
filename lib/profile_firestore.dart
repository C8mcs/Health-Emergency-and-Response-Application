import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void saveProfileToFirestore({
  required TextEditingController userHeight,
  required TextEditingController userWeight,
  required TextEditingController firstName,
  required TextEditingController lastName,
  required TextEditingController userAddress,
  required TextEditingController userAge,
  required TextEditingController userBloodType,
  required TextEditingController userMedicalCond,
  required TextEditingController userSex,
  required TextEditingController emergencyContactName,
  required TextEditingController emergencyContactAddress,
  required TextEditingController emergencyContactNumber,
  required BuildContext context, // Add BuildContext parameter
}) async {
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  if (uid != null) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference profiles = firestore.collection('profile');

    await profiles.doc(uid).set({
      'height': userHeight.text,
      'weight': userWeight.text,
      'firstName': firstName.text,
      'lastName': lastName.text,
      'userAddress': userAddress.text,
      'userAge': userAge.text,
      'userBloodType': userBloodType.text,
      'userMedicalCond': userMedicalCond.text,
      'userSex': userSex.text,
      'emergencyContactName': emergencyContactName.text,
      'emergencyContactAddress': emergencyContactAddress.text,
      'emergencyContactNumber': emergencyContactNumber.text,
      // Add other fields similarly
    });
  } else {
    // Handle case where user is not authenticated
    // For example, you can display a snackbar message or navigate to login/signup screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('User is not authenticated. Please login to save profile.'),
        duration: Duration(seconds: 3),
      ),
    );

    // Navigate to login/signup screen
    Navigator.pushNamed(
        context, '/login'); // Replace '/login' with your actual login route
  }
}
