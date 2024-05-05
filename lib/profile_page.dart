import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
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
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // User Profile variables
  final userName = 'UserNAMEEOOh';
  TextEditingController userHeight = TextEditingController();
  TextEditingController userWeight = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController userAge = TextEditingController();
  TextEditingController userSex = TextEditingController();
  TextEditingController userBloodType = TextEditingController();
  TextEditingController userAddress = TextEditingController();
  TextEditingController userContactNumber = TextEditingController();
  TextEditingController emergencyContactName = TextEditingController();
  TextEditingController emergencyContactNumber = TextEditingController();
  TextEditingController emergencyContactAddress = TextEditingController();
  TextEditingController userMedicalCond = TextEditingController();
  TextEditingController userAllergies = TextEditingController();
  TextEditingController userMedications = TextEditingController();

  // Initial visibility of additional information
  bool additionalInfoVisible = false;

// Modify the build method in the _ProfilePageState class
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
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
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
                        Transform.translate(
                          offset: const Offset(0, 20),
                          child: Text(
                            'Hello, $userName',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                const Shadow(
                                  color: Colors.grey,
                                  blurRadius: 10.0,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0,
                              5), // Adjust horizontal translation to minimize space
                          child: Text(
                            'I am HERA',
                            style: TextStyle(
                              fontSize: 50,
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                const Shadow(
                                  color: Colors.grey,
                                  blurRadius: 10.0,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0,
                              -10), // Adjust horizontal translation to minimize space
                          child: const Text(
                            'Bringing your safety into your\nfingertips',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            strutStyle: StrutStyle(
                              height:
                                  1, // Set the line height to 1 to remove white spaces between lines
                            ),
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
                            CustomMeasurementFieldStatic(
                              labelText: 'Height (cm)',
                              textValue: userHeight.text,
                            ),
                            CustomMeasurementFieldStatic(
                              labelText: 'Weight (kg)',
                              textValue: userWeight.text,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child:
                                  buildInitialTextField('Firstname', firstName),
                            ),
                            const SizedBox(
                                width: 10), // Add some spacing between fields
                            Expanded(
                              child: buildInitialTextField(
                                  'Emergency Contact Number',
                                  emergencyContactNumber),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child:
                                  buildInitialTextField('Lastname', lastName),
                            ),
                            const SizedBox(
                                width: 10), // Add some spacing between fields
                            Expanded(
                              child: buildInitialTextField(
                                  'Contact Person', emergencyContactName),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Row(children: [
                              buildInitialTextFieldAgeSex('Age', userAge),
                              buildInitialTextFieldAgeSex('Sex', userSex),
                            ]),

                            const SizedBox(
                                width: 10), // Add some spacing between fields
                            Expanded(
                              child: buildInitialTextField(
                                  'Contact Number', userContactNumber),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_circle_down_rounded,
                          color: Colors.pink,
                          size: 40.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: additionalInfoVisible,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'User Info',
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
                              CustomMeasurementFormField(
                                labelText: 'Height (cm)',
                                controller: userHeight,
                                keyboardType: TextInputType.number,
                              ),
                              CustomMeasurementFormField(
                                labelText: 'Weight (kg)',
                                controller: userWeight,
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                          buildTextField('First Name', firstName),
                          buildTextField('Last Name', lastName),
                          Row(
                            children: [
                              Expanded(
                                child: buildTextField('Age', userAge,
                                    keyboardType: TextInputType.number),
                              ),
                              Expanded(
                                child: buildTextField('Sex', userSex),
                              ),
                              Expanded(
                                child:
                                    buildTextField('Blood Type', userBloodType),
                              ),
                            ],
                          ),
                          buildTextField('Address', userAddress),
                          buildTextField('Contact Number', userContactNumber),
                          const Divider(
                            thickness: 10,
                          ),
                          buildTextFieldEmergencyContact(
                              'Emergency Contact Person', emergencyContactName),
                          buildTextFieldEmergencyContact(
                              'Emergency Contact Number',
                              emergencyContactNumber,
                              keyboardType: TextInputType.number),
                          buildTextFieldEmergencyContact(
                              'Emergency Contact Address',
                              emergencyContactAddress),
                          const Divider(
                            height: 20,
                            thickness: 10,
                          ),
                          buildTextField(
                              'Medical Conditions:', userMedicalCond),
                          buildTextField('Allergies:', userAllergies),
                          buildTextField(
                              'Current Medication:', userMedications),
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
                                    userContactNumber = userContactNumber;
                                    emergencyContactName = emergencyContactName;
                                    emergencyContactNumber =
                                        emergencyContactNumber;
                                    emergencyContactAddress =
                                        emergencyContactAddress;
                                    userMedicalCond = userMedicalCond;
                                    userAllergies = userAllergies;
                                    userMedications = userMedications;
                                  });
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
      //Sos button will only appear when not in edit mode
      bottomNavigationBar: additionalInfoVisible
          ? null
          : Container(
              height: 150,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/send_sos.gif'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: GestureDetector(
                  // onLongPress: () => _navigateToDifferentPage(context),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 500,
                    width: 500,
                  ),
                ),
              ),
            ),
    );
  }

  //for INITIAL user personal info style, input DISABLED
  Widget buildInitialTextField(
    String labelText,
    TextEditingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              color: Color(0xFFD92B4B),
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 30,
            child: TextFormField(
              controller: controller,
              enabled: false,
              autofocus: true,
              readOnly: true, // Prevent exiting the text box
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: labelText,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 15,
                ),
                filled: true,
                fillColor: const Color(0xFFD92B4B),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFD92B4B),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
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
        ],
      ),
    );
  }

  // initial text field deco for age and sex, input DISABLED
  Widget buildInitialTextFieldAgeSex(
    String labelText,
    TextEditingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      width: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              color: Color(0xFFD92B4B),
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 30,
            child: TextFormField(
              controller: controller,
              enabled: false,
              autofocus: true,
              readOnly: true, // Prevent exiting the text box
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: labelText,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 15,
                ),
                filled: true,
                fillColor: const Color(0xFFD92B4B),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFFD92B4B),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
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
        ],
      ),
    );
  }

  //for user personal info style, input enabled
  Widget buildTextField(String labelText, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: SizedBox(
        height: 30, // Added a fixed height
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          autofocus: true,
          obscureText: false,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.edit_square,
              size: 20,
              color: Colors.white.withOpacity(0.7),
            ),
            labelText: labelText,
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            filled: true,
            fillColor: const Color(0xFFD92B4B),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFFD92B4B),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
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

  // Custom widget for emergency contact style
  Widget buildTextFieldEmergencyContact(
      String labelText, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: SizedBox(
        height: 30,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          autofocus: true,
          obscureText: false,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.edit_square,
              size: 20,
              color: Colors.white.withOpacity(0.7),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            labelText: labelText,
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            filled: true,
            fillColor: const Color(0xFF666573),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF666573),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF666573),
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

//height and weight, input enabled
class CustomMeasurementFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const CustomMeasurementFormField({
    required this.labelText,
    required this.controller,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: TextFormField(
          controller: controller,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          keyboardType: keyboardType,
          autofocus: true,
          obscureText: false,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: labelText,
            filled: true,
            fillColor: const Color(0xFFD9D9D9),
            suffixIcon: Icon(
              Icons.edit_square,
              size: 20,
              color: Colors.red.withOpacity(0.8),
            ),
            labelStyle: const TextStyle(
              color: Colors.red,
              fontSize: 15,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: const BorderSide(
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
    );
  }
}

// decoration for initial height and weight , input DISABLED
class CustomMeasurementFieldStatic extends StatelessWidget {
  final String labelText;
  final String textValue;

  const CustomMeasurementFieldStatic({
    required this.labelText,
    required this.textValue,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: TextFormField(
          readOnly: true,
          enabled: false,
          decoration: InputDecoration(
            labelText: labelText,
            filled: true,
            fillColor: const Color(0xFFD9D9D9),
            labelStyle: const TextStyle(
              color: Colors.red,
              fontSize: 15,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          controller: TextEditingController(text: textValue),
        ),
      ),
    );
  }
}
