import 'package:cloud_firestore/cloud_firestore.dart';

class Signal {
  final String emergencyType;
  final String dateCreated;
  final GeoPoint victimLocation;
  final String name;
  final String contactNumber;
  final String emergencyContactNumber;

  Signal({
    required this.emergencyType,
    required this.dateCreated,
    required this.victimLocation,
    required this.name,
    required this.contactNumber,
    required this.emergencyContactNumber,
  });

  factory Signal.fromMap(Map<String, dynamic> map) => Signal(
        emergencyType: map['emergencyType'] ?? '',
        dateCreated: map['dateCreated'] ?? '',
        victimLocation: map['victimLocation'],
        name: map['name'] ?? '',
        contactNumber: map['contactNumber'] ?? '',
        emergencyContactNumber: map['emergencyContactNumber'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'emergencyType': emergencyType,
        'dateCreated': dateCreated,
        'victimLocation': victimLocation,
        'name': name,
        'contactNumber': contactNumber,
        'emergencyContactNumber': emergencyContactNumber,
      };
}
