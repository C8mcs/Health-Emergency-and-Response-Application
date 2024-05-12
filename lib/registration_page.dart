import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';

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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _reenterPasswordController = TextEditingController();
  final _contactNumberController = TextEditingController();
  bool _registrationFilled = false;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  late String firstName;
  late String lastName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, 50),
              child: Text(
                'Hello, I am',
                style: TextStyle(
                  fontSize: 45,
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(
                  0, 10), // Adjust horizontal translation to minimize space
              child: Text(
                'HERA',
                style: TextStyle(
                  fontSize: 90,
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(
                  0, -20), // Adjust horizontal translation to minimize space
              child: const Text(
                'Bringing your safety into your\nfingertips',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                strutStyle: StrutStyle(
                  height:
                      1, // Set the line height to 1 to remove white spaces between lines
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _firstNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red.shade700,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Enter your First Name',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      onChanged: (value) {
                        firstName = value;
                        _checkFormFilled();
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _lastNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red.shade700,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Enter your Last Name',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      onChanged: (value) {
                        lastName = value;
                        _checkFormFilled();
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red.shade700,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Enter your email/username',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      onChanged: (value) {
                        email = value;
                        _checkFormFilled();
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red.shade700,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Enter your password',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                        _checkFormFilled();
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _reenterPasswordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red.shade700,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Re-enter your Password',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      obscureText: true,
                      onChanged: (_) => _checkFormFilled(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _contactNumberController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red.shade700,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Enter Contact Number',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      onChanged: (_) => _checkFormFilled(),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -45),
              child: ElevatedButton(
                onPressed: _registrationFilled ? _register : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 50),
                  backgroundColor: _registrationFilled
                      ? Colors.redAccent.shade200
                      : Colors
                          .grey, // Change color based on _registrationFilled condition
                  shadowColor: Colors.black, // Set the shadow color and opacity
                  elevation: 10,
                ),
                child: const Text(
                  'Register',
                  style:
                      TextStyle(color: Colors.white), // Set font color to white
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            showSpinner
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  void _checkFormFilled() {
    setState(() {
      _registrationFilled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _reenterPasswordController.text.isNotEmpty &&
          _passwordController.text == _reenterPasswordController.text;
    });
  }

  Future<void> _register() async {
    setState(() {
      showSpinner = true;
    });
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (newUser != null) {
        final user = HeraUser(
          uid: newUser.user!.uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          contactNumber: _contactNumberController.text,
          dateCreated: DateTime.now().toIso8601String(),
        );
        final userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(newUser.user!.uid);
        await userRef.set(user.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration Successful!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );

        Navigator.popAndPushNamed(context, "/");
      }
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      if (e is FirebaseAuthException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(getErrorMessage(e.code)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      } else {
        print("Registration failed due to non-auth error: ${e.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }

    setState(() {
      showSpinner = false;
    });

    if (widget.onRegistrationCompleted != null) {
      widget.onRegistrationCompleted!();
    }
  }
}
