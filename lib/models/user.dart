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
  });

  factory HeraUser.fromMap(Map<String, dynamic> map) => HeraUser(
    uid: map['uid'] as String,
    email: map['email'] as String,
    contactNumber: map['contactNumber'] as String,
    dateCreated: map['dateCreated'] as String,
    height: map['height'] as int?,
    weight: map['weight'] as int?,
    firstName: map['firstName'] as String?,
    lastName: map['lastName'] as String?,
    age: map['age'] as int?,
    sexB: map['sexB'] as String?,
    bloodType: map['bloodType'] as String?,
    address: map['address'] as String?,
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
  };
}
