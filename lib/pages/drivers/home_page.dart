import 'package:bus_tracking_app/constants/utilities.dart';
import 'package:bus_tracking_app/services/drivers/driver.dart';
import 'package:flutter/material.dart';

class DriverHomeScreen extends StatefulWidget {
  final String driverId;
  DriverHomeScreen({required this.driverId});
  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  Map<String, dynamic>? routeData = {};
  Map<String, dynamic>? busData = {};
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

  @override
  void initState() {
    super.initState();
    _loadAssociatedRoute(widget.driverId);
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
                  'Bus number : ${busData?['bus_number']}',
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
                        routeData!['start_loc_name'].toString().split(',')[0],
                      ),
                    ),
                    Icon(Icons.swap_horiz),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        routeData!['end_loc_name'].toString().split(',')[0],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.black),
                    SizedBox(width: 5),
                    Text(dayMonth, style: TextStyle(color: Colors.black)),
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen.shade400,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Start Trip',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'End Trip',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[300],
              child: Center(
                child: Icon(Icons.map, size: 100, color: Colors.black54),
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
                    padding: EdgeInsets.symmetric(vertical: 12),
                    minimumSize: Size(double.infinity, 40),
                  ),
                  onPressed: () {},
                  child: Text('SOS', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
