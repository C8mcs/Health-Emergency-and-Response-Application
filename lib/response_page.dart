import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ResponderApp());
}

class ResponderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency Responder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ResponderScreen(),
    );
  }
}

class ResponderScreen extends StatefulWidget {
  @override
  _ResponderScreenState createState() => _ResponderScreenState();
}

class _ResponderScreenState extends State<ResponderScreen> {
  final MapController _mapController = MapController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LatLng _targetLocation = LatLng(10.640403, 122.229903);
  List<Marker> _mapMarkers = [];
  Location _location = Location();
  bool _isRespondButtonEnabled = false;
  String _selectedDocumentId = '';

  @override
  void initState() {
    super.initState();
    _fetchDistressCalls();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    bool _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    PermissionStatus _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _getLocation();
  }

  void _getLocation() async {
    final locationData = await _location.getLocation();
    final double currentLatitude = locationData.latitude!;
    final double currentLongitude = locationData.longitude!;

    setState(() {
      _mapMarkers.add(
        Marker(
          width: 40.0,
          height: 40.0,
          point: LatLng(currentLatitude, currentLongitude),
          child: Icon(
            size: 40,
            Icons.person_pin_circle,
            color: Colors.black,
          ),
        ),
      );
    });
  }

  void _fetchDistressCalls() async {
    final querySnapshot = await _firestore.collection('distressCalls').get();

    setState(() {
      _mapMarkers.clear();
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final double latitude = data['victimLocation'].latitude;
        final double longitude = data['victimLocation'].longitude;

        _mapMarkers.add(
          Marker(
            width: 40.0,
            height: 40.0,
            point: LatLng(latitude, longitude),
            child: IconButton(
              iconSize: 40,
              icon: Icon(Icons.person_pin),
              color: Colors.red,
              onPressed: () {
                _onMarkerTap(doc.id);
                print('Marker tapped!');
              },
            ),
          ),
        );
      }
    });
  }

  void _centerOnTargetLocation() {
    _mapController.move(_targetLocation, 16.0);
  }

  void _onMarkerTap(String documentId) {
    setState(() {
      _isRespondButtonEnabled = true;
      _selectedDocumentId = documentId;
    });
  }

  void _respond() async {
    final Location location = Location();
    final locationData = await location.getLocation();

    final double responderLatitude = locationData.latitude!;
    final double responderLongitude = locationData.longitude!;

    await _firestore
        .collection('distressCalls')
        .doc(_selectedDocumentId)
        .collection('responderID')
        .add({
      'responderLocation': GeoPoint(responderLatitude, responderLongitude),
    });

    print('Responder location added successfully!');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Distress Location',
          style: TextStyle(
            fontSize: 37,
            fontWeight: FontWeight.bold,
            color: Color(0xFFBD2D29),
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _centerOnTargetLocation,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      minZoom: 10.0,
                      maxZoom: 18,
                    ),
                    children: [
                      TileLayer(
                        // urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        urlTemplate:
                            'https://tile-{s}.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                        // urlTemplate: 'http://tile.stamen.com/terrain/{z}/{x}/{y}.jpg',
                        // urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                        // urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(markers: _mapMarkers)
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red,),
            onPressed: _isRespondButtonEnabled ? () {_respond();print('xdd');} : null,
            child: Text(
              'Respond',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
