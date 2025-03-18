import 'package:bus_tracking_app/services/admin/driver.dart';
import 'package:flutter/material.dart';

class AddDriverPage extends StatefulWidget {
  @override
  _AddDriverPageState createState() => _AddDriverPageState();
}

class _AddDriverPageState extends State<AddDriverPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _addDriver() async {
    final RegExp phoneNumRegEx = RegExp(r'^[6-9]\d{9}$');
    final RegExp nameRegEx = RegExp(r"^[A-Za-z]+(?:[-' ][A-Za-z]+)*$");

    if (_nameController.text.isEmpty || _phoneController.text.isEmpty ) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields"), duration: Duration(seconds: 1),));
      return;
    }
    if (!nameRegEx.hasMatch(_nameController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter valid name"), duration: Duration(seconds: 1),));
      return;
    }
    if (!phoneNumRegEx.hasMatch(_phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter valid phone number"), duration: Duration(seconds: 1),));
      return;
    }

    Map<String, dynamic> driverInfo = {"name": _nameController.text, "phone":_phoneController.text};
    await DriverDatabaseServices().addDriver(driverInfo).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Driver Details Added Successfully"),
          duration: Duration(seconds: 1),
        ),
      );

    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to add driver details: ${error.toString()}"),
          duration: Duration(seconds: 1),
        ),
      );
    });
  }

  void _cancel() {
    Navigator.pop(context); // Navigate back without saving
  }

  @override
  Widget build(BuildContext context) {
    var warning_text ='The Mapping of Driver to the Specific Routes and Bus can be done in Route Management Section';
    return Scaffold(
      appBar: AppBar(title: Text("Add Driver"), backgroundColor: Colors.yellow.shade700),
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
