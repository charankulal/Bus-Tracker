import 'dart:async';

import 'package:bus_tracking_app/constants/utilities.dart';
import 'package:bus_tracking_app/services/admin/driver.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/drivers/driver.dart';
import '../../services/students/students.dart';

class ParentHomeScreen extends StatefulWidget {
  final String studentId;
  ParentHomeScreen({required this.studentId});
  @override
  _ParentHomeScreenState createState() => _ParentHomeScreenState();
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $launchUri';
  }
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  Map<String, dynamic>? studentData;
  Map<String, dynamic>? routeData;
  Map<String, dynamic>? busData;
  Map<String, dynamic>? trackingData;
  static LatLng currentLocation = LatLng(0.0, 0.0);
  String? driverName;
  String? driverPhone;
  bool? isDriverActive = false;

  fetchStudents() async {
    studentData = await ParentDatabaseServices().getStudentById(
      widget.studentId,
    );
    setState(() {});
  }

  loadAssociatedRoute() async {
    routeData = await ParentDatabaseServices().getRouteById(
      studentData?['route'],
    );
    if (routeData != null) {
      busData = await DriverHomePageDatabaseServices().getBusByBusId(
        routeData!['busId'],
      );
      driverName = await DriverDatabaseServices().getDriverNameById(
        routeData!['driverId'],
      );
      driverPhone = await DriverDatabaseServices().getDriverPhoneById(
        routeData!['driverId'],
      );
      trackingData = await ParentDatabaseServices().getDriverLocation(
        routeData!['driverId'],
      );

      await fetchDriverLocationStatus();
    }
    setState(() {});
  }

  fetchDriverLocationStatus() async {
    if (routeData == null) return;

    trackingData = await ParentDatabaseServices().getDriverLocation(
      routeData!['driverId'],
    );

    if (trackingData != null) {
      if (trackingData?['status'] == "Active") {
        isDriverActive = true;

        setState(() {
          currentLocation = LatLng(
            trackingData?['latitude'] ?? 0.0, // Ensure it's not null
            trackingData?['longitude'] ?? 0.0,
          );
        });
      } else {
        setState(() {
          isDriverActive = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndLoadData();
    Timer.periodic(Duration(seconds: 30), (timer) {
      fetchDriverLocationStatus();
    });
  }

  Future<void> fetchAndLoadData() async {
    await fetchStudents();
    await loadAssociatedRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade400,
      body: Stack(
        children: [
          Column(
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
                    SizedBox(height: 10),
                    Text(
                      studentData != null ? 'Hi, ${studentData!['name']}' : '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.black),
                        SizedBox(width: 5),
                        Text(dayMonth, style: TextStyle(color: Colors.black)),
                        SizedBox(width: 5),
                        Icon(Icons.person, color: Colors.black),
                        SizedBox(width: 5),
                        Text(
                          driverName != null
                              ? 'Driver: ${driverName}'
                              : 'Loading',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
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
                            routeData?['end_loc_name']?.toString().split(
                                  ',',
                                )[0] ??
                                'End',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      busData != null
                          ? 'Bus Number: ${busData?['bus_number']} '
                          : 'Bus Number: Loading',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  height:
                      MediaQuery.of(context).size.height * 0.4, // Adjust height
                  child: Center(
                    child:
                        isDriverActive == false
                            ? CircularProgressIndicator() // Show loading until location is fetched
                            : GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: currentLocation,
                                zoom: 13,
                              ),

                              markers: {
                                Marker(
                                  markerId: const MarkerId("currentLocation"),
                                  position: currentLocation,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueBlue,
                                  ),
                                ),
                              },
                            ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Log out'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                      ),
                      onPressed: () {
                        if (driverPhone != null && driverPhone!.isNotEmpty) {
                          makePhoneCall(driverPhone!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Driver Phone number is not available!",
                              ),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Call Driver',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
