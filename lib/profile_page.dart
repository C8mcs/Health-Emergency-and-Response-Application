import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'reusables/custom_widget_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
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

  final Color fillColorRed = Color(0xFFD92B4B);
  final Color fillColorGray = Color(0xFF666573);

  // Initial visibility of additional information
  bool additionalInfoVisible = false;
  String? selectedBloodType;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  _fetch() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      try {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        if (userData.exists) {
          setState(() {
            firstName.text = userData['firstName'];
            lastName.text = userData['lastName'];
            userHeight.text = userData['height'];
            userWeight.text = userData['weight'];
            userAge.text = userData['age'];
            userSex.text = userData['sex'];
            selectedBloodType = userData['bloodType'];
            userAddress.text = userData['address'];
            emergencyContactName.text = userData['emergencyContactName'];
            emergencyContactNumber.text = userData['emergencyContactNumber'];
            emergencyContactAddress.text = userData['emergencyContactAddress'];
            userMedicalCond.text = userData['medicalConditions'];
            userAllergies.text = userData['allergies'];
            userMedications.text = userData['medications'];
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> _saveProfile() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .update({
          'firstName': firstName.text,
          'lastName': lastName.text,
          'height': userHeight.text,
          'weight': userWeight.text,
          'age': userAge.text,
          'sex': userSex.text,
          'bloodType': selectedBloodType,
          'address': userAddress.text,
          'emergencyContactName': emergencyContactName.text,
          'emergencyContactNumber': emergencyContactNumber.text,
          'emergencyContactAddress': emergencyContactAddress.text,
          'medicalConditions': userMedicalCond.text,
          'allergies': userAllergies.text,
          'medications': userMedications.text,
        });
        setState(() {
          additionalInfoVisible = false;
        });
        print("Profile updated successfully");
      } catch (e) {
        print('Error updating profile: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD92B4B),
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
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                    visible: !additionalInfoVisible,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'User Info',
                          style: TextStyle(
                            color: Color(0xFFD92B4B),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                                  padding: const EdgeInsets.all(8),
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
                            MeasurementHeightWeight(
                              labelText: 'Height (cm)',
                              controller: userHeight,
                              keyboardType: TextInputType.number,
                              enabled: false,
                              readOnly: true,
                            ),
                            MeasurementHeightWeight(
                              labelText: 'Weight (kg)',
                              controller: userWeight,
                              keyboardType: TextInputType.number,
                              enabled: false,
                              readOnly: true,
                            ),
                          ],
                        ),
                        CustomTextField(
                          labelText: 'Firstname',
                          controller: firstName,
                          enabled: false,
                          readOnly: true,
                          fillColor: fillColorRed,
                        ),
                        CustomTextField(
                          labelText: 'Lastname',
                          controller: lastName,
                          fillColor: fillColorRed,
                          enabled: false,
                          readOnly: true,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                labelText: 'Age',
                                controller: userAge,
                                fillColor: fillColorRed,
                                enabled: false,
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            Expanded(
                              child: CustomTextField(
                                labelText: 'Sex',
                                controller: userSex,
                                fillColor: fillColorRed,
                                enabled: false,
                                readOnly: true,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Blood Type',
                                      style: TextStyle(
                                        color: fillColorRed,
                                        fontSize: 15,
                                      ),
                                    ),
                                    TextFormField(
                                      controller: TextEditingController(
                                          text: selectedBloodType ?? ''),
                                      enabled: false,
                                      readOnly: true,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        labelText: 'Blood Type',
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                        filled: true,
                                        fillColor: fillColorRed,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: fillColorRed,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: fillColorRed,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "...",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Color(0xFFD92B4B)),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  //
                  //Visible display when dragged down
                  //

                  Visibility(
                    visible: additionalInfoVisible,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Edit User Info',
                            style: TextStyle(
                              color: Color(0xFFD92B4B),
                              fontSize: 20,
                            ),
                          ),
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
                                    padding: const EdgeInsets.all(8),
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
                              MeasurementHeightWeight(
                                labelText: 'Height (cm)',
                                controller: userHeight,
                                keyboardType: TextInputType.number,
                                enabled: true,
                                readOnly: false,
                              ),
                              MeasurementHeightWeight(
                                labelText: 'Weight (kg)',
                                controller: userWeight,
                                keyboardType: TextInputType.number,
                                enabled: true,
                                readOnly: false,
                              ),
                            ],
                          ),
                          Text(
                            "User Information",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color(0xFFD92B4B),
                            ),
                          ),
                          CustomTextField(
                            labelText: 'Firstname',
                            controller: firstName,
                            enabled: true,
                            readOnly: false,
                            fillColor: fillColorRed,
                          ),
                          CustomTextField(
                            labelText: 'Lastname',
                            controller: lastName,
                            fillColor: fillColorRed,
                            enabled: true,
                            readOnly: false,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  labelText: 'Age',
                                  controller: userAge,
                                  fillColor: fillColorRed,
                                  enabled: true,
                                  readOnly: false,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ),
                              Expanded(
                                child: CustomTextField(
                                  labelText: 'Sex',
                                  controller: userSex,
                                  fillColor: fillColorRed,
                                  enabled: true,
                                  readOnly: false,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Blood Type',
                                      style: TextStyle(
                                        color: fillColorRed,
                                        fontSize: 15,
                                      ),
                                    ),
                                    DropdownButtonFormField<String>(
                                      value: selectedBloodType,
                                      items: [
                                        'A+',
                                        'A-',
                                        'B+',
                                        'B-',
                                        'AB+',
                                        'AB-',
                                        'O+',
                                        'O-'
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedBloodType = newValue;
                                        });
                                      },
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        labelText: 'Blood Type',
                                        labelStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                        filled: true,
                                        fillColor: fillColorRed,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: fillColorRed,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: fillColorRed,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      dropdownColor: fillColorRed,
                                      icon: Icon(Icons.arrow_drop_down,
                                          color: Colors
                                              .white), // Change icon color to white
                                      iconEnabledColor: Colors
                                          .white, // Change icon color to white
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          CustomTextField(
                            labelText: 'Address',
                            controller: userAddress,
                            fillColor: fillColorRed,
                            enabled: true,
                            readOnly: false,
                          ),
                          SizedBox(height: 10),
                          const Divider(
                            thickness: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Emergency Contact Information",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color(0xFFD92B4B),
                            ),
                          ),
                          CustomTextField(
                            labelText: 'Emergency Contact Person',
                            controller: emergencyContactName,
                            fillColor: fillColorGray,
                            enabled: true,
                            readOnly: false,
                          ),
                          CustomTextField(
                            labelText: 'Emergency Contact Number',
                            controller: emergencyContactNumber,
                            fillColor: fillColorGray,
                            enabled: true,
                            readOnly: false,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                          CustomTextField(
                            labelText: 'Emergency Contact Address',
                            controller: emergencyContactAddress,
                            fillColor: fillColorGray,
                            enabled: true,
                            readOnly: false,
                          ),
                          SizedBox(height: 10),
                          const Divider(
                            height: 20,
                            thickness: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "User Medical Conditions",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color(0xFFD92B4B),
                            ),
                          ),
                          CustomTextField(
                            labelText: 'Medical Conditions:',
                            controller: userMedicalCond,
                            fillColor: fillColorRed,
                            enabled: true,
                            readOnly: false,
                            minLines: 1,
                            maxLines: 5,
                          ),
                          CustomTextField(
                            labelText: 'Allergies:',
                            controller: userAllergies,
                            fillColor: fillColorRed,
                            enabled: true,
                            readOnly: false,
                            minLines: 1,
                            maxLines: 5,
                          ),
                          CustomTextField(
                            labelText: 'Current Medication:',
                            controller: userMedications,
                            fillColor: fillColorRed,
                            enabled: true,
                            readOnly: false,
                            minLines: 1,
                            maxLines: 5,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xFFD92B4B)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                ),
                                onPressed: () {
                                  // Display the confirmation dialog along with the changes made by user
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Confirm Changes"),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                  "Height: ${userHeight.text} cm"),
                                              Text(
                                                  "Weight: ${userWeight.text} kg"),
                                              Text(
                                                  "First Name: ${firstName.text}"),
                                              Text(
                                                  "Last Name: ${lastName.text}"),
                                              Text("Age: ${userAge.text}"),
                                              Text(
                                                  "Sex at Birth: ${userSex.text}"),
                                              Text(
                                                  "Blood Type: ${selectedBloodType}"),
                                              Text(
                                                  "Address: ${userAddress.text}"),
                                              Text(
                                                  "Emergency Contact Name: ${emergencyContactName.text}"),
                                              Text(
                                                  "Emergency Contact Number: ${emergencyContactNumber.text}"),
                                              Text(
                                                  "Emergency Contact Address: ${emergencyContactAddress.text}"),
                                              Text(
                                                  "Medical Conditions: ${userMedicalCond.text}"),
                                              Text(
                                                  "Allergies: ${userAllergies.text}"),
                                              Text(
                                                  "Medications: ${userMedications.text}"),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("Cancel"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Confirm"),
                                            onPressed: () {
                                              _saveProfile();

                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Save Profile'),
                              ),
                            ),
                          ),
                        ],
                      ),
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
