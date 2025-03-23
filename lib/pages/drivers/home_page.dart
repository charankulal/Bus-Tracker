import 'dart:async';
import 'package:bus_tracking_app/constants/secrets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bus_tracking_app/constants/utilities.dart';
import 'package:bus_tracking_app/services/drivers/driver.dart';

class DriverHomeScreen extends StatefulWidget {
  final String driverId;
  DriverHomeScreen({required this.driverId});

  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Position? _currentPosition;
  Map<String, dynamic>? routeData;
  Map<String, dynamic>? busData;
  StreamSubscription<Position>? _positionStream;
  bool isTracking = false;
  Timer? _timer;
  static const LatLng sourceLocation = LatLng(12.9954759, 75.3289337);
  static const LatLng endLocation = LatLng(12.9496336, 75.1870479);
  List<LatLng> polylineCoordinates =[];

  @override
  void initState() {
    super.initState();
    _loadAssociatedRoute(widget.driverId);
    _checkPermissions();
    getPolyPoints();
  }

  Future<void> _checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
    }
  }

  _loadAssociatedRoute(String driverId) async {
    routeData = await DriverHomePageDatabaseServices().getRouteByDriverId(
      driverId,
    );
    if (routeData != null) {
      busData = await DriverHomePageDatabaseServices().getBusByBusId(
        routeData!['busId'],
      );
    }
    setState(() {});
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: google_api_key_places,
      request: PolylineRequest(
        origin: PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        destination: PointLatLng(endLocation.latitude, endLocation.longitude),
        mode: TravelMode.driving,
      ),
    );

    if(result.points.isNotEmpty){
      result.points.forEach((PointLatLng point)=> polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {

      });
    }

  }

  _startTrip() async {
    isTracking = true;
    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
        _markers.add(
          Marker(
            markerId: MarkerId("driver"),
            position: LatLng(position.latitude, position.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
            infoWindow: InfoWindow(title: "Driver's Current Location"),
          ),
        );
      });
      _sendLocationToFirestore(position);
    });

    _timer = Timer.periodic(Duration(seconds: 30), (Timer t) {
      if (_currentPosition != null) {
        _sendLocationToFirestore(_currentPosition!);
      }
    });
  }

  _sendLocationToFirestore(Position position) {
    FirebaseFirestore.instance.collection('driver_tracking').add({
      'driverId': widget.driverId,
      'busId': routeData?['busId'],
      'routeId': routeData?['routeId'],
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  _endTrip() {
    isTracking = false;
    _positionStream?.cancel();
    _timer?.cancel();
    setState(() {});
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade400,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SmartBus',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      foregroundImage: AssetImage('assets/logo.jpg'),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  'Bus number : ${busData?['bus_number'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        routeData?['start_loc_name']?.toString().split(
                              ',',
                            )[0] ??
                            'Start',
                      ),
                    ),
                    Icon(Icons.swap_horiz),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        routeData?['end_loc_name']?.toString().split(',')[0] ??
                            'End',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7, // Adjust height
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: sourceLocation,
                  zoom: 10,
                ),
                polylines: {
                  Polyline(polylineId: PolylineId("routes"),
                    points: polylineCoordinates
                  )
                },
                markers: {
                  Marker(
                    markerId: MarkerId("source"),
                    position: sourceLocation,
                  ),
                  Marker(
                    markerId: MarkerId("destination"),
                    position: endLocation,
                  ),
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: isTracking ? null : _startTrip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text('Start Trip'),
                ),
                ElevatedButton(
                  onPressed: isTracking ? _endTrip : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('End Trip'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
