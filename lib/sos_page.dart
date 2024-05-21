import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class SendSOSPage extends StatefulWidget {
  const SendSOSPage({super.key});

  @override
  _SendSOSPageState createState() => _SendSOSPageState();
}

class _SendSOSPageState extends State<SendSOSPage> {
  late MapController _mapController;
  late LocationData _currentLocation;
  final double _zoomLevel = 16;
  late Location _location;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentReference? _distressCallRef;
  late List<Marker> _mapMarkers = [];
  StreamSubscription<QuerySnapshot>? _locationStreamSubscription;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _location = Location();
    _currentLocation =
        LocationData.fromMap({'latitude': 10.640960, 'longitude': 122.237747});

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
              child: const Icon(
                Icons.person_pin_circle,
                color: Colors.red,
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

  void _centerOnMarker() {
    _mapController.move(
        LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
        _zoomLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Send SOS'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Add action for the profile icon here
            },
          ),
          const Expanded(
            child: Center(
              child: Text(
                'HERA',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  child: Text('Preferences'),
                ),
                const PopupMenuItem(
                  child: Text('Guide'),
                ),
                const PopupMenuItem(
                  child: Text('About the Developer'),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _centerOnMarker,
            child: const Icon(Icons.my_location),
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

                urlTemplate: 'https://tile-{s}.openstreetmap.fr/hot/{z}/{x}/{y}.png',
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red[300],
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Microphone',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}