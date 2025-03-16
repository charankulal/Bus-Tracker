import 'package:bus_tracking_app/services/admin/bus.dart';
import 'package:flutter/material.dart';

class AddBusPage extends StatefulWidget {
  @override
  _AddBusPageState createState() => _AddBusPageState();
}

class _AddBusPageState extends State<AddBusPage> {
  final TextEditingController _busNoController = TextEditingController();

  void _saveBus() async {
    RegExp busNumberRegex = RegExp(r'^[A-Za-z]{2} \d{2}[ ]{0,1}[A-Za-z]{0,2} \d{4}$');

    if (_busNoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields"),
          duration: Duration( seconds: 1),
        ),
      );
      return;
    }
    if (!busNumberRegex.hasMatch(_busNoController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bus Number is Invalid"),
          duration: Duration( seconds: 1),
        ),
      );
      return;
    }

    Map<String, dynamic> busInfo = {"bus_number": _busNoController.text};
    await BusDatabaseMethods().addBus(busInfo).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Bus Details Added Successfully"),
          duration: Duration(seconds: 1),
        ),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to add bus details: ${error.toString()}"),
          duration: Duration(seconds: 1),
        ),
      );
    });

  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var warning_text =
        'The Mapping of Bus to the Specific Routes can be done in Route Management Section';
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Bus"),
        backgroundColor: Colors.brown.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning, color: Colors.red),
            Text(
              warning_text,
              maxLines: 4,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 40),
            Text(
              "Bus Number",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              textCapitalization: TextCapitalization.characters,
              controller: _busNoController,
              decoration: InputDecoration(
                hintText: "Enter Bus No",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
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
