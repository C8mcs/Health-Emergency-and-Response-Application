import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _formFilled = false;

  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red.shade700,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Enter your username',
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
                    
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _formFilled ? _login : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 50),
                backgroundColor: _formFilled
                    ? Colors.redAccent.shade200
                    : Colors
                        .grey, // Change color based on _formFilled condition
              ),
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _checkFormFilled() {
    setState(() {
      _formFilled = _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  Future<void> _login() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential != null) {
        // Successful Login - Navigate to profile page
        Navigator.pushReplacementNamed(context,
            '/'); // Replace 'profile_screen' with your actual route name
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Invalid credentials.';
      } else {
        message =
            'An error occurred. Please try again.'; // Generic message for other errors
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2), // Adjust duration as needed
        ),
      );
    } finally {}
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
