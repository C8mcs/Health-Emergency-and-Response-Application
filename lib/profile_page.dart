import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // User Profile variables
  TextEditingController userHeight = TextEditingController();
  TextEditingController userWeight = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController userAge = TextEditingController();
  TextEditingController userSex = TextEditingController();
  TextEditingController userBloodType = TextEditingController();
  TextEditingController userAddress = TextEditingController();
  TextEditingController emergencyContactName = TextEditingController();
  TextEditingController emergencyContactNumber = TextEditingController();
  TextEditingController emergencyContactAddress = TextEditingController();
  TextEditingController userMedicalCond = TextEditingController();
  TextEditingController userAllergies = TextEditingController();
  TextEditingController userMedications = TextEditingController();

  // Initial visibility of additional information
  bool additionalInfoVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD92B4B),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          width: 100,
          height: 100,
          child: IconButton(
            icon: Icon(
              Icons.list,
              color: Colors.black,
            ),
            onPressed: () {
              print('IconButton pressed ...');
            },
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy > 0) {
              setState(() {
                additionalInfoVisible = true;
              });
            } else {
              setState(() {
                additionalInfoVisible = false;
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(100, 70), //tab curve???
                bottomRight: Radius.circular(40),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Implement action to edit the image
                          print('Edit image');
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                //update img acc to user profile
                                'https://picsum.photos/seed/75/600',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: userHeight,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Height (cm)',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              // Validation logic here
                              return null;
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: userWeight,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Weight (kg)',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              // Validation logic here
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  buildTextField('Firstname', firstName),
                  buildTextField('Lastname', lastName),
                  Visibility(
                    visible: additionalInfoVisible,
                    child: Column(
                      children: [
                        buildTextField('Age', userAge,
                            keyboardType: TextInputType.number),
                        buildTextField('Sex at Birth', userSex),
                        buildTextField('Blood Type', userBloodType),
                        buildTextField('Address', userAddress),
                        Divider(
                          thickness: 10,
                        ),
                        buildTextField(
                            'Emergency Contact Person', emergencyContactName),
                        buildTextField(
                            'Emergency Contact Number', emergencyContactNumber,
                            keyboardType: TextInputType.number),
                        buildTextField('Emergency Contact Address',
                            emergencyContactAddress),
                        Divider(
                          height: 20,
                          thickness: 10,
                        ),
                        buildTextField('Medical Conditions:', userMedicalCond),
                        buildTextField('Allergies:', userAllergies),
                        buildTextField('Current Medication:', userMedications),
                        SizedBox(height: 30),
                        Container(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                // Save changes made by user
                                setState(() {
                                  userHeight = userHeight;
                                  userWeight = userWeight;
                                  firstName = firstName;
                                  lastName = lastName;
                                  userAge = userAge;
                                  userSex = userSex;
                                  userBloodType = userBloodType;
                                  userAddress = userAddress;
                                  emergencyContactName = emergencyContactName;
                                  emergencyContactNumber =
                                      emergencyContactNumber;
                                  emergencyContactAddress =
                                      emergencyContactAddress;
                                  userMedicalCond = userMedicalCond;
                                  userAllergies = userAllergies;
                                  userMedications = userMedications;
                                });
                                // Hide additional information when dragged up
                                setState(() {
                                  additionalInfoVisible = false;
                                });
                              },
                              child: Text('Save Profile'),
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

  Widget buildTextField(String labelText, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: SizedBox(
        height: 25,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          autofocus: true,
          obscureText: false,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            labelText: labelText,
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            filled: true,
            fillColor: Color(0xFFD92B4B),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFD92B4B),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFD92B4B),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            // Validation logic here
            return null;
          },
        ),
      ),
    );
  }
}
