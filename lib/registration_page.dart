import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback? onRegistrationCompleted;

  const RegistrationPage({Key? key, this.onRegistrationCompleted}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _reenterPasswordController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();

  bool _registrationFilled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(offset: Offset(0, 50),
              child: Text(
                'Hello, I am',
                style: TextStyle(
                  fontSize: 45,
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              ),
              Transform.translate(
                offset: Offset(0, 10), // Adjust horizontal translation to minimize space
                child: Text(
                  'HERA',
                  style: TextStyle(
                    fontSize: 90,
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.grey,
                        blurRadius: 10.0,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, -20), // Adjust horizontal translation to minimize space
                child:Text(
                  'Bringing your safety into your\nfingertips',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  strutStyle: StrutStyle(
                    height: 1, // Set the line height to 1 to remove white spaces between lines
                  ),
                ),
              ),
              Transform.translate(offset: Offset(0, -30),
              child:
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red.shade700,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Enter your email/username',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      onChanged: (_) => _checkFormFilled(),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red.shade700,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      obscureText: true,
                      onChanged: (_) => _checkFormFilled(),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _reenterPasswordController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red.shade700,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Re-enter your Password',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      obscureText: true,
                      onChanged: (_) => _checkFormFilled(),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _contactNumberController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Colors.red.shade700,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Enter Contact Number',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      onChanged: (_) => _checkFormFilled(),
                    ),
                  ],
                ),
              ),
              ),
              Transform.translate(offset: Offset(0, -45),
                child: ElevatedButton(
                  onPressed: _registrationFilled ? _register : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(100, 50),
                    backgroundColor: _registrationFilled ? Colors.redAccent.shade200 : Colors.grey, // Change color based on _registrationFilled condition
                    shadowColor: Colors.black, // Set the shadow color and opacity
                    elevation: 10,
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white), // Set font color to white
                  ),
                ),),
              SizedBox(height: 10,)
            ],
          ),
        ),
    );
  }

  void _checkFormFilled() {
    setState(() {
      _registrationFilled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _reenterPasswordController.text.isNotEmpty &&
          _contactNumberController.text.isNotEmpty;
    });
  }

  void _register() {
    // Perform registration logic here
    print('Registered!');
    // Example: Validate inputs, make API calls, etc.

    // Call the callback if provided
    if (widget.onRegistrationCompleted != null) {
      widget.onRegistrationCompleted!();
    }
  }
}
