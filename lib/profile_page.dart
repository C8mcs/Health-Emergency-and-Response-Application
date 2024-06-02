import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'reusables/custom_widget_profile_page.dart';
import 'app_constants.dart';

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProfilePage(),
    );
  }
}

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
  Uint8List? pickedImage;
  String? contactNumber;

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
            contactNumber = userData['contactNumber'];
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> onProfileChange() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      pickedImage = File(image.path).readAsBytesSync();
    });

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final fileName = '${firebaseUser.uid}/profile_picture.jpg';
      final uploadTask = storageRef.child(fileName).putFile(File(image.path));

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print(
            'Upload progress: ${snapshot.bytesTransferred} / ${snapshot.totalBytes}');
      });

      await uploadTask;

      final String downloadURL =
          await storageRef.child(fileName).getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .update({'profilePicture': downloadURL});

      print('Profile picture uploaded successfully');
    } catch (e) {
      print('Error uploading profile picture: $e');
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
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Visibility(
                    visible: !additionalInfoVisible,
                    child: Column(
                      children: [
                        SizedBox(height: 100),
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFFD92B4B),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 270,
                            ),
                            Positioned(
                              top: -50,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey, width: 3),
                                    shape: BoxShape.circle,
                                    image: pickedImage != null
                                        ? DecorationImage(
                                            fit: BoxFit.cover,
                                            image: Image.memory(
                                              pickedImage!,
                                              fit: BoxFit.cover,
                                            ).image,
                                          )
                                        : null),
                                child: Icon(
                                  Icons.person_rounded,
                                  color: Colors.black38,
                                  size: 35,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(height: 80),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${firstName.text} ${lastName.text}",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      " (${userAge.text})",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                      size: 24.0,
                                    ),
                                    Text(
                                      " ${userAddress.text}",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Contact No: ${contactNumber}",
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                SizedBox(height: 30),
                                Divider(
                                  height: 2,
                                  color: Colors.white,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Height (cm)",
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${userHeight.text}",
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      child: VerticalDivider(
                                        thickness: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Weight (kg)",
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${userWeight.text}",
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      child: VerticalDivider(
                                        thickness: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Blood Type",
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${selectedBloodType ?? ''}",
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "...",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              fontFamily: 'Montserrat',
                              color: Color(0xFFD92B4B)),
                        ),
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
                          SizedBox(height: 20),
                          Text(
                            'Edit User Info',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Color(0xFFD92B4B),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                onTap: onProfileChange, // bind the method here
                                child: GestureDetector(
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      shape: BoxShape.circle,
                                      image: pickedImage != null
                                          ? DecorationImage(
                                              fit: BoxFit.cover,
                                              image: MemoryImage(
                                                  pickedImage!), // Use MemoryImage to directly load bytes
                                            )
                                          : null,
                                    ),
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: Colors.black38,
                                      size: 35,
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
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Color(0xFFD92B4B),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
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
                                        fontFamily: 'Montserrat',
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
                                      style: GoogleFonts.montserrat(
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        labelText: 'Blood Type',
                                        labelStyle: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
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
                          SizedBox(height: 15),
                          const Divider(
                            thickness: 5,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Emergency Contact Information",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Color(0xFFD92B4B),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
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
                          SizedBox(height: 15),
                          const Divider(height: 20, thickness: 5),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "User Medical Conditions",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Color(0xFFD92B4B),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
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
                                child: Text(
                                  'Save Profile',
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
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
