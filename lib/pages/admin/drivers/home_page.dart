import 'package:bus_tracking_app/pages/admin/drivers/add_driver_page.dart';
import 'package:bus_tracking_app/services/admin/driver.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminDriversHomePage extends StatefulWidget {
  @override
  _AdminDriversHomePageState createState() => _AdminDriversHomePageState();
}

class _AdminDriversHomePageState extends State<AdminDriversHomePage> {
  Stream? driverStream;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp phoneNumRegEx = RegExp(r'^[6-9]\d{9}$');
  final RegExp nameRegEx = RegExp(r"^[A-Za-z]+(?:[-' ][A-Za-z]+)*$");
  final RegExp passwordRegEx = RegExp(r"^(?=.*[A-Za-z])(?=.*\d).{8,}$");

  _loadDrivers() async {
    driverStream = await DriverDatabaseServices().getAllDrivers();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadDrivers();
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  void _deleteDriver(BuildContext context, String id) async {
    await DriverDatabaseServices()
        .deleteDriver(id)
        .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Driver is Deleted"),
              duration: Durations.short4,
            ),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to delete driver: ${error.toString()}"),
              duration: Duration(seconds: 1),
            ),
          );
        });
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
        backgroundColor: Colors.yellow.shade700,
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        color: Colors.yellow.shade100,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driver["name"]!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "📞 ${driver["phone"]}",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "🔒 ${driver["password"]}",
                                style: TextStyle(fontSize: 16),
                              ),

                              FutureBuilder(
                                future: DriverDatabaseServices()
                                    .getBusNumberByDriverId(driver["driverId"]),
                                builder: (
                                  context,
                                  AsyncSnapshot<String?> snapshot,
                                ) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text(
                                      "🚌 Bus No: : Loading...",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      "🚌 Bus No: : Error",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    );
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return Text(
                                      "🚌 Bus No: : Not Assigned",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      "🚌 Bus No: : ${snapshot.data}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    );
                                  }
                                },
                              ),
                              FutureBuilder(
                                future: DriverDatabaseServices()
                                    .getRouteNameByDriverId(driver["driverId"]),
                                builder: (
                                  context,
                                  AsyncSnapshot<String?> snapshot,
                                ) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text(
                                      "📍 Route: Loading...",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      "📍 Route: Error",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    );
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return Text(
                                      "📍 Route: Not Assigned",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      "📍 Route: ${snapshot.data}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    onPressed: () {
                                      _nameController.text = driver["name"];
                                      _phoneController.text = driver["phone"];
                                      _passwordController.text =
                                          driver["password"];
                                      editDriver(driver["driverId"]!);
                                    },
                                    child: Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.greenAccent,
                                    ),
                                    onPressed: () {
                                      if (driver["phone"] != null &&
                                          driver["phone"]!.isNotEmpty) {
                                        makePhoneCall(driver["phone"]!);
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Driver Phone number is not available!",
                                            ),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      "Call",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed:
                                        () => _deleteDriver(
                                          context,
                                          driver["driverId"]!,
                                        ),
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
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _addDriver(context),
              child: Text(
                "Add Driver",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future editDriver(String id) => showDialog(
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
                      "Edit Driver",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Driver Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 10.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_nameController.text.isEmpty ||
                          _phoneController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please fill all fields"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        return;
                      }
                      if (!nameRegEx.hasMatch(_nameController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please enter valid name"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        return;
                      }
                      if (!phoneNumRegEx.hasMatch(_phoneController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please enter valid phone number"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        return;
                      }
                      if (!passwordRegEx.hasMatch(_passwordController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please enter valid password"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        return;
                      }

                      Map<String, dynamic> updateInfo = {
                        "name": _nameController.text,
                        "phone": _phoneController.text,
                        "password": _passwordController.text,
                      };
                      await DriverDatabaseServices()
                          .updateDriver(id, updateInfo)
                          .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Driver details updated successfully",
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            Navigator.pop(context);
                          })
                          .catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Failed to edit driver details: ${error.toString()}",
                                ),
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
