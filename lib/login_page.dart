import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app_constants.dart';
import 'reusables/form_constants.dart';
import 'reusables/logo.dart';
import 'temp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  bool _formFilled = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double middleOfScreen = screenHeight / 2;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isKeyboard)
                  Container(
                    height: middleOfScreen,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Hello, I am ',
                                style: AppTextStyles.subheading.copyWith(
                                  fontSize:
                                      AppTextStyles.subheading.fontSize! * 0.8,
                                ),
                              ),
                              TextSpan(
                                text: 'HERA',
                                style: AppTextStyles.headline.copyWith(
                                  fontSize: AppTextStyles.headline.fontSize! *
                                      0.8, // Adjust the scale factor as needed
                                ),
                              )
                            ],
                          ),
                        ),
                        const Flexible(
                            child: Logo(
                          width: 400,
                          height: 400,
                        )),
                        const SizedBox(height: 10),
                        Text(
                          'Bringing your safety into your\nfingertips',
                          style: AppTextStyles.bodyText2,
                          textAlign: TextAlign.center,
                          strutStyle: const StrutStyle(
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Welcome Back!', style: AppTextStyles.subheading2),
                        CustomTextField(
                          controller: _usernameController,
                          hintText: 'Username',
                          hintTextColor: AppColors.tertiary,
                          textFieldColor: AppColors.secondary,
                          textColor: AppColors.tertiaryVariant,
                          obscureText: false,
                          onChanged: (value) {
                            email = value;
                            _checkFormFilled();
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                          hintTextColor: AppColors.tertiary,
                          textFieldColor: AppColors.secondary,
                          textColor: AppColors.tertiaryVariant,
                          obscureText: true,
                          onChanged: (value) {
                            password = value;
                            _checkFormFilled();
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _formFilled ? _login : null,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 50),
                            backgroundColor: _formFilled
                                ? AppColors.primaryVariant
                                : AppColors.tertiary,
                          ),
                          child: const Text('Login',
                              style: TextStyle(color: AppColors.secondary)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TempPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Invalid credentials.';
          break;
        default:
          message = 'An error occurred. Please try again.';
          break;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
