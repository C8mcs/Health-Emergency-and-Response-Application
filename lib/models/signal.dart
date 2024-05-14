class Signal {
  final String emergencyType;
  final String dateCreated;

  Signal({
    required this.emergencyType,
    required this.dateCreated,
  });

  factory Signal.fromMap(Map<String, dynamic> map) => Signal(
    emergencyType: map['emergencyType'] as String,
    dateCreated: map['dateCreated'] as String,
  );

  Map<String, dynamic> toMap() => {
    'emergencyType': emergencyType,
    'dateCreated': dateCreated,
  };
}
