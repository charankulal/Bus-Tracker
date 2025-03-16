import 'package:bus_tracking_app/pages/admin/buses/home_page.dart';
import 'package:bus_tracking_app/pages/admin/drivers/home_page.dart';
import 'package:bus_tracking_app/pages/admin/routes/home_page.dart';
import 'package:bus_tracking_app/pages/admin/students/home_page.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
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
                colors: [Colors.brown.shade700, Colors.brown.shade300],
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
                        color: Colors.white,
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white),
                    SizedBox(width: 5),
                    Text('05/10', style: TextStyle(color: Colors.white)),
                    SizedBox(width: 10),
                    Icon(Icons.cloud, color: Colors.white),
                    SizedBox(width: 5),
                    Text('26°C', style: TextStyle(color: Colors.white)),
                    SizedBox(width: 10),
                    Icon(Icons.location_on, color: Colors.white),
                    SizedBox(width: 5),
                    Text('Ujire', style: TextStyle(color: Colors.white)),
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
                _buildAdminOption(context, 'Students',17, Icons.school, Colors.blue),
                _buildAdminOption(context, 'Routes',17, Icons.map, Colors.green),
                _buildAdminOption(context, 'Drivers',17, Icons.directions_bus, Colors.orange),
                _buildAdminOption(context, 'Buses',17, Icons.directions_transit, Colors.red),
              ],
            ),
          ),

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
            MaterialPageRoute(builder: (context) => StudentsHomePage()),
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
          Icon(icon, size: 50, color: Colors.white),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontSize: 18, color: Colors.white)),
          SizedBox(height: 10),
          Text("Total "+title+" "+total.toString(), style: TextStyle(fontSize: 10, color: Colors.white)),
        ],
      ),
    );
  }
}
