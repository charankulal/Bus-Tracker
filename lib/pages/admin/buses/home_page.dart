import 'package:bus_tracking_app/pages/admin/buses/add_bus_page.dart';
import 'package:bus_tracking_app/services/admin/bus.dart';
import 'package:flutter/material.dart';

class AdminBusHomePage extends StatefulWidget {
  @override
  _AdminBusHomePageState createState() => _AdminBusHomePageState();
}

class _AdminBusHomePageState extends State<AdminBusHomePage> {
  Stream? busStream;
  TextEditingController _busNoController = new TextEditingController();

  _loadBuses() async {
    busStream = await BusDatabaseMethods().getAllBuses();
    setState(() {}); // Triggers UI update
  }
  @override
  void initState() {
    super.initState();
    _loadBuses();
  }

  void _deleteBus(String busId) async {
    await BusDatabaseMethods().deleteBus(busId);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Bus Deleted Successfully")));
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
      appBar: AppBar(
        title: Text("Admin - Bus Management"),
        backgroundColor: Colors.brown.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: busStream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var buses = snapshot.data.docs;
                  if (buses.isEmpty) {
                    return Center(
                      child: Text(
                        "No buses available",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: buses.length,
                    itemBuilder: (context, index) {
                      var busData = buses[index].data();
                      String busId = buses[index].id;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bus No: ${busData['bus_number'].toString().toUpperCase()}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text("Route:"),
                              Text("Driver:"),
                              Text("Phone: "),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    onPressed: () => {
                                      _busNoController.text = busData["bus_number"],
                                      editBus(busData['busId'])
                                    },
                                    child: Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () => _deleteBus(busId),
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
              ),
              onPressed: _addBus,
              child: Text(
                "Add Bus",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future editBus(String id) => showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height * 0.50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.cancel),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "Edit Bus",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Text(
                  "Bus Number",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    textCapitalization: TextCapitalization.characters,
                    controller: _busNoController,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),


                Center(
                  child: ElevatedButton(
                    onPressed: () async {
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

                      Map<String, dynamic> updateInfo = {
                        "bus_number": _busNoController.text,
                      };
                      await BusDatabaseMethods().updateBus(id, updateInfo).then((
                        value,
                      ) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Bus details updated successfully"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        Navigator.pop(context);
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Failed to edit bus details: ${error.toString()}"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      });
                    },
                    child: Text("Update"),
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}
