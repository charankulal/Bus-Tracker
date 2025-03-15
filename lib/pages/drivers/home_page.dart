import 'package:flutter/material.dart';

class DriverHomeScreen extends StatefulWidget {
  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                          color: Colors.white),
                    ),
                    CircleAvatar(
                      radius: 30,
                      foregroundImage: AssetImage('assets/logo.jpg'),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  'Bus number : XXX2457',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
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
                Row(
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
                SizedBox(height: 10),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        ),
                        child: Text('Start Trip', style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox( width: MediaQuery.of(context).size.width * 0.15,),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        ),
                        child: Text('End Trip', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[300],
              child: Center(
                child: Icon(
                  Icons.map,
                  size: 100,
                  color: Colors.black54,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    minimumSize: Size(double.infinity, 40),
                  ),
                  onPressed: () {},
                  child: Text('SOS', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
