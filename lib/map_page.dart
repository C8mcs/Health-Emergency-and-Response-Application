import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'models/signal.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
      color: Colors.blue, // Adjust color and transparency
      borderColor: Colors.black,
      borderStrokeWidth: 1,
    );
    _userLocationCircles.add(userLocationCircle);

    void _clearMarkers(_mapMarkers) {
      _mapMarkers.clear();
    }

    void _createMarkers(querySnapshot) {
      final markers = <Marker>[];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final double latitude = data['victimLocation'].latitude;
        final double longitude = data['victimLocation'].longitude;
        final double distance = calculateDistance(
            LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
            LatLng(latitude, longitude));
        final color = getColorBasedOnDistance(distance);
        final String documentID = doc.id;
        markers.add(
          Marker(
            width: 100,
            height: 100,
            point: LatLng(latitude, longitude),
            child: IconButton(
              iconSize: 40,
              icon: Icon(Icons.person_pin_circle),
              color: Colors.red,
              onPressed: () {
                if (isResponder) {
                  _mapController.move(LatLng(latitude, longitude), 20);
                  setState(() {
                    responderID = currentUserID!;
                    showRespondButton = true;
                    victimID = documentID;
                    routeToDistressed.clear();
                    routeToDistressed.add(
                        Polyline(
                          color: Colors.black,
                          isDotted: true,
                          strokeWidth: 5,
                          points: [LatLng(_currentLocation.latitude!, _currentLocation.longitude!), LatLng(latitude, longitude)],
                        )
                    );
                  });
                }
              },
            ),
          ),
        );
      }
      setState(() {
        _clearMarkers(_mapMarkers);
        _mapMarkers = markers;
      });
    }
    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLocation = locationData;
        if (_distressCallRef != null) {
          final victimLocation = GeoPoint(locationData.latitude!, locationData.longitude!);
          _distressCallRef!.update({'victimLocation': victimLocation});
          if (!isCalling) {
            _userLocationCircles.clear();
            LatLng userLocation = LatLng(_currentLocation.latitude!, _currentLocation.longitude!);
            _userLocationCircles.add(
              CircleMarker(
                point: userLocation,
                radius: 5, // Adjust radius as needed (in meters)
                color: Colors.blue, // Adjust color and transparency
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
      _clearMarkers(_mapMarkers);
      _createMarkers(querySnapshot);
    });
  }

  @override
  void dispose() {
    _locationStreamSubscription?.cancel();
    super.dispose();
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    final double distanceInMeters = Geolocator.distanceBetween(
        point1.latitude, point1.longitude, point2.latitude, point2.longitude);
    return distanceInMeters;
  }

  Color getColorBasedOnDistance(double distance) {
    int opacity;
    if (distance < 200) {
      opacity = 250;
    }
    else if (distance < 400) {
      opacity = 150;
    }
    else if (distance < 600){
      opacity = 50;
    }
    else {
      opacity = 0;
    }
    return Color.fromARGB(opacity, 255, 0, 0);
  }

  void _centerOnMarker() {
    _mapController.move(
        LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
        _zoomLevel);
  }

  void _sendDistressSignal(user) async{
    Location location = new Location();
    LocationData locationData = await location.getLocation();
    GeoPoint victimLocation = GeoPoint(
        locationData.latitude ?? 0.0,
        locationData.longitude ?? 0.0);
    Signal helpSignal = Signal(emergencyType: "SOS",
        dateCreated: DateTime.now().toString(),
        victimLocation: victimLocation);
    await FirebaseFirestore.instance
        .collection('distressCalls')
        .doc(user?.uid)
        .set(helpSignal.toMap());
  }

  void _deleteSignal(user) async{
    await FirebaseFirestore.instance
        .collection('distressCalls')
        .doc(user?.uid)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!isResponder)
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  if (!isCalling) {
                    _sendDistressSignal(FirebaseAuth.instance.currentUser);
                    setState(() {
                      isCalling = true;
                      _userLocationCircles.clear();
                    });
                  }

                  else {
                    _deleteSignal(FirebaseAuth.instance.currentUser);
                    setState(() {
                      isCalling = false;
                    });
                  }
                },
                label: isCalling ? const Text('Cancel') : const Text('SOS'),
                icon: const Icon(Icons.check),
              ),
            ),

          if (showRespondButton)
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  if (!isResponding) {
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
                      'responderLocation': GeoPoint(responderLatitude, responderLongitude),
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Responder $responderID is coming for $victimID')));
                    setState(() {
                      isResponding = true;
                    });
                  }
                  else {
                    await _firestore
                        .collection('distressCalls')
                        .doc(victimID)
                        .collection('responders')
                        .doc(responderID)
                        .delete();

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Responder $responderID has stopped!')));
                    setState(() {
                      isResponding = false;
                      showRespondButton = false;
                    });
                  }
                },
                label: isResponding ? const Text('Cancel') : const Text('Respond'),
                icon: const Icon(Icons.check),
              ),
            ),
          Align(
            alignment: Alignment(1.0, 1.0),
            child: FloatingActionButton(
              onPressed: _centerOnMarker,
              child: const Icon(Icons.my_location),
            ),
          ),
          Align(
            alignment: Alignment(1.0, 1.0),
            child:
            Container(
              width: 175,
              child: Builder(
                builder: (context) => SwitchListTile(
                  tileColor: Colors.red,
                  title: Text(switchText),
                  value: isResponder,
                  onChanged: (bool value) {
                    setState(() {
                      showRespondButton = false;
                      isResponder = value;
                      mapTemplate = isResponder? 'https://tile.thunderforest.com/landscape/{z}/{x}/{y}.png?apikey=a1f757577b5e4d33a9ea5bd8bccffd02' : 'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png';
                      switchText = isResponder ? "Responder" : "User";
                    });
                  },
                ),
              ),
            ),
          )
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
                // urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                // urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', dark mode
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
        ],
      ),
    );
  }
}