import 'package:flutter/material.dart';

void main() {
  runApp(const PreferencesScreen());
}

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: AppBar(
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),
              ),
              backgroundColor: Color(0xFFFFE6E7E6),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 110.0, top: 7.0), // Padding for gray container
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 37,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFBD2D29),
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
                        color: Color(0xFFFF666573),
                      ),
                    ),
                  ),
                ],
              ),

              // Burger
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
            ),
          ),
          body: Container(
            color: Color(0xFFFFD92B4B), // Background color of the body
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      ChatSettings(),
                      ProfileSettings(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.grey[200],
            child: TabBar(
              tabs: [
                Tab(text: 'Chat'),
                Tab(text: 'Profile'),
              ],
              indicatorColor: Color(0xFFBD2D29),
              labelColor: Color(0xFFBD2D29),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatSettings extends StatelessWidget {
  const ChatSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Chat Settings',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  String? _selectedPermission;
  String? _selectedPreference;

  @override
  Widget build(BuildContext context) {
    return ListView(
      // padding: EdgeInsets.all(10.0),
      children: [
        _buildSections([
          "Permissions",
          "Account",
          "Preferences",
        ], [
          [
            Row(
              children: [
                Flexible(
                  child: RadioListTile<String>(
                    title: Text(
                      'Notifications',
                      style: TextStyle(fontSize: 15),
                    ),
                    value: 'Notification',
                    groupValue: _selectedPermission,
                    onChanged: (value) {
                      setState(() {
                        _selectedPermission = value;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: RadioListTile<String>(
                    title: Text(
                      'Location',
                      style: TextStyle(fontSize: 15),
                    ),
                    value: 'Location',
                    groupValue: _selectedPermission,
                    onChanged: (value) {
                      setState(() {
                        _selectedPermission = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
          [
            Row(
              children: [
                Flexible(
                  child: RadioListTile<String>(
                    title: Text(
                      'Verify Email',
                      style: TextStyle(fontSize: 15),
                    ),
                    value: 'Verify Email',
                    groupValue: _selectedPermission,
                    onChanged: (value) {
                      setState(() {
                        _selectedPermission = value;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: RadioListTile<String>(
                    title: Text(
                      'Change Username',
                      style: TextStyle(fontSize: 15),
                    ),
                    value: 'Change Username',
                    groupValue: _selectedPermission,
                    onChanged: (value) {
                      setState(() {
                        _selectedPermission = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: RadioListTile<String>(
                    title: Text(
                      'Change Password',
                      style: TextStyle(fontSize: 15),
                    ),
                    value: 'Change Password',
                    groupValue: _selectedPermission,
                    onChanged: (value) {
                      setState(() {
                        _selectedPermission = value;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: RadioListTile<String>(
                    title: Text(
                      'Emergency Contact',
                      style: TextStyle(fontSize: 15),
                    ),
                    value: 'Emergency Contact',
                    groupValue: _selectedPreference,
                    onChanged: (value) {
                      setState(() {
                        _selectedPreference = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
          [
            Row(
              children: [
                Flexible(
                  child: RadioListTile<String>(
                    title: Text(
                      'Dark Mode',
                      style: TextStyle(fontSize: 15),
                    ),
                    value: 'Dark Mode',
                    groupValue: _selectedPreference,
                    onChanged: (value) {
                      setState(() {
                        _selectedPreference = value;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: RadioListTile<String>(
                    title: Text(
                      'Language',
                      style: TextStyle(fontSize: 15),
                    ),
                    value: 'Language',
                    groupValue: _selectedPreference,
                    onChanged: (value) {
                      setState(() {
                        _selectedPreference = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: RadioListTile<String>(
                    title: Text(
                      'Color Scheme',
                      style: TextStyle(fontSize: 15),
                    ),
                    value: 'Color Scheme',
                    groupValue: _selectedPreference,
                    onChanged: (value) {
                      setState(() {
                        _selectedPreference = value;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: RadioListTile<String>(
                    title: Text(
                      'Voice Activation',
                      style: TextStyle(fontSize: 15),
                    ),
                    value: 'Voice Activation',
                    groupValue: _selectedPreference,
                    onChanged: (value) {
                      setState(() {
                        _selectedPreference = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ]),
      ],
    );
  }

  Widget _buildSections(List<String> titles, List<List<Widget>> children) {
    return Column(
      children: List.generate(
        titles.length,
            (index) => Container(
          // margin: EdgeInsets.symmetric(vertical: 0),
          // padding: EdgeInsets.all(1.0),
          color: Color(0xFFFFD9D9D9), // Gray container color
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titles[index],
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 1.0),
              ...children[index],
            ],
          ),
        ),
      ),
    );
  }
}