import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_constants.dart';
import 'change_email.dart';
import 'change_pw.dart';
import 'logout.dart';
import 'theme_notifier.dart';
import 'user_pref.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final themeData = themeNotifier.currentTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Settings', // Main title
              style: AppTextStyles.headline.copyWith(
                color: themeData
                    .colorScheme.onPrimary, // Use onPrimary color for text
                fontSize: 20, // Adjust the font size as needed
              ),
            ),
            Text(
              'Customize your preferences', // Subtitle-like text
              style: AppTextStyles.subheading.copyWith(
                color: themeData
                    .colorScheme.onPrimary, // Use onPrimary color for text
                fontSize: 14, // Adjust the font size as needed
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: themeData.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SettingsMenuItem(
              icon: Icons.person,
              text: 'Change Email',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangeEmailPage()),
                );
              },
            ),
            SettingsMenuItem(
              icon: Icons.lock,
              text: 'Change Password',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              },
            ),
            SettingsMenuItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm logout'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            logout(context); // Perform logout
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  SettingsMenuItem(
      {required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Access the theme data from the ThemeNotifier
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final themeData = themeNotifier.currentTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.white), // Use theme color
        title: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white, // Use theme color
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios,
            color: Colors.white), // Use theme color
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        tileColor: themeData.colorScheme.primary, // Use theme color
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      ),
    );
  }
}

void logout(BuildContext context) {
  AuthService.logout(context); // Call the logout method from AuthService
}
