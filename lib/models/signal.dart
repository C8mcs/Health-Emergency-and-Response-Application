import 'package:cloud_firestore/cloud_firestore.dart';

class Signal {
  final String emergencyType;
  final String dateCreated;
  final GeoPoint victimLocation;

  Signal({
    required this.emergencyType,
    required this.dateCreated,
    required this.victimLocation,
  });

  factory Signal.fromMap(Map<String, dynamic> map) => Signal(
    emergencyType: map['emergencyType'] as String,
    dateCreated: map['dateCreated'] as String,
    victimLocation: map['dateCreated'] as GeoPoint,
  );

  Map<String, dynamic> toMap() => {
    'emergencyType': emergencyType,
    'dateCreated': dateCreated,
    'victimLocation': victimLocation,
  };
}