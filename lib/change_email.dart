import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangeEmailPage extends StatefulWidget {
  @override
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  String _savedEmail = '';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  _fetch() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      try {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        if (userData.exists) {
          setState(() {
            _emailController.text = userData['info']['email']; // Corrected accessing email field
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> _saveEmail() async {
    final newEmail = _emailController.text;
    try {
      await updateUserEmail(newEmail); // Update email in both FirebaseAuth and Firestore
      setState(() {
        _savedEmail = newEmail; // Update saved email state
      });
      print('Email updated successfully');
    } catch (error) {
      print('Failed to update user email: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: Text('Change Email'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 70),
              Text(
                'New Email',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text(
                'You will be changing your email.\nType your new email address on the text field below.\n\n',
              ),
              SizedBox(height: 30),
              Container(
                color: Colors.grey[200],
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'New Email',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Enter your new email',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF24171),
                    shadowColor: Colors.black,
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.white, width: 2.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> updateUserEmail(String newEmail) async {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser != null) {
    try {
      // Ensure firebaseUser.email is not null before passing it to EmailAuthProvider.credential
      final currentEmail = firebaseUser.email!;

      // Reauthenticate the user to ensure recent authentication
      await firebaseUser.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: currentEmail,
          password: 'user_password', // Provide user's password here
        ),
      );

      // If reauthentication is successful, update email
      await firebaseUser.updateEmail(newEmail);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .update({
        'info.email': newEmail,
      });
    } catch (error) {
      throw error;
    }
  }
}

