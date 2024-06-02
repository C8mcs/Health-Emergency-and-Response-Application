import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_constants.dart';
import 'theme_notifier.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  String _savedPassword = '';

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
            _passwordController.text = userData['password'];
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> _savePassword() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .update({
          'password': _passwordController.text,
        });
        print('Password updated successfully.');
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final themeData = themeNotifier.currentTheme;

    return Scaffold(
      backgroundColor: themeData.colorScheme.secondary,
      appBar: AppBar(
        title: Text(
          'Change Username',
          style: AppTextStyles.headline.copyWith(
              color: themeData
                  .colorScheme.onPrimary, // Use onPrimary color for text
              fontSize: 20),
        ),
        backgroundColor: themeData.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 70,
              ),
              Text(
                'New Password',
                style: AppTextStyles.headline.copyWith(
                  color: themeData
                      .colorScheme.onPrimary, // Use onPrimary color for text
                  fontSize: 20,
                ),
              ),
              const Text(
                'You will be changing your password.\nType your new password on the text field below.\nBe Secure.',
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                color: themeData.cardColor, // Set the background color here
                child: TextField(
                  controller:
                      _passwordController, // Use the controller to get the entered password
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Check if the length of the entered password is less than or equal to 5
                    if (_passwordController.text.length <= 5) {
                      // Show an alert dialog to inform the user that the password is too short
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Password Too Short'),
                            content: const Text(
                                'Your password must be at least 6 characters long.'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // Show an alert dialog before saving the new password
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Save'),
                            content: const Text(
                                'Are you sure you want to save this new password?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _savedPassword = _passwordController.text;
                                  });
                                  print('Saved Password: $_savedPassword');
                                  // Here you can add the logic to save the new password
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF24171),
                    shadowColor: Colors.black,
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: Colors.white, width: 2.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        left: 10, right: 10.0, top: 5, bottom: 5),
                    child: Text(
                      'Save',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
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
