import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  String _savedPassword = '';

  @override
  void initState(){
    super.initState();
    _fetch();
  }

  _fetch() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null){
      try {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        if (userData.exists){
          setState(() {
            _passwordController.text = userData['password'];
          });
        }
      }
      catch (e){
        print('Error fetching user data: $e');
    }
    }
  }

  Future<void> _savePassword() async{
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null){
      try{
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .update({
         'password': _passwordController.text,
        });
        print('Password updated successfully.');
      } catch(e){

    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: Text('Change Username'),
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
                color: Colors.grey[200], // Set the background color here
                child: TextField(
                  controller: _passwordController, // Use the controller to get the entered password
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: TextStyle(color: Colors.grey), // Color of the label text
                    hintText: 'Enter your new password',
                    hintStyle: TextStyle(color: Colors.grey), // Color of the hint text
                    border: OutlineInputBorder( // Border around the text field
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
                    // Check if the length of the entered password is less than or equal to 5
                    if (_passwordController.text.length <= 5) {
                      // Show an alert dialog to inform the user that the password is too short
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Password Too Short'),
                            content: Text('Your password must be at least 6 characters long.'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // Show an alert dialog before saving the new password
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Save'),
                            content: Text('Are you sure you want to save this new password?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _savedPassword = _passwordController.text;
                                  });
                                  print('Saved Password: $_savedPassword');
                                  // Here you can add the logic to save the new password
                                  Navigator.of(context).pop(); // Close the dialog
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
                    padding: EdgeInsets.only(
                        left: 10, right: 10.0, top: 5, bottom: 5),
                    child: Text(
                      'Save',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14, color: Colors.white,
                      ),
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
