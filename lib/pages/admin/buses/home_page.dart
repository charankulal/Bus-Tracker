import 'package:bus_tracking_app/pages/admin/buses/add_bus_page.dart';
import 'package:flutter/material.dart';

class AdminBusHomePage extends StatefulWidget {
  @override
  _AdminBusHomePageState createState() => _AdminBusHomePageState();
}

class _AdminBusHomePageState extends State<AdminBusHomePage> {
  List<Map<String, String>> buses = [
    {"busNo": "KA-01-1234", "route": "Route A", "driver": "John Doe", "phone": "9876543210"},
    {"busNo": "KA-02-5678", "route": "Route B", "driver": "Mike Ross", "phone": "9123456780"},
    {"busNo": "KA-03-9876", "route": "Route C", "driver": "Sarah Lee", "phone": "9988776655"},
  ];

  void _editBus(int index) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Edit Bus ${buses[index]['busNo']}")));
  }

  void _deleteBus(int index) {
    setState(() {
      buses.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bus Deleted Successfully")));
  }

  void _addBus() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddBusPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin - Bus Management"), backgroundColor: Colors.brown.shade700),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: buses.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Bus No: ${buses[index]['busNo']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text("Route: ${buses[index]['route']}"),
                          Text("Driver: ${buses[index]['driver']}"),
                          Text("Phone: ${buses[index]['phone']}"),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                onPressed: () => _editBus(index),
                                child: Text("Edit", style: TextStyle(color: Colors.white)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                onPressed: () => _deleteBus(index),
                                child: Text("Delete", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50)),
              onPressed: _addBus,
              child: Text("Add Bus", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
