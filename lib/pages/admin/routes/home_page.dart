import 'package:bus_tracking_app/pages/admin/routes/add_routes_page.dart';
import 'package:bus_tracking_app/services/admin/driver.dart';
import 'package:bus_tracking_app/services/admin/routes.dart';
import 'package:flutter/material.dart';
import '../../../services/admin/bus.dart';
import 'edit_routes.dart';

class AdminRoutesHomePage extends StatefulWidget {
  @override
  _AdminRoutesHomePageState createState() => _AdminRoutesHomePageState();
}

class _AdminRoutesHomePageState extends State<AdminRoutesHomePage> {
  Stream? routeStream;

  void _editRoute(String routeId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditRoutePage(routeId: routeId)),
    );
  }

  _loadRoutes() async {
    routeStream = await RoutesDatabaseService().getAllRoutes();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  void _deleteRoute(BuildContext context, String id) async {
    await RoutesDatabaseService()
        .deleteRoute(id)
        .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Route is deleted"),
              duration: Durations.short4,
            ),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to delete route: ${error.toString()}"),
              duration: Duration(seconds: 1),
            ),
          );
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
        backgroundColor: Colors.yellow.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: routeStream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var routes = snapshot.data.docs;
                  if (routes.isEmpty) {
                    return Center(
                      child: Text(
                        "No Routes available",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: routes.length,
                    itemBuilder: (context, index) {
                      final route = routes[index];
                      return Card(
                        elevation: 3,
                        color: Colors.yellow.shade100,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                route["route_name"]!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text("Start: ${route["start_loc_name"]}"),
                              Text("End: ${route["end_loc_name"]}"),
                              FutureBuilder(
                                future: BusDatabaseMethods().getBusNumberById(
                                  route["busId"],
                                ),
                                builder: (
                                  context,
                                  AsyncSnapshot<String> snapshot,
                                ) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text("Bus No: Loading...");
                                  } else if (snapshot.hasError) {
                                    return Text("Bus No: Error");
                                  } else {
                                    return Text("Bus No: ${snapshot.data}");
                                  }
                                },
                              ),
                              FutureBuilder(
                                future: DriverDatabaseServices()
                                    .getDriverNameById(route["driverId"]),
                                builder: (
                                  context,
                                  AsyncSnapshot<String> snapshot,
                                ) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text("Driver: Loading...");
                                  } else if (snapshot.hasError) {
                                    return Text("Driver: Error");
                                  } else {
                                    return Text("Driver: ${snapshot.data}");
                                  }
                                },
                              ),
                              FutureBuilder(
                                future: DriverDatabaseServices()
                                    .getDriverPhoneById(route["driverId"]),
                                builder: (
                                  context,
                                  AsyncSnapshot<String> snapshot,
                                ) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text("Driver Phone: Loading...");
                                  } else if (snapshot.hasError) {
                                    return Text("Driver Phone: Error");
                                  } else {
                                    return Text(
                                      "Driver Phone: ${snapshot.data}",
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    onPressed:
                                        () => _editRoute(route['routeId']),
                                    icon: Icon(Icons.edit, color: Colors.white),
                                    label: Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed:
                                        () => _deleteRoute(
                                          context,
                                          route['routeId'],
                                        ),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    label: Text(
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
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _addRoute,
              child: Text(
                "Add Route",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
