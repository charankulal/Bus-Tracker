import 'package:bus_tracking_app/constants/utilities.dart';
import 'package:bus_tracking_app/pages/admin/buses/home_page.dart';
import 'package:bus_tracking_app/pages/admin/drivers/home_page.dart';
import 'package:bus_tracking_app/pages/admin/routes/home_page.dart';
import 'package:bus_tracking_app/pages/admin/students/home_page.dart';
import 'package:bus_tracking_app/pages/login_page.dart';
import 'package:bus_tracking_app/services/admin/bus.dart';
import 'package:bus_tracking_app/services/admin/driver.dart';
import 'package:bus_tracking_app/services/admin/routes.dart';
import 'package:flutter/material.dart';
import '../../services/admin/students.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int totalStudents = 0;
  int totalBuses = 0;
  int totalRoutes = 0;
  int totalDrivers = 0;

  @override
  void initState() {
    super.initState();
    getCount();
  }

  getCount() async{
    totalStudents = await StudentsDatabaseServices().getTotalStudents();
    totalRoutes = await RoutesDatabaseService().getTotalRoutes();
    totalDrivers = await DriverDatabaseServices().getTotalDrivers();
    totalBuses = await BusDatabaseMethods().getTotalBuses();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.yellow.shade700, Colors.yellow.shade300],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SmartBus Admin',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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
              ],
            ),
          ),
          SizedBox(height: 20),

          // Admin Options
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildAdminOption(context, 'Students',totalStudents, Icons.school, Colors.blue.shade300),
                _buildAdminOption(context, 'Routes',totalRoutes, Icons.map, Colors.green.shade300),
                _buildAdminOption(context, 'Drivers',totalDrivers, Icons.directions_bus, Colors.orange.shade300),
                _buildAdminOption(context, 'Buses',totalBuses, Icons.directions_transit, Colors.red.shade300),
              ],
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
            ),
            onPressed: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text(
              "Log out",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget _buildAdminOption(BuildContext context, String title,int total, IconData icon, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.all(20),
      ),
      onPressed: () {
        if(title=='Students'){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminStudentsHomePage()),
          );
        }
        if(title=='Routes'){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminRoutesHomePage()),
          );
        }
        if(title=='Drivers'){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminDriversHomePage()),
          );
        }
        if(title=='Buses'){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminBusHomePage()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.black),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontSize: 18, color: Colors.black)),
          SizedBox(height: 10),
          Text("Total "+title+" "+total.toString(), style: TextStyle(fontSize: 12, color: Colors.black)),
        ],
      ),
    );
  }
}
