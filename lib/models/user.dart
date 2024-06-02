import 'package:cloud_firestore/cloud_firestore.dart';

class HeraUser {
  final String uid;
  final String email;
  final String contactNumber;
  final String dateCreated;
  final int? height;
  final int? weight;
  final String? firstName;
  final String? lastName;
  final int? age;
  final String? sexB;
  final String? bloodType;
  final String? address;
  Map<String, dynamic>? preferences;

  HeraUser({
    required this.uid,
    required this.email,
    required this.contactNumber,
    required this.dateCreated,
    this.height,
    this.weight,
    this.firstName,
    this.lastName,
    this.age,
    this.sexB,
    this.bloodType,
    this.address,
    this.preferences,
  });

  factory HeraUser.fromMap(Map<String, dynamic> map) => HeraUser(
        uid: map['uid'] as String,
        email: map['email'] as String,
        contactNumber: map['contactNumber'] as String,
        dateCreated: map['dateCreated'] as String,
        height: map['height'] is String
            ? int.tryParse(map['height'])
            : map['height'],
        weight: map['weight'] is String
            ? int.tryParse(map['weight'])
            : map['weight'],
        firstName: map['firstName'] as String?,
        lastName: map['lastName'] as String?,
        age: map['age'] is String ? int.tryParse(map['age']) : map['age'],
        sexB: map['sexB'] as String?,
        bloodType: map['bloodType'] as String?,
        address: map['address'] as String?,
        preferences: map['preferences'] as Map<String, dynamic>?,
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'contactNumber': contactNumber,
        'dateCreated': dateCreated,
        'height': height,
        'weight': weight,
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
        'sexB': sexB,
        'bloodType': bloodType,
        'address': address,
        'preferences': preferences,
      };

  Future<void> savePreferences() async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'preferences': preferences,
    });
  }

  Future<void> loadPreferences() async {
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    preferences = userData['preferences'];
  }
}
