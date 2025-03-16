import 'package:bus_tracking_app/pages/admin/drivers/add_driver_page.dart';
import 'package:flutter/material.dart';

class AdminDriversHomePage extends StatelessWidget {
  final List<Map<String, String>> drivers = [
    {"name": "John Doe", "phone": "9876543210", "bus": "KA-01-1234", "route": "Route A"},
    {"name": "Michael Smith", "phone": "8765432109", "bus": "KA-02-5678", "route": "Route B"},
    {"name": "David Johnson", "phone": "7654321098", "bus": "KA-03-9876", "route": "Route C"},
  ];

  void _editDriver(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Edit $name")));
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
              child: ListView.builder(
                itemCount: drivers.length,
                itemBuilder: (context, index) {
                  final driver = drivers[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(driver["name"]!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("📞 ${driver["phone"]}", style: TextStyle(fontSize: 16)),
                          Text("🚌 Bus No: ${driver["bus"]}", style: TextStyle(fontSize: 16)),
                          Text("📍 Route: ${driver["route"]}", style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                onPressed: () => _editDriver(context, driver["name"]!),
                                child: Text("Edit", style: TextStyle(color: Colors.white)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                onPressed: () => _deleteDriver(context, driver["name"]!),
                                child: Text("Delete", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          )
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
