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
                                    ],
                                  ),
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
                                    ]
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
                                onPressed: () {

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {

                                      bool hasReadPolicy = false;
                                      return AlertDialog(
                                        title: Center(
                                          child: Text('Privacy Policy'),
                                        ),
                                        content: Scrollbar(
                                          child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Text(''
                                                      'This Privacy Policy will inform you about the types of personal data we collect, the purposes for which we use the data, the ways in which the data is handled and your rights with regard to your personal data.\n\n'
                                                      'For purposes of this Privacy Policy, "Your Information" or "Personal Data" means information about you, which may be of a confidential or sensitive nature and may include personally identifiable information ("PII") and/or financial information. PII means individually identifiable information that would allow us to determine the actual identity of a specific living person, while sensitive data may include information, comments, content and other information that you voluntarily provide.\n\n'
                                                      'HERA collects information about you when you use our Website to access our services, and other online products and services (collectively, the “Services”) and through other interactions and communications you have with us. The term Services includes, collectively, various applications, websites, widgets, email notifications and other mediums, or portions of such mediums, through which you have accessed this Privacy Policy.\n\n'
                                                      'We may change this Privacy Policy from time to time. If we decide to change this Privacy Policy, we will inform you by posting the revised Privacy Policy on the Site. Those changes will go into effect on the "Last updated" date shown at the end of this Privacy Policy. By continuing to use the Site or Services, you consent to the revised Privacy Policy. We encourage you to periodically review the Privacy Policy for the latest information on our privacy practices.\n\n'
                                                      'BY ACCESSING OR USING OUR SERVICES, YOU CONSENT TO THE COLLECTION, TRANSFER, MANIPULATION, STORAGE, DISCLOSURE AND OTHER USES OF YOUR INFORMATION (COLLECTIVELY, "USE OF YOUR INFORMATION") AS DESCRIBED IN THIS PRIVACY POLICY. IF YOU DO NOT AGREE WITH OR CONSENT TO THIS PRIVACY POLICY YOU MAY NOT ACCESS OR USE OUR SERVICES.',
                                                    textAlign: TextAlign.justify,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Checkbox(
                                                        value: hasReadPolicy,
                                                        onChanged: (bool? value) => setState(() => hasReadPolicy = value!),
                                                      ),
                                                      Text('I have read and understood the \nPrivacy Policy.'),
                                                    ],
                                                  ),
                                                ],
                                              )
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: hasReadPolicy ? () => setState(() { Navigator.pop(context); }) : null,
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
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
                              scale: 1.5,
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
