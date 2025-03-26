import 'package:bus_tracking_app/pages/admin/home_page.dart';
import 'package:bus_tracking_app/pages/drivers/home_page.dart';
import 'package:bus_tracking_app/pages/parents/home_page.dart';
import 'package:bus_tracking_app/services/login/admin_login.dart';
import 'package:bus_tracking_app/services/login/driver_login.dart';
import 'package:flutter/material.dart';

import '../constants/utilities.dart';
import '../services/login/parent_login.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  String _selectedRole = 'Parent';
  bool _isKeyboardOpen = false;
  TextEditingController _parentPhoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _driverPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    setState(() {
      _isKeyboardOpen = bottomInset > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.yellow.shade50, Colors.yellowAccent.shade700],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            if(!_isKeyboardOpen) ...[
            CircleAvatar(
              radius: 100,
              foregroundImage: AssetImage('assets/logo.jpg'),
            ),
            SizedBox(height: 10),
            Text(
              'SmartBus',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              'Bus Tracking Application',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, color: Colors.black),
                SizedBox(width: 5),
                Text(dayMonth, style: TextStyle(color: Colors.black)),
            ]

            ),
            SizedBox(height: 40),
            ],
            Text('Login As', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: _isKeyboardOpen ?
              Text(_selectedRole,
              style: TextStyle(
                fontSize: 14
              ),
              ):
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedRole,
                  items: ['Parent', 'Driver', 'Admin'].map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),
              ),
            ),
            if (_selectedRole == 'Parent') ...[
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _parentPhoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],

            if (_selectedRole == 'Driver') ...[
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _driverPhoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],

            if (_selectedRole == 'Admin') ...[
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () async {

                if(_selectedRole=='Parent'){
                  if (_passwordController.text.isEmpty ||
                      _parentPhoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Phone or Password cannot be empty!"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    return;
                  }
                  String enteredPassword = _passwordController.text.trim();
                  String enteredPhone = _parentPhoneController.text.trim();
                  final studentId = await StudentLoginDatabaseServices()
                      .authenticateParent(enteredPhone, enteredPassword);
                  if (studentId == null || studentId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Invalid Credentials!"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    return;
                  }
                  else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ParentHomeScreen(studentId: studentId)),
                    );
                  }
                }
                if(_selectedRole=='Driver') {
                  if (_passwordController.text.isEmpty ||
                      _driverPhoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Phone or Password cannot be empty!"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    return;
                  }
                  String enteredPassword = _passwordController.text.trim();
                  String enteredPhone = _driverPhoneController.text.trim();
                  final driverId = await DriverLoginDatabaseServices()
                      .authenticateDriver(enteredPhone, enteredPassword);
                  if (driverId == null || driverId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Invalid Credentials!"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    return;
                  }
                  else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DriverHomeScreen(driverId: driverId)),
                    );
                  }
                }
                if (_selectedRole == 'Admin') {
                  if (_passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Password cannot be empty!"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    return;
                  }

                    String enteredPassword = _passwordController.text.trim();
                    List<String> adminPasswords = await AdminLoginServices().getAllAdminPasswords();

                    if (adminPasswords.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error retrieving admin credentials!"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    if (adminPasswords.contains(enteredPassword)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Login Successful"),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AdminHomeScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Incorrect Password!"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }

              },
              child: Text(
                "Submit",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}