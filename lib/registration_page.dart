import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'models/user.dart';
import 'profile_page.dart';


class RegistrationPage extends StatefulWidget {
  final VoidCallback? onRegistrationCompleted;

  const RegistrationPage({Key? key, this.onRegistrationCompleted}) : super(key: key);

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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _reenterPasswordController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  bool _registrationFilled = false;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(offset: Offset(0, 50),
              child: Text(
                'Hello, I am',
                style: TextStyle(
                  fontSize: 45,
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                  shadows: [
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
              offset: Offset(0, 10), // Adjust horizontal translation to minimize space
              child: Text(
                'HERA',
                style: TextStyle(
                  fontSize: 90,
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                  shadows: [
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
              offset: Offset(0, -20), // Adjust horizontal translation to minimize space
              child:Text(
                'Bringing your safety into your\nfingertips',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                strutStyle: StrutStyle(
                  height: 1, // Set the line height to 1 to remove white spaces between lines
                ),
              ),
            ),
            Transform.translate(offset: Offset(0, -30),
              child:
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red.shade700,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Enter your email/username',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      onChanged: (value) {
                        email = value;
                        _checkFormFilled();
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red.shade700,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                        _checkFormFilled();
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _reenterPasswordController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red.shade700,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Re-enter your Password',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      obscureText: true,
                      onChanged: (_) => _checkFormFilled(),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _contactNumberController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red.shade700,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Enter Contact Number',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      onChanged: (_) => _checkFormFilled(),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(offset: Offset(0, -45),
              child: ElevatedButton(
                onPressed: _registrationFilled ? _register : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(100, 50),
                  backgroundColor: _registrationFilled ? Colors.redAccent.shade200 : Colors.grey, // Change color based on _registrationFilled condition
                  shadowColor: Colors.black, // Set the shadow color and opacity
                  elevation: 10,
                ),
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white), // Set font color to white
                ),
              ),),
            SizedBox(height: 10,),
            showSpinner
                ? Center(child: CircularProgressIndicator())
                : SizedBox(),
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
          email: email,
          contactNumber: _contactNumberController.text,
          dateCreated: DateTime.now().toIso8601String(),
        );
        final userRef = FirebaseFirestore.instance.collection('users').doc(newUser.user!.uid);
        await userRef.set(user.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
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
            duration: Duration(seconds: 5),
          ),
        );
      } else {
        print("Registration failed due to non-auth error: ${e.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
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
