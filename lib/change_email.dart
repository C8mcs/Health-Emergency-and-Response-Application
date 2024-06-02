import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_constants.dart';
import 'theme_notifier.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

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
        _showMessage(
            'Email change request sent. Check your email for the verification link.');
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
      backgroundColor:
          themeData.colorScheme.secondary, // Use theme background color
      appBar: AppBar(
        title: Text(
          'Change Email',
          style: AppTextStyles.headline.copyWith(
            color:
                themeData.colorScheme.onPrimary, // Use onPrimary color for text
            fontSize: 20,
          ),
        ),
        backgroundColor:
            themeData.colorScheme.primary, // Use theme app bar color
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
                'Current Email:',
                style: themeData.textTheme.bodyMedium, // Use theme text style
              ),
              Text(
                _currentUserEmail ??
                    'Loading...', // Display current user's email
                style: themeData.textTheme.bodyMedium, // Use theme text style
              ),
              SizedBox(height: 30),
              Text(
                'New Email:',
                style: themeData.textTheme.bodyMedium, // Use theme text style
              ),
              SizedBox(height: 10),
              Container(
                color: themeData.cardColor, // Use theme card color
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Enter New Email',
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
                    foregroundColor: themeData.colorScheme.primaryContainer,
                    backgroundColor: themeData.colorScheme
                        .primaryContainer, // Use theme onPrimary color
                    shadowColor: Colors.black,
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Use theme onSurface color
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Save',
                      style: AppTextStyles.headline.copyWith(
                        color: themeData.colorScheme
                            .onPrimary, // Use onPrimary color for text
                        fontSize: 15,
                        // Use theme button text style
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
