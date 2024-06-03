import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_emergency_response_app/theme_notifier.dart';
import 'package:provider/provider.dart';

import 'app_constants.dart';

class ChangeEmailPage extends StatefulWidget {
  @override
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  String? _currentUserEmail;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _fetch() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && mounted) {
      setState(() {
        _currentUserEmail = currentUser.email;
      });
    }
  }

  Future<void> _saveEmail() async {
    final newEmail = _emailController.text;
    if (newEmail.isEmpty) {
      _showMessage('Please enter a new email.');
      return;
    }

    final password = await _getPasswordFromUser();
    if (password != null) {
      try {
        await _reauthenticateUser(password);
        await sendEmailChangeRequest(newEmail);
        _showMessage('Your email has been updated successfully.');
        // Navigate back to settings
        Navigator.pop(context);
      } catch (error) {
        _showMessage('Failed to send email change request: $error');
      }
    } else {
      _showMessage('Password is required to change the email.');
    }
  }

  Future<String?> _getPasswordFromUser() async {
    final TextEditingController passwordController = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Re-authenticate'),
          content: TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Enter your password',
            ),
            obscureText: true,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop(passwordController.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _reauthenticateUser(String password) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final credential = EmailAuthProvider.credential(
        email: firebaseUser.email!,
        password: password,
      );
      await firebaseUser.reauthenticateWithCredential(credential);
    }
  }

  Future<void> sendEmailChangeRequest(String newEmail) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      try {
        await firebaseUser.verifyBeforeUpdateEmail(newEmail);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .update({
          'email': newEmail,
        });
      } catch (error) {
        throw error;
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
      backgroundColor: themeData.colorScheme.primary,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set your desired color here
        ),
        title: Text('Change Email',
            style: AppTextStyles.headline.copyWith(
              color: themeData
                  .colorScheme.onPrimary, // Use onPrimary color for text
              fontSize: 20, // Adjust the font size as needed
            )),
        backgroundColor: themeData.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Icon(
                  Icons.email,
                  color: themeData.colorScheme.onPrimary,
                  size: 75.0,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 10.0, // Optional: Adjust as needed
                      color: Colors.black
                          .withOpacity(0.5), // Optional: Adjust as needed
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    Text('Current Email:',
                        style: AppTextStyles.headline.copyWith(
                          color: themeData.colorScheme
                              .onPrimary, // Use onPrimary color for text
                          fontSize: 20, // Adjust the font size as needed
                        )),
                    Text(
                      _currentUserEmail ??
                          'Loading...', // Display current user's email
                      style: TextStyle(
                          fontSize: 16, color: themeData.colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text('New Email:',
                  style: AppTextStyles.headline.copyWith(
                    color: themeData
                        .colorScheme.onPrimary, // Use onPrimary color for text
                    fontSize: 20,
                  )),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Enter New Email',
                  labelStyle: TextStyle(color: themeData.colorScheme.onPrimary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: themeData.colorScheme
                          .onPrimary, // Set the color you want when the TextField is focused
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: themeData.colorScheme.onPrimary,
                      // Set the color you want when the TextField is enabled
                      width: 1.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryVariant,
                    shadowColor: Colors.black,
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: AppColors.secondary, width: 2.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Save',
                      style:
                          TextStyle(fontSize: 14, color: AppColors.secondary),
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
