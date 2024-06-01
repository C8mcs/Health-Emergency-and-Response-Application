import 'package:flutter/material.dart';
import 'package:health_emergency_response_app/settings.dart';

void main() {
  runApp(const PreferencesScreen());
}

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: AppBar(
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),
              ),
              backgroundColor: const Color(0xFFFFE6E7E6),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 110.0,
                      top: 7.0,
                    ), // Padding for gray container
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 37,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFBD2D29),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 100.0, bottom: 9.0),
                    child: Text(
                      'Account and Preferences',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF666573),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SettingsPage(), // Correctly define the body property
        ),
      ),
    );
  }
}
