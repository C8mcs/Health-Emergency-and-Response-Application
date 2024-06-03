import 'package:flutter/material.dart';
import 'package:health_emergency_response_app/theme_notifier.dart';
import 'package:provider/provider.dart';

import 'constants/themes.dart';

class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  String _colorScheme = 'Blue';
  bool _voiceActivation = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final bool _darkMode = themeNotifier.currentTheme == AppThemes.darkTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Preferences',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Container(
              height: 0.5,
              width: 1000,
              color: Colors.black,
            ),
            SizedBox(
              height: 20,
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: _darkMode,
              onChanged: (bool value) {
                setState(() {
                  themeNotifier.switchTheme();
                });
              },
            ),
            Container(
              height: 0.2,
              width: 1000,
              color: Colors.black.withOpacity(0.5),
            ),
            ListTile(
              title: Text('Color Scheme'),
              trailing: DropdownButton<String>(
                value: _colorScheme,
                onChanged: (String? newValue) {
                  setState(() {
                    _colorScheme = newValue!;
                  });
                },
                items: <String>['Blue', 'Green', 'Red', 'Purple']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Container(
              height: 0.2,
              width: 1000,
              color: Colors.black.withOpacity(0.5),
            ),
            SwitchListTile(
              title: Text('Voice Activation'),
              value: _voiceActivation,
              onChanged: (bool value) {
                setState(() {
                  _voiceActivation = value;
                });
              },
            ),
            Container(
              height: 0.2,
              width: 1000,
              color: Colors.black.withOpacity(0.5),
            ),
            ListTile(
              title: Text('Language'),
              trailing: DropdownButton<String>(
                value: _language,
                onChanged: (String? newValue) {
                  setState(() {
                    _language = newValue!;
                  });
                },
                items: <String>['English', 'Spanish', 'French', 'German']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Container(
              height: 0.2,
              width: 1000,
              color: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
