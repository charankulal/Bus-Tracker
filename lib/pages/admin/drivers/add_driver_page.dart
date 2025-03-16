import 'package:flutter/material.dart';

class AddDriverPage extends StatefulWidget {
  @override
  _AddDriverPageState createState() => _AddDriverPageState();
}

class _AddDriverPageState extends State<AddDriverPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedBus;
  String? _selectedRoute;

  final List<String> buses = ["KA-01-1234", "KA-02-5678", "KA-03-9876"];
  final List<String> routes = ["Route A", "Route B", "Route C"];

  void _addDriver() {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || _selectedBus == null || _selectedRoute == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Driver Added Successfully")));
    Navigator.pop(context); // Navigate back to Admin Drivers Home Page
  }

  void _cancel() {
    Navigator.pop(context); // Navigate back without saving
  }

  @override
  Widget build(BuildContext context) {
    var warning_text ='The Mapping of Driver to the Specific Routes and Bus can be done in Route Management Section';
    return Scaffold(
      appBar: AppBar(title: Text("Add Driver"), backgroundColor: Colors.brown.shade700),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning, color: Colors.red,),
            Text(warning_text, maxLines: 4, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
            SizedBox(height: 40),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Driver Name", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Phone Number", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: _addDriver,
                  child: Text("Add", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _cancel,
                  child: Text("Cancel", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
