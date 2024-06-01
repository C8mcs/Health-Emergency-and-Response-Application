import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_emergency_response_app/app_constants.dart';

import 'login_page.dart';
import 'models/user.dart';
import 'reusables/form_constants.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback? onRegistrationCompleted;

  const RegistrationPage({Key? key, this.onRegistrationCompleted})
      : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

String getErrorMessage(String code) {
  switch (code) {
    case 'weak-password':
      return 'The password is too weak.';
    case 'email-already-in-use':
      return 'The email address is already in use by another account.';
    case 'invalid-email':
      return 'The email address is invalid.';
    default:
      return 'Registration failed due to an unknown error.';
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reenterPasswordController =
      TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  bool _registrationFilled = false;
  bool _showSpinner = false;
  String _emailError = '';
  String _contactNumError = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomTextField(
                      controller: _firstNameController,
                      hintText: 'First Name',
                      obscureText: false,
                      hintTextColor: AppColors.tertiary,
                      textFieldColor: AppColors.secondary,
                      textColor: AppColors.tertiaryVariant,
                      onChanged: (_) => _checkFormFilled(),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _lastNameController,
                      obscureText: false,
                      hintText: 'Enter Last Name',
                      hintTextColor: AppColors.tertiary,
                      textColor: AppColors.tertiaryVariant,
                      textFieldColor: AppColors.secondary,
                      onChanged: (_) => _checkFormFilled(),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Enter email',
                      obscureText: false,
                      hintTextColor: AppColors.tertiary,
                      textColor: AppColors.tertiaryVariant,
                      textFieldColor: AppColors.secondary,
                      onChanged: (_) => _checkFormFilled(),
                    ),
                    if (_emailError.isNotEmpty)
                      Text(
                        _emailError,
                        style: const TextStyle(color: Colors.yellow),
                      ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Enter Password',
                      obscureText: true,
                      hintTextColor: AppColors.tertiary,
                      textColor: AppColors.tertiaryVariant,
                      textFieldColor: AppColors.secondary,
                      onChanged: (_) => _checkFormFilled(),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _reenterPasswordController,
                      hintText: 'Re-enter your password',
                      obscureText: true,
                      hintTextColor: AppColors.tertiary,
                      textColor: AppColors.tertiaryVariant,
                      textFieldColor: AppColors.secondary,
                      onChanged: (_) => _checkFormFilled(),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _contactNumberController,
                      hintText: 'Enter Contact Number',
                      obscureText: false,
                      hintTextColor: AppColors.tertiary,
                      textColor: AppColors.tertiaryVariant,
                      textFieldColor: AppColors.secondary,
                      onChanged: (_) => _checkFormFilled(),
                    ),
                    if (_contactNumError.isNotEmpty)
                      Text(
                        _contactNumError,
                        style: const TextStyle(color: Colors.yellow),
                      ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'Login here.',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _registrationFilled ? _register : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 50),
                        backgroundColor: _registrationFilled
                            ? Colors.redAccent.shade200
                            : Colors.grey,
                        shadowColor: Colors.black,
                        elevation: 10,
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _showSpinner
                        ? const CircularProgressIndicator()
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _checkFormFilled() {
    setState(() {
      bool isContactNumberValid =
          RegExp(r'^09[0-9]{9}$').hasMatch(_contactNumberController.text);
      _registrationFilled = _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _emailController.text
              .endsWith('@gmail.com') && // Check if email ends with @gmail.com
          _passwordController.text.isNotEmpty &&
          _reenterPasswordController.text.isNotEmpty &&
          _contactNumberController.text.isNotEmpty &&
          _passwordController.text == _reenterPasswordController.text;
      _emailError = _emailController.text.isNotEmpty &&
              !_emailController.text.endsWith('@gmail.com')
          ? 'Email must end with @gmail.com'
          : '';
      _contactNumError =
          _contactNumberController.text.isNotEmpty && !isContactNumberValid
              ? 'Contact number must start with 09 and be exactly 11 digits'
              : '';
    });
  }

  Future<void> _register() async {
    setState(() {
      _showSpinner = true;
    });

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        final user = HeraUser(
          uid: userCredential.user!.uid,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          contactNumber: _contactNumberController.text,
          dateCreated: DateTime.now().toIso8601String(),
        );

        final userRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userRef.set(user.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration Successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );

        if (widget.onRegistrationCompleted != null) {
          widget.onRegistrationCompleted!();
        }

        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _showSpinner = false;
      });

      if (e is FirebaseAuthException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(getErrorMessage(e.code)),
            backgroundColor: AppColors.secondary,
            duration: const Duration(seconds: 5),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }
}
