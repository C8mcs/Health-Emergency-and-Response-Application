import 'package:flutter/material.dart';
import 'package:health_emergency_response_app/login_page.dart';
import 'user_pref.dart';
import 'change_pw.dart';
import 'change_username.dart';
import 'logout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangeUsernamePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFFF24171),
                shadowColor: Colors.black,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Color(0xFFF24171), width: 2.0),
                ),
              ),
              child: Text(
                'Change Username',
                style: TextStyle(fontSize: 24),
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFFF24171),
                shadowColor: Colors.black,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Color(0xFFF24171), width: 2.0),
                ),
              ),
              child: Text(
                'Change Password',
                style: TextStyle(fontSize: 24),
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PreferencesPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFFF24171),
                shadowColor: Colors.black,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Color(0xFFF24171), width: 2.0),
                ),
              ),
              child: Text(
                'Preferences',
                style: TextStyle(fontSize: 24),
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // Ask user for confirmation to logout
                    return AlertDialog(
                      title: Text('Confirm logout'),
                      content: Text('Are you sure you want to log out?'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFFFF),
                          ),
                          child: Text('Cancel', style: TextStyle(color: Colors.white),),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            logout(context);  // go back to login page
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFBD2D29),
                          ),
                          child: Text('Logout', style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF24171),
                foregroundColor: Colors.white,
                shadowColor: Colors.black,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.white, width: 2.0),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void logout(BuildContext context) {
  AuthService.logout(context); // Call the logout method from AuthService
}
