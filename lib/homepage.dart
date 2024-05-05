import 'package:flutter/material.dart';
import 'package:health_emergency_response_app/welcome_page.dart';

import 'profile_page.dart';

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
      home: const Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedTabIndex = 0;
  final bool _registrationFilled = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: [
                const ProfilePage(), // Index 0
                //RegistrationPage(onRegistrationCompleted: _registrationCompleted), // Placeholder for Register Screen (Index 1)
              ],
            ),
          ),
          _registrationFilled
              ? ElevatedButton(
                  onPressed: () {
                    // Navigate to login page
                    _onTabSelected(0);
                  },
                  child: const Text('Login'),
                )
              : BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.login),
                      label: 'Profile',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_add),
                      label: 'Chat',
                    ),
                  ],
                  currentIndex: _selectedTabIndex,
                  onTap: _onTabSelected,
                  selectedItemColor: Colors.blue,
                ),
          // Container(
          //   height: 150,
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage(
          //           'assets/images/send_sos.gif'), // Replace 'background_image.png' with your image asset path
          //       fit: BoxFit
          //           .cover, // Adjust the fit of the image within the container
          //     ),
          //   ),
          //   child: Center(
          //     child: GestureDetector(
          //       onLongPress: () => _navigateToDifferentPage(context),
          //       child: Image.asset(
          //         'assets/images/logo.png',
          //         height: 500,
          //         width:
          //500, // Adjust the fit of the image within the container
          //        ),
          //     ),
          //    ),
          // ),
        ],
      ),
      // floatingActionButton: QuickActionMenu(
      //   onTap: () {
      //     // Implement action for the floating action button
      //   },
      //   icon: Icons.add,
      //   backgroundColor: Colors.red, // Customize background color
      //   child:
      //       Placeholder(), // Replace Placeholder() with your actual child widget
      //   actions: quickActions, // Pass the list of QuickAction objects
      // ),
    );
  }
}
