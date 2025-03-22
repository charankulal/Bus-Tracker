import 'package:bus_tracking_app/pages/admin/students/add_student_page.dart';
import 'package:bus_tracking_app/pages/admin/students/edit_student_page.dart';
import 'package:bus_tracking_app/services/admin/routes.dart';
import 'package:bus_tracking_app/services/admin/students.dart';
import 'package:flutter/material.dart';

import '../../../services/admin/driver.dart';

class AdminStudentsHomePage extends StatefulWidget {
  @override
  _AdminStudentsHomePageState createState() => _AdminStudentsHomePageState();
}

class _AdminStudentsHomePageState extends State<AdminStudentsHomePage> {
  Stream? studentStream;

  _loadDrivers() async {
    studentStream = await StudentsDatabaseServices().getAllStudents();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadDrivers();
  }

  void _deleteStudent(BuildContext context, String id) async {
    await StudentsDatabaseServices()
        .deleteStudent(id)
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Student is Deleted"),
          duration: Durations.short4,
        ),
      );
    })
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete student: ${error.toString()}"),
          duration: Duration(seconds: 1),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.yellow.shade700, Colors.yellow.shade300],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Students List',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Icon(Icons.people, size: 30, color: Colors.black),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          SizedBox(height: 10),

          // List of Students
          Expanded(
            child: StreamBuilder(
              stream: studentStream,
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var students = snapshot.data.docs;
                if (students.isEmpty) {
                  return Center(
                    child: Text(
                      "No drivers available",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      elevation: 3,
                      color: Colors.yellow.shade100,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student["name"]!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text("Parent's Phone: ${student["phone"]}"),
                            Text("Password: ${student["password"]}"),
                            FutureBuilder(
                              future: RoutesDatabaseService().getRouteById(student["route"]), // Call the function
                              builder: (context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Text("Loading route details...");
                                } else if (snapshot.hasError || snapshot.data == null) {
                                  return Text("Route details not found", style: TextStyle(color: Colors.red));
                                } else {
                                  // Extract route name and driverId
                                  String routeName = snapshot.data!['route_name'] ?? 'N/A';
                                  String driverId = snapshot.data!['driverId'] ?? 'N/A';

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Route Name: $routeName", style: TextStyle(fontWeight: FontWeight.bold)),
                                      FutureBuilder(
                                        future: DriverDatabaseServices()
                                            .getDriverNameById(driverId),
                                        builder: (
                                            context,
                                            AsyncSnapshot<String> snapshot,
                                            ) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Text(
                                              "Driver: Loading...",
                                            ); // Placeholder while fetching
                                          } else if (snapshot.hasError) {
                                            return Text(
                                              "Driver: Error",
                                            ); // Error handling
                                          } else {
                                            return Text(
                                              "Driver: ${snapshot.data}",
                                            ); // Display Bus Number
                                          }
                                        },
                                      ),
                                      FutureBuilder(
                                        future: DriverDatabaseServices()
                                            .getDriverPhoneById(driverId),
                                        builder: (
                                            context,
                                            AsyncSnapshot<String> snapshot,
                                            ) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Text(
                                              "Driver Phone: Loading...",
                                            ); // Placeholder while fetching
                                          } else if (snapshot.hasError) {
                                            return Text(
                                              "Driver Phone: Error",
                                            ); // Error handling
                                          } else {
                                            return Text(
                                              "Driver Phone: ${snapshot.data}",
                                            ); // Display Bus Number
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),


                            SizedBox(height: 8),
                            Divider(color: Colors.grey.shade300),
                            // Edit & Delete Buttons at the Bottom
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EditStudentPage(studentId: student['studentId'])),
                                    );
                                  },
                                  icon: Icon(Icons.edit, color: Colors.white),
                                  label: Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    _deleteStudent(
                                      context,
                                      student["studentId"]!,
                                    );
                                  },
                                  icon: Icon(Icons.delete, color: Colors.white),
                                  label: Text(
                                    'Delete',
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

          // Add New Student Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddStudentPage()),
                );
              },
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                'Add New Student',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
