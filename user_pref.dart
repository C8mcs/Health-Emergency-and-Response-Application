import 'package:flutter/material.dart';

class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  bool _darkMode = false;
  String _colorScheme = 'Blue';
  bool _voiceActivation = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SwitchListTile(
              title: Text('Dark Mode'),
              value: _darkMode,
              onChanged: (bool value) {
                setState(() {
                  _darkMode = value;
                });
              },
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
            SwitchListTile(
              title: Text('Voice Activation'),
              value: _voiceActivation,
              onChanged: (bool value) {
                setState(() {
                  _voiceActivation = value;
                });
              },
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
          ],
        ),
      ),
    );
  }
}
