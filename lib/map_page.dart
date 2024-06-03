import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'app_constants.dart';
import 'models/signal.dart';
import 'reusables/logo.dart';
import 'reusables/modal_constant.dart';
import 'theme_notifier.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool isUserInfoVisible = true;
  bool isCalling = false;
  bool isResponder = false;
  bool isResponding = false;
  bool showRespondButton = false;
  DocumentReference? _distressCallRef;
  final double _zoomLevel = 16;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int distanceValue = 0;
  late List<CircleMarker> _userLocationCircles = [];
  late List<Marker> _mapMarkers = [];
  late List<Polyline> routeToDistressed = [];
  late Location _location;
  late LocationData _currentLocation;
  late MapController _mapController;
  StreamSubscription<QuerySnapshot>? _locationStreamSubscription;
  StreamSubscription<QuerySnapshot>? _respondersStreamSubscription;
  StreamSubscription<QuerySnapshot>? _safeStreamSubscription;
  String mapTemplate = 'https://tile-{s}.openstreetmap.fr/hot/{z}/{x}/{y}.png';
  String responderID = '';
  String victimID = '';
  String switchText = "User";

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _location = Location();
    _currentLocation =
        LocationData.fromMap({'latitude': 10.6406, 'longitude': 122.2303});

    final user = FirebaseAuth.instance.currentUser;
    String? currentUserID;
    if (user != null) {
      _distressCallRef = _firestore.collection('distressCalls').doc(user.uid);
      currentUserID = user.uid;
    }

    CircleMarker userLocationCircle = CircleMarker(
      point: LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
      radius: 5,
      color: Colors.blue,
      borderColor: Colors.black,
      borderStrokeWidth: 1,
    );
    _userLocationCircles.add(userLocationCircle);

    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLocation = locationData;
        if (_distressCallRef != null) {
          final victimLocation =
              GeoPoint(locationData.latitude!, locationData.longitude!);
          try {
            _distressCallRef!.update({'victimLocation': victimLocation});
          } catch (e) {
            showModal(
              context,
              'Error',
              message:
                  'Failed to update victim location. Please try again later.',
            );
          }
          if (!isCalling) {
            _userLocationCircles.clear();
            LatLng userLocation =
                LatLng(_currentLocation.latitude!, _currentLocation.longitude!);
            _userLocationCircles.add(
              CircleMarker(
                point: userLocation,
                radius: 5,
                color: Colors.blue,
                borderColor: Colors.black,
                borderStrokeWidth: 1,
              ),
            );
          }
        }
      });
    });

    _locationStreamSubscription = _firestore
        .collection('distressCalls')
        .snapshots()
        .listen((querySnapshot) {
      _clearMarkers();
      _createMarkers(querySnapshot);
    });

    _respondersStreamSubscription = _firestore
        .collection('distressCalls')
        .doc(currentUserID)
        .collection('responders')
        .snapshots()
        .listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        if (isCalling) {
          if (change.type == DocumentChangeType.added) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('A responder is on their way!',  style: TextStyle(color: Colors.white), // Set text color to white
              ),
              backgroundColor: Colors.red, // Set background color to red
            ));
          }
          if (change.type == DocumentChangeType.removed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('A responder has stopped and is no longer coming for you!',  style: TextStyle(color: Colors.white), // Set text color to white
              ),
              backgroundColor: Colors.red, // Set background color to red
            ));
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _locationStreamSubscription?.cancel();
    super.dispose();
  }

  void _clearMarkers() {
    _mapMarkers.clear();
  }

  void _createMarkers(QuerySnapshot querySnapshot) {
    try {
      final markers = <Marker>[];
      for (var doc in querySnapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          final double latitude = data['victimLocation'].latitude;
          final double longitude = data['victimLocation'].longitude;
          final String? emergencyType = data['emergencyType'];
          final String? name = data['name'];
          final String? contactNumber = data['contactNumber'];
          final String? emergencyContactNumber = data['emergencyContactNumber'];
          final double distance = calculateDistance(
            LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
            LatLng(latitude, longitude),
          );
          final String documentID = doc.id;
          markers.add(
            Marker(
              width: 100,
              height: 100,
              point: LatLng(latitude, longitude),
              child: GestureDetector(
                onTap: () {
                  if (isResponder) {
                    _mapController.move(LatLng(latitude, longitude), 20);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Emergency Details'),
                          content: SingleChildScrollView(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Emergency Type: $emergencyType',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Name: $name'),
                                  const SizedBox(height: 4),
                                  Text('Contact Number: $contactNumber'),
                                  const SizedBox(height: 4),
                                  Text(
                                      'Emergency Contact: $emergencyContactNumber'),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                {
                                  try {
                                    final location = Location();
                                    final locationData = await location.getLocation();
                                    final double responderLatitude = locationData.latitude!;
                                    final double responderLongitude = locationData.longitude!;

                                    await _firestore
                                        .collection('distressCalls')
                                        .doc(victimID)
                                        .collection('responders')
                                        .doc(responderID)
                                        .set({
                                      'responderLocation':
                                      GeoPoint(responderLatitude, responderLongitude),
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('The victim has been notified that you are on the way!',  style: TextStyle(color: Colors.white), // Set text color to white
                                      ),
                                      backgroundColor: Colors.red, // Set background color to red
                                    ));
                                    setState(() {
                                      isResponding = true;
                                    });
                                  } catch (e) {
                                    showModal(
                                      context,
                                      'Error',
                                      message:
                                      'Failed to respond to distress signal. Please try again later.',
                                    );
                                  }
                                }
                                setState(() {
                                  responderID =
                                      FirebaseAuth.instance.currentUser!.uid;
                                  showRespondButton = true;
                                  victimID = documentID;
                                  routeToDistressed.clear();
                                  routeToDistressed.add(
                                    Polyline(
                                      color: Colors.black,
                                      isDotted: true,
                                      strokeWidth: 5,
                                      points: [
                                        LatLng(_currentLocation.latitude!,
                                            _currentLocation.longitude!),
                                        LatLng(latitude, longitude),
                                      ],
                                    ),
                                  );

                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .primaryColor, // Button color based on the current theme
                              ),
                              child: const Text(
                                'Respond',
                                style: TextStyle(
                                  color: Colors.white, // Set the text color
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Close',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary, // Set text color based on the theme
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_pin_circle, color: Colors.red),
                      Text(
                        emergencyType ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } catch (e) {
          print('Error processing document ${doc.id}: $e');
          markers.add(
            Marker(
              width: 100,
              height: 100,
              point: const LatLng(0, 0),
              child: Container(
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    Text(
                      'Error',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
      setState(() {
        _clearMarkers();
        _mapMarkers = markers;
      });
    } catch (e) {
      showModal(
        context,
        'Error',
        message: 'Failed to load distress markers. Please try again later.',
      );
    }
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    final double distanceInMeters = Geolocator.distanceBetween(
        point1.latitude, point1.longitude, point2.latitude, point2.longitude);
    return distanceInMeters;
  }

  void _centerOnMarker() {
    _mapController.move(
      LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
      _zoomLevel,
    );
  }

  void _sendDistressSignal(User? user) async {
    try {
      Location location = Location();
      LocationData locationData = await location.getLocation();
      GeoPoint victimLocation = GeoPoint(
        locationData.latitude ?? 0.0,
        locationData.longitude ?? 0.0,
      );

      String emergencyType = await _showEmergencyTypeDialog();

      // You can retrieve the user information here
      String name = (user?.firstName ?? '') + (user?.lastname ?? '');
      String contactNumber = user?.contactNumber ?? '';
      // Get the emergency contact number from wherever it's stored
      String emergencyContactNumber = ''; // TODO: Get emergency contact number

      Signal helpSignal = Signal(
        emergencyType: emergencyType,
        dateCreated: DateTime.now().toString(),
        victimLocation: victimLocation,
        name: name,
        contactNumber: contactNumber,
        emergencyContactNumber: emergencyContactNumber,
      );
      await FirebaseFirestore.instance
          .collection('distressCalls')
          .doc(user?.uid)
          .set(helpSignal.toMap());
    } catch (e) {
      showModal(
        context,
        'Error',
        message: 'Failed to send distress signal. Please try again later.',
      );
    }
  }

  Future<String> _showEmergencyTypeDialog() async {
    String selectedEmergencyType = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Emergency Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Violence'),
                onTap: () {
                  selectedEmergencyType = 'Violence';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Fire'),
                onTap: () {
                  selectedEmergencyType = 'Fire';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Health'),
                onTap: () {
                  selectedEmergencyType = 'Health';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Disaster'),
                onTap: () {
                  selectedEmergencyType = 'Disaster';
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
    return selectedEmergencyType;
  }

  void _deleteSignal(user) async {
    try {
      await FirebaseFirestore.instance
          .collection('distressCalls')
          .doc(user?.uid)
          .delete();
    } catch (e) {
      showModal(
        context,
        'Error',
        message: 'Failed to delete distress signal. Please try again later.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final themeData = themeNotifier.currentTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.primary,
        leading: IconButton(
          icon: Icon(Icons.my_location),
          onPressed: _centerOnMarker,
        ),
        actions: [
          Container(
            width: 250,
            child: SwitchListTile(
              activeColor: themeData.colorScheme.inversePrimary,
              inactiveTrackColor: themeData.colorScheme.onPrimary,
              title: Padding(
                padding: const EdgeInsets.only(
                    right: 16.0), // Adjust the right padding as needed
                child: Text(
                  switchText,
                  style: AppTextStyles.headline.copyWith(
                    color: themeData
                        .colorScheme.onPrimary, // Use onPrimary color for text
                    fontSize: 20,
                  ),
                ),
              ),
              value: isResponder,
              onChanged: (bool value) {
                setState(() {
                  showRespondButton = false;
                  isResponder = value;
                  mapTemplate = isResponder
                      ? 'https://tile.thunderforest.com/landscape/{z}/{x}/{y}.png?apikey=a1f757577b5e4d33a9ea5bd8bccffd02'
                      : 'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png';
                  switchText = isResponder ? "Respond" : "User";
                });
              },
            ),
          ),
          if (showRespondButton)
            IconButton(
              icon: Icon(Icons.cancel),
              color: themeData.colorScheme.onSecondary,
              onPressed: () async {
                if (isResponding) {
                  try {
                    await _firestore
                        .collection('distressCalls')
                        .doc(victimID)
                        .collection('responders')
                        .doc(responderID)
                        .delete();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Responder has suddenly stopped!',  style: TextStyle(color: Colors.white), // Set text color to white
                      ),
                      backgroundColor: Colors.red, // Set background color to red
                    ));
                    setState(() {
                      isResponding = false;
                      showRespondButton = false;
                      routeToDistressed.clear();
                    });
                  } catch (e) {
                    showModal(
                      context,
                      'Error',
                      message:
                      'Failed to stop responding. Please try again later.',
                    );
                  }
                }
              },
            ),
          if (showRespondButton)
            IconButton(
              icon: Icon(Icons.check),
              color: themeData.colorScheme.onSecondary,
              onPressed: () async {
                if (isResponding) {
                  try {
                    await _firestore
                        .collection('distressCalls')
                        .doc(victimID)
                        .set({'responderSafe': true,});
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Responder has confirmed that the situation is safe! Waiting for user confirmation...',  style: TextStyle(color: Colors.white), // Set text color to white
                        ),
                      backgroundColor: Colors.red, // Set background color to red
                    ));
                    setState(() {
                    });
                  } catch (e) {
                    showModal(
                      context,
                      'Error',
                      message:
                      'Failed to stop responding. Please try again later.',
                    );
                  }
                }
              },
            ),
          if (isCalling)
            IconButton(
              icon: Icon(Icons.check),
              color: themeData.colorScheme.onSecondary,
              onPressed: () async {
                await _firestore
                    .collection('distressCalls')
                    .doc(victimID)
                    .set({'userSafe': true,});
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('You have confirmed that the situation is safe! Waiting for responder confirmation...', style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                  backgroundColor: Colors.red, // Set background color to red)
                )
                );
              },
            ),
        ],
      ),

      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(
                  _currentLocation.latitude!, _currentLocation.longitude!),
              initialZoom: _zoomLevel,
              minZoom: 10.0,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: mapTemplate,
                userAgentPackageName: 'com.example.app',
              ),
              CircleLayer(
                circles: _userLocationCircles,
              ),
              PolylineLayer(
                polylines: routeToDistressed,
              ),
              MarkerLayer(
                markers: _mapMarkers,
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 100,
                height: 100,
                child: Logo(
                  onTap: () async {
                    if (!isCalling) {
                      _sendDistressSignal(FirebaseAuth.instance.currentUser);
                      setState(() {
                        isCalling = true;
                        _userLocationCircles.clear();
                      });
                    } else {
                      _deleteSignal(FirebaseAuth.instance.currentUser);
                      setState(() {
                        isCalling = false;
                      });
                    }
                  },
                  logoWidth: 100, // Adjust the width as needed
                  logoHeight: 100, // Adjust the height as needed
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
