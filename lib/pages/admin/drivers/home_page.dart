import 'package:bus_tracking_app/pages/admin/drivers/add_driver_page.dart';
import 'package:bus_tracking_app/services/admin/driver.dart';
import 'package:flutter/material.dart';

class AdminDriversHomePage extends StatefulWidget{
  @override
  _AdminDriversHomePageState createState() => _AdminDriversHomePageState();
}

class _AdminDriversHomePageState extends State<AdminDriversHomePage> {
  Stream? driverStream;


  _loadDrivers() async {
    driverStream = await DriverDatabaseServices().getAllDrivers();
    setState(() {}); // Triggers UI update
  }

  @override
  void initState() {
    super.initState();
    _loadDrivers();
  }

  void _editDriver(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Edit $name"),duration: Durations.short4,));
  }

  void _deleteDriver(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$name Deleted"),duration: Durations.short4,));
  }

  void _addDriver(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDriverPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drivers"),
        backgroundColor: Colors.brown.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
        child: StreamBuilder(
    stream: driverStream,
    builder: (context, AsyncSnapshot snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }

      var drivers = snapshot.data.docs;
      if (drivers.isEmpty) {
        return Center(
          child: Text(
            "No drivers available",
            style: TextStyle(fontSize: 16),
          ),
        );
      }
      return ListView.builder(
        itemCount: drivers.length,
        itemBuilder: (context, index) {
          final driver = drivers[index];
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(driver["name"]!, style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("📞 ${driver["phone"]}", style: TextStyle(fontSize: 16)),
                  Text("🚌 Bus No: ",
                      style: TextStyle(fontSize: 16)),
                  Text("📍 Route: ",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () => _editDriver(context, driver["driverId"]!),
                        child: Text(
                            "Edit", style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () =>
                            _deleteDriver(context, driver["driverId"]!),
                        child: Text(
                            "Delete", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    },
        )
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _addDriver(context),
              child: Text("Add Driver", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
