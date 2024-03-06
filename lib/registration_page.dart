import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrationPageScreen(),
    );
  }
}

class RegistrationPageScreen extends StatefulWidget {
  @override
  _RegistrationPageScreenState createState() => _RegistrationPageScreenState();
}

class _RegistrationPageScreenState extends State<RegistrationPageScreen> {

  void _navigateToLoginPageScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: Key('registration_page_scaffold'),
        body: MediaQuery(
          data: MediaQuery.of(context),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.75,
                    child: Column(
                      children: [
                        Column(
                          children: [
                           Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                            child : RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "Hello, I am",
                                style: TextStyle(color: Colors.red, fontSize: 50,
                                  shadows:[
                                    Shadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],),
                              ),
                            ),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "HERA",
                                style: TextStyle(color: Colors.red, fontSize: 100, fontWeight: FontWeight.w800,
                                    shadows:[
                                      Shadow(
                                    color: Colors.grey,
                                  blurRadius: 5.0,
                                  offset: Offset(2.0, 2.0),
                                ),
                                    ],
                              ),
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "Bringing an immediate response into your fingertips.",
                                style: TextStyle(color: Colors.black, fontSize: 15),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 5.0),
                            child :TextField(
                              decoration: const InputDecoration( hintText: 'Username', hintStyle: TextStyle(color: Colors.white),
                                contentPadding: EdgeInsets.all(0),
                                filled: true,
                                fillColor: Colors.red,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            ),
                            Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 5.0),
                             child : TextField(
                              decoration: const InputDecoration( hintText: 'Password', hintStyle: TextStyle(color: Colors.white),
                                contentPadding: EdgeInsets.all(0),
                                filled: true,
                                fillColor: Colors.red,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            ),
                            Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 5.0),
                            child : TextField(
                              decoration: const InputDecoration( hintText: 'Re-enter Password', hintStyle: TextStyle(color: Colors.white),
                                contentPadding: EdgeInsets.all(0),
                                filled: true,
                                fillColor: Colors.red,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            ),
                             Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 5.0),
                              child : TextField(
                              decoration: const InputDecoration( hintText: 'Emergency Contact', hintStyle: TextStyle(color: Colors.white),
                                contentPadding: EdgeInsets.all(0),
                                filled: true,
                                fillColor: Colors.red,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                ),
                            Padding(
                            padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 5.0),
                            child : ElevatedButton(
                              onPressed: _navigateToLoginPageScreen,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text('Register', style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children:[
                        Positioned.fill(child: Container(child: Container(), color: Colors.red),),
                        Positioned.fill(
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(40.0),
                                      bottomRight: Radius.circular(40.0),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                            ],
                          ),
                        ),
                       Center(
                          child: Container(
                            child: Transform.scale(
                              scale: 1.5, // Adjust the scale factor as needed
                              child: Image.asset(
                                'assets/images/logo.png',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
