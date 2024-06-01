import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool isResponder = false;
  final double _zoomLevel = 16;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentReference? _distressCallRef;
  late List<Marker> _mapMarkers = [];
  late LocationData _currentLocation;
  late Location _location;
  late MapController _mapController;
  StreamSubscription<QuerySnapshot>? _locationStreamSubscription;
  String mapTemplate = 'https://tile-{s}.openstreetmap.fr/hot/{z}/{x}/{y}.png';
  String switchText = "User";

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _location = Location();
    _currentLocation =
        LocationData.fromMap({'latitude': 10.6406, 'longitude': 122.2303});

    final user = FirebaseAuth.instance.currentUser;
    String? currentUserId;
    if (user != null) {
      _distressCallRef = _firestore.collection('distressCalls').doc(user.uid);
      currentUserId = user.uid;
    }

    _locationStreamSubscription = _firestore
        .collection('distressCalls')
        .snapshots()
        .listen((querySnapshot) {
      final markers = <Marker>[];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final double latitude = data['victimLocation'].latitude;
        final double longitude = data['victimLocation'].longitude;
        final double distance = calculateDistance(
            LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
            LatLng(latitude, longitude));
        final color = getColorBasedOnDistance(distance);
        final String documentId = doc.id;

        if (currentUserId != null && currentUserId == documentId){
          markers.add(
            Marker(
              width: 70.0,
              height: 70.0,
              point: LatLng(latitude, longitude),
              child: const Icon(
                Icons.person_pin_circle,
                color: Colors.blue,
              ),
            ),
          );
        }
        else{
          markers.add(
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(latitude, longitude),
              child: Icon(
                Icons.person_pin_circle,
                color: color,
              ),
            ),
          );
        }
      }
      setState(() {
        _mapMarkers.clear();
        _mapMarkers = markers;
      });
    });

    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLocation = locationData;
        if (_distressCallRef != null) {
          final victimLocation = GeoPoint(locationData.latitude!, locationData.longitude!);
          _distressCallRef!.update({'victimLocation': victimLocation});
        }
      });
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
    final maxDistance = 500.0;
    int maxOpacity = 255;
    final shade = maxOpacity * (1 - distance / maxDistance);
    int opacity = shade.toInt();
    return Color.fromARGB(opacity, 255, 0, 0);
  }

  void _centerOnMarker() {
    _mapController.move(
        LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
        _zoomLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end, // Align to bottom

        children: [
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
            Container( // Wrap SwitchListTile for size control
              width: 175, // Set a fixed width
              child: Builder( // Wrap with Builder for rebuild on state change
                builder: (context) => SwitchListTile(
                  tileColor: Colors.red,
                  title: Text(switchText),
                  value: isResponder,
                  onChanged: (bool value) {
                    setState(() {
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