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
  final TextEditingController _oldPasswordController = TextEditingController();
  String _savedPassword = '';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _oldPasswordController.dispose();
    super.dispose();
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
      } catch (e) {
        print('Error updating password: $e');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final themeData = themeNotifier.currentTheme;

    return Scaffold(
      backgroundColor: themeData.colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.primary,
        title: Text(
          'Change Password',
          style: AppTextStyles.headline.copyWith(
            color:
                themeData.colorScheme.onPrimary, // Use onPrimary color for text
            fontSize: 20,
          ),
        ), // Use theme app bar color
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
                style: themeData.textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              const Text(
                'You will be changing your password.\nType your new password on the text field below.\nBe Secure.',
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                color: Colors.grey[200], // Set the background color here
                child: TextField(
                  controller:
                      _passwordController, // Use the controller to get the entered password
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: TextStyle(
                        color: Colors.grey), // Color of the label text
                    hintText: 'Enter your new password',
                    hintStyle:
                        TextStyle(color: Colors.grey), // Color of the hint text
                    border: OutlineInputBorder(
                      // Border around the text field
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
                    if (_passwordController.text.length <= 5) {
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
                                  _savePassword(); // Save the new password
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
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
