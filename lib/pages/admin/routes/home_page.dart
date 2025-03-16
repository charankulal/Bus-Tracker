import 'package:bus_tracking_app/pages/admin/routes/add_routes_page.dart';
import 'package:flutter/material.dart';

class AdminRoutesHomePage extends StatefulWidget {
  @override
  _AdminRoutesHomePageState createState() => _AdminRoutesHomePageState();
}

class _AdminRoutesHomePageState extends State<AdminRoutesHomePage> {
  final List<Map<String, String>> _routes = [
    {
      "routeName": "Route A",
      "startLocation": "City Center",
      "endLocation": "North Avenue",
      "busNo": "KA-01-1234",
      "driverName": "John Doe",
      "driverPhone": "9876543210"
    },
    {
      "routeName": "Route B",
      "startLocation": "South Park",
      "endLocation": "East Square",
      "busNo": "KA-02-5678",
      "driverName": "Michael Smith",
      "driverPhone": "9876509876"
    },{
      "routeName": "Route B",
      "startLocation": "South Park",
      "endLocation": "East Square",
      "busNo": "KA-02-5678",
      "driverName": "Michael Smith",
      "driverPhone": "9876509876"
    },{
      "routeName": "Route B",
      "startLocation": "South Park",
      "endLocation": "East Square",
      "busNo": "KA-02-5678",
      "driverName": "Michael Smith",
      "driverPhone": "9876509876"
    }
  ];

  void _editRoute(int index) {
    // Edit route logic
  }

  void _deleteRoute(int index) {
    setState(() {
      _routes.removeAt(index);
    });
  }

  void _addRoute() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddRoutePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Routes"),
        backgroundColor: Colors.brown.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _routes.length,
                itemBuilder: (context, index) {
                  final route = _routes[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(route["routeName"]!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("Start: ${route["startLocation"]}"),
                          Text("End: ${route["endLocation"]}"),
                          Text("Bus No: ${route["busNo"]}"),
                          Text("Driver: ${route["driverName"]}"),
                          Text("Phone: ${route["driverPhone"]}"),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                onPressed: () => _editRoute(index),
                                icon: Icon(Icons.edit, color: Colors.white),
                                label: Text("Edit", style: TextStyle(color: Colors.white)),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                onPressed: () => _deleteRoute(index),
                                icon: Icon(Icons.delete, color: Colors.white),
                                label: Text("Delete", style: TextStyle(color: Colors.white)),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _addRoute,
              child: Text("Add Route", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
