import 'package:bus_tracking_app/constants/utilities.dart';
import 'package:flutter/material.dart';

class ParentHomeScreen extends StatefulWidget {
  final String studentId;
  ParentHomeScreen({required this.studentId});
  @override
  _ParentHomeScreenState createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade400,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SmartBus',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        CircleAvatar(
                          radius: 30,
                          foregroundImage: AssetImage('assets/logo.jpg'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'ALERT! : Bus arrives in 5 minutes',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.black),
                        SizedBox(width: 5),
                        Text(dayMonth, style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Sidhavana'),
                        ),
                        Icon(Icons.swap_horiz),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Karkala'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Estimated Arrival Time: 14:20',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: double.infinity,
                    height: _isExpanded ? MediaQuery.of(context).size.height : 200,
                    color: Colors.white54,
                    child: Center(
                      child: Icon(
                        Icons.map,
                        size: 50,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Log out'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400),
                      onPressed: () {},
                      child: Text('Call Driver', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isExpanded)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = false;
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: Icon(
                      Icons.map,
                      size: 100,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
