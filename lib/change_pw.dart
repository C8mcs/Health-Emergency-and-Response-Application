import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

        // Update password in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .update({
          'password': newPassword,
        });

        print('Password updated successfully.');
        _showMessage('Password updated successfully.');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 70,),
              Text(
                'New Password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text(
                'You will be changing your password.\nType your new password on the text field below.\nBe Secure.',
              ),
              SizedBox(height: 30,),
              Container(
                color: Colors.grey[200],
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Enter your new password',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 20,),
              Text(
                'Old Password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(height: 10,),
              Container(
                color: Colors.grey[200],
                child: TextField(
                  controller: _oldPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Old Password',
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: 'Enter your old password',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_passwordController.text.length <= 5) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Password Too Short'),
                            content: Text('Your password must be at least 6 characters long.'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
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
                            title: Text('Confirm Save'),
                            content: Text('Are you sure you want to save this new password?'),
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
                    backgroundColor: Color(0xFFF24171),
                    shadowColor: Colors.black,
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.white, width: 2.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10.0, top: 5, bottom: 5),
                    child: Text(
                      'Save',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14, color: Colors.white),
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
