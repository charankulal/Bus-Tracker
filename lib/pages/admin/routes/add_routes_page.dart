import 'package:flutter/material.dart';

class AddRoutePage extends StatefulWidget {
  @override
  _AddRoutePageState createState() => _AddRoutePageState();
}

class _AddRoutePageState extends State<AddRoutePage> {
  final TextEditingController _routeNameController = TextEditingController();
  final TextEditingController _startLocationController = TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();

  String? _selectedBus;
  String? _selectedDriver;

  final List<String> _busNumbers = ["KA-01-1234", "KA-02-5678", "KA-03-9876"];
  final List<String> _drivers = ["John Doe", "Michael Smith", "David Johnson"];

  void _saveRoute() {
    if (_routeNameController.text.isNotEmpty &&
        _startLocationController.text.isNotEmpty &&
        _endLocationController.text.isNotEmpty &&
        _selectedBus != null &&
        _selectedDriver != null) {
      // Save Route Logic
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Route Added Successfully")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Route"),
        backgroundColor: Colors.yellow.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _routeNameController,
                decoration: InputDecoration(labelText: "Route Name", border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _startLocationController,
                decoration: InputDecoration(labelText: "Start Location", border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _endLocationController,
                decoration: InputDecoration(labelText: "End Location", border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedBus,
                items: _busNumbers.map((bus) {
                  return DropdownMenuItem(value: bus, child: Text(bus));
                }).toList(),
                onChanged: (value) => setState(() => _selectedBus = value),
                decoration: InputDecoration(labelText: "Select Bus", border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedDriver,
                items: _drivers.map((driver) {
                  return DropdownMenuItem(value: driver, child: Text(driver));
                }).toList(),
                onChanged: (value) => setState(() => _selectedDriver = value),
                decoration: InputDecoration(labelText: "Select Driver", border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 25),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      // Save Student Logic Here
                    },
                    child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 25),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
