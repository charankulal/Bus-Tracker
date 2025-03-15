import 'package:bus_tracking_app/pages/drivers/home_page.dart';
import 'package:bus_tracking_app/pages/parents/home_page.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _selectedRole = 'Parent';
  TextEditingController _childNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey, Colors.transparent],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            CircleAvatar(
              radius: 100,
              foregroundImage: AssetImage('assets/logo.jpg'),
            ),
            SizedBox(height: 10),
            Text(
              'SmartBus',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'Bus Tracking Application',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, color: Colors.white),
                SizedBox(width: 5),
                Text('05/10', style: TextStyle(color: Colors.white)),
                SizedBox(width: 10),
                Icon(Icons.location_on, color: Colors.white),
                SizedBox(width: 5),
                Text('Ujire', style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(height: 40),
            Text('Login As', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
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
                  controller: _childNameController,
                  decoration: InputDecoration(
                    labelText: 'Name of Child',
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
                  controller: _childNameController,
                  decoration: InputDecoration(
                    labelText: 'Bus No',
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
                  controller: _childNameController,
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
                backgroundColor: Colors.grey,
              ),
              onPressed: () {

                if(_selectedRole=='Parent'){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ParentHomeScreen()),
                  );
                }
                if(_selectedRole=='Driver'){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DriverHomeScreen()),
                  );
                }
              },
              child: Text(
                "Submit",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}