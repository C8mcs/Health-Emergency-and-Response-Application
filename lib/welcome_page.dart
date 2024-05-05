import 'package:flutter/material.dart';
import 'package:health_emergency_response_app/homepage.dart';

import 'login_page.dart';
import 'registration_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _selectedTabIndex = 0;
  bool _registrationFilled = false;

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _navigateToDifferentPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DifferentPage()),
    );
  }

  void _registrationCompleted() {
    setState(() {
      _registrationFilled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: [
                LoginPage(), // Index 0
                RegistrationPage(
                    onRegistrationCompleted:
                        _registrationCompleted), // Placeholder for Register Screen (Index 1)
              ],
            ),
          ),
          _registrationFilled
              ? ElevatedButton(
                  onPressed: () {
                    // Navigate to login page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Homepage()),
                    );
                  },
                  child: const Text('Login'),
                )
              : BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.login),
                      label: 'Login',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_add),
                      label: 'Register',
                    ),
                  ],
                  currentIndex: _selectedTabIndex,
                  onTap: _onTabSelected,
                  selectedItemColor: Colors.blue,
                ),
          Container(
            height: 150,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/send_sos.gif'), // Replace 'background_image.png' with your image asset path
                fit: BoxFit
                    .cover, // Adjust the fit of the image within the container
              ),
            ),
            child: Center(
              child: GestureDetector(
                onLongPress: () => _navigateToDifferentPage(context),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 500,
                  width:
                      500, // Adjust the fit of the image within the container
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DifferentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Different Page'),
      ),
      body: const Center(
        child: Text(
          'This is a different page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
