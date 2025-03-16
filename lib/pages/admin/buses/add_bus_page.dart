import 'package:flutter/material.dart';

class AddBusPage extends StatefulWidget {
  @override
  _AddBusPageState createState() => _AddBusPageState();
}

class _AddBusPageState extends State<AddBusPage> {
  final TextEditingController _busNoController = TextEditingController();
  String? _selectedRoute;
  String? _selectedDriver;

  final List<String> _routes = ["Route A", "Route B", "Route C"];
  final List<String> _drivers = ["John Doe", "Mike Ross", "Sarah Lee"];

  void _saveBus() {
    if (_busNoController.text.isEmpty || _selectedRoute == null || _selectedDriver == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bus Added Successfully")));
    Navigator.pop(context);
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var warning_text ='The Mapping of Bus to the Specific Routes can be done in Route Management Section';
    return Scaffold(
      appBar: AppBar(title: Text("Add Bus"), backgroundColor: Colors.brown.shade700),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning, color: Colors.red,),
            Text(warning_text, maxLines: 4, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
            SizedBox(height: 40),
            Text("Bus Number", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: _busNoController,
              decoration: InputDecoration(
                hintText: "Enter Bus No",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: _saveBus,
                  child: Text("Save", style: TextStyle(color: Colors.white)),
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
