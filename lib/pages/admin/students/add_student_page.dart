import 'package:bus_tracking_app/services/admin/students.dart';
import 'package:flutter/material.dart';

class AddStudentPage extends StatefulWidget {
  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRoute;
  List<Map<String, dynamic>> _routesList = [];

  @override
  void initState() {
    super.initState();
    fetchRoutes();
  }

  void fetchRoutes() async {
    _routesList = await StudentsDatabaseServices().getAllRoutesIDName();
    setState(() {});
  }

  void _addStudent() async {
    final RegExp phoneNumRegEx = RegExp(r'^[6-9]\d{9}$');
    final RegExp nameRegEx = RegExp(r"^[A-Za-z]+(?:[-' ][A-Za-z]+)*$");
    final RegExp passwordRegEx = RegExp(r"^(?=.*[A-Za-z])(?=.*\d).{8,}$");

    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _selectedRoute == null) {
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

    Map<String, dynamic> studentInfo = {
      "name": _nameController.text,
      "phone": _phoneController.text,
      "password": _passwordController.text,
      "route": _selectedRoute,
    };
    await StudentsDatabaseServices()
        .addStudent(studentInfo)
        .then((value) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Student Details Added Successfully"),
              duration: Duration(seconds: 1),
            ),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Failed to add student details: ${error.toString()}",
              ),
              duration: Duration(seconds: 1),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Student"),
        backgroundColor: Colors.yellow.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Student Name",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Enter student's name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),

              Text(
                "Parent's Phone Number",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Enter phone number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              Text(
                "Password",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),

              Text(
                "Select Route",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedRoute ?? "qwerty",
                items: [
                  DropdownMenuItem<String>(
                    value: 'qwerty',
                    child: Text(
                      "Select Route",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ..._routesList.map((route) {
                    return DropdownMenuItem<String>(
                      value: route["routeId"],
                      child: Text(route["route_name"]),
                    );
                  }).toList(),
                ],
                onChanged: (value) => setState(() => _selectedRoute = value),
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _addStudent();
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
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
