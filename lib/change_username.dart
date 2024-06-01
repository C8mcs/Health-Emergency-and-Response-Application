import 'package:flutter/material.dart';

class ChangeUsernamePage extends StatefulWidget {
  @override
  _ChangeUsernamePageState createState() => _ChangeUsernamePageState();
}

class _ChangeUsernamePageState extends State<ChangeUsernamePage> {
  final TextEditingController _usernameController = TextEditingController();
  String _savedUsername = '';

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
              Text('New Username', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              Text('You will be changing your username.\nType your new username on the text field below.\n\n'),
              SizedBox(height: 30,),
              Container(
                color: Colors.grey[200], // Set the background color here
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'New Username',
                    labelStyle: TextStyle(color: Colors.grey), // Color of the label text
                    hintText: 'Enter your new username',
                    hintStyle: TextStyle(color: Colors.grey), // Color of the hint text
                    border: OutlineInputBorder( // Border around the text field
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _savedUsername = _usernameController.text;
                    });
                    print('Saved Username: $_savedUsername');
                    // Here you can add the logic to save the new username
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