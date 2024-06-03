import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_emergency_response_app/theme_notifier.dart';
import 'package:provider/provider.dart';

import 'app_constants.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reenterPasswordController =
      TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  String _passwordError = '';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _reenterPasswordController.dispose();
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
            // Assuming the password was fetched, but it's generally not stored like this
            // _passwordController.text = userData['password']; // Not secure
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
        // Check if old password matches
        final oldPassword = _oldPasswordController.text;
        final credential = EmailAuthProvider.credential(
          email: firebaseUser.email!,
          password: oldPassword,
        );
        await firebaseUser.reauthenticateWithCredential(credential);

        // Update password in Firebase Authentication
        final newPassword = _passwordController.text;
        await firebaseUser.updatePassword(newPassword);

        // Optionally, update the password in Firestore if required
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .update({
          'password': newPassword,
        });
        Navigator.pop(context);
        print('Password updated successfully.');
        _showMessage('Password updated successfully.');
        _passwordController.clear();
        _reenterPasswordController.clear();
        _oldPasswordController.clear();
      } catch (e) {
        print('Error updating password: $e');
        _showMessage('Error updating password: $e');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _validatePassword(String password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  void _checkFormFilled() {
    setState(() {
      bool isPasswordValid = _validatePassword(_passwordController.text);
      bool doPasswordsMatch =
          _passwordController.text == _reenterPasswordController.text;

      if (!isPasswordValid) {
        _passwordError =
            'Password must contain uppercase, lowercase, \nat least 1 digit, and 1 special character';
      } else if (!doPasswordsMatch) {
        _passwordError = 'Passwords do not match';
      } else {
        _passwordError = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final themeData = themeNotifier.currentTheme;

  TextStyle errorTextStyle = TextStyle(
      color: Colors.white, // Set the desired color here
    );
    
    return Scaffold(
      backgroundColor: themeData.colorScheme.primary,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set your desired color here
        ),
        title: Text('Change Password',
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
                  Icons.shield_moon_sharp,
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
              SizedBox(
                height: 10,
              ),
              Center(
                child: Column(
                  children: [
                    Text('New Password',
                        style: AppTextStyles.headline.copyWith(
                          color: themeData.colorScheme
                              .onPrimary, // Use onPrimary color for text
                          fontSize: 20, // Adjust the font size as needed
                        )),
                    Text(
                      'You will be changing your password.',
                      style: TextStyle(
                          fontSize: 16, color: themeData.colorScheme.onPrimary),
                    ),
                    Text(
                      'Type your new password on the text field below.',
                      style: TextStyle(
                          fontSize: 16, color: themeData.colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
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
                  errorText: _passwordError.isNotEmpty ? _passwordError : null,
                ),
                obscureText: true,
                onChanged: (_) => _checkFormFilled(),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _reenterPasswordController,
                decoration: InputDecoration(
                  labelText: 'Re-enter New Password',
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
                  hintText: 'Re-enter your new password',
                  hintStyle: TextStyle(color: themeData.colorScheme.onPrimary),
                  errorText: _passwordError.isNotEmpty ? _passwordError : null,
                ),
                obscureText: true,
                onChanged: (_) => _checkFormFilled(),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Old Password',
                  style: AppTextStyles.headline.copyWith(
                    color: themeData
                        .colorScheme.onPrimary, // Use onPrimary color for text
                    fontSize: 20,
                  )),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _oldPasswordController,
                decoration: InputDecoration(
                  labelText: 'Old Password',
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
                  hintText: 'Enter your old password',
                  hintStyle: TextStyle(color: themeData.colorScheme.onPrimary),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_passwordController.text.isEmpty ||
                        _reenterPasswordController.text.isEmpty ||
                        _oldPasswordController.text.isEmpty) {
                      _showMessage('Please fill all the fields.');
                    } else if (_passwordError.isNotEmpty) {
                      _showMessage(_passwordError);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Save'),
                            content: Text(
                                'Are you sure you want to save this new password?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _savePassword(); // Save the new password
                                  Navigator.of(context).pop();
                                },
                                child: Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
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
                    padding: EdgeInsets.only(
                        left: 10, right: 10.0, top: 5, bottom: 5),
                    child: Text(
                      'Save',
                      textAlign: TextAlign.left,
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
