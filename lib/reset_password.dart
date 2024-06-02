import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_emergency_response_app/reusables/form_constants.dart';
import 'app_constants.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a TextEditingController to manage the text in the text field
    final TextEditingController emailController = TextEditingController();
    final _auth = AuthService();

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start, // Center the content vertically
          children: [
            SizedBox(height: 10,),
            Icon(
              Icons.lock_reset, // Replace with the desired icon
              color: AppColors.primary,
              size: 75,
            ),
            const Text('Reset Password', style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 25),),
            const Text('Enter a valid email to receive reset password link'),
            const SizedBox(height: 20), // Add some space between the text and the text field
            TextField(
              controller: emailController, // Provide the text controller
              decoration: InputDecoration(
                hintText: 'Enter valid email', // 'Email' should be a string
                hintStyle: TextStyle(color: AppColors.tertiary), // Set an appropriate color
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black), // Set an appropriate color
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _auth.sendPasswordResetLink(emailController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('An email for password reset has been sent to your email.'),
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryVariant,
              ),
              child: Text('Send Email', style: TextStyle(color: AppColors.secondary),),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent to $email');
    } catch (e) {
      print('Failed to send password reset email: $e');
      rethrow; // rethrow to allow handling in the UI
    }
  }
}
