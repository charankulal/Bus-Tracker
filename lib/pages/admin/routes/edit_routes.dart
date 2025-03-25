import 'package:bus_tracking_app/constants/secrets.dart';
import 'package:bus_tracking_app/services/admin/bus.dart';
import 'package:bus_tracking_app/services/admin/driver.dart';
import 'package:bus_tracking_app/services/admin/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class EditRoutePage extends StatefulWidget {
  final String routeId;
  EditRoutePage({required this.routeId});
  @override
  _EditRoutePageState createState() => _EditRoutePageState();
}

class _EditRoutePageState extends State<EditRoutePage> {
  final TextEditingController _routeNameController = TextEditingController();
  final TextEditingController _startLocationController = TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();
  final FocusNode _startLocationFocusNode = FocusNode();
  final FocusNode _endLocationFocusNode = FocusNode();

  Map<String, double>? _startLocation;
  Map<String, double>? _endLocation;
  String? _selectedBusId;
  String? _selectedDriverId;
  List<Map<String, dynamic>> _driversList = [];
  List<Map<String, dynamic>> _busList = [];

  @override
  void initState() {
    super.initState();
    _fetchRouteDetails();
    fetchDrivers();
    fetchBuses();
  }

  void _fetchRouteDetails() async {
    var routeData = await RoutesDatabaseService().getRouteById(widget.routeId);
    setState(() {
      _routeNameController.text = routeData?["route_name"] ?? "";
      _startLocationController.text = routeData?["start_loc_name"] ?? "";
      _endLocationController.text = routeData?["end_loc_name"] ?? "";
      _selectedBusId = routeData?["busId"]??"";
      _selectedDriverId = routeData?["driverId"]??"";
      _startLocation = {
        "latitude": routeData?["start_location"]?["latitude"],
        "longitude": routeData?["start_location"]?["longitude"]
      };
      _endLocation = {
        "latitude": routeData?["end_location"]?["latitude"],
        "longitude": routeData?["end_location"]?["longitude"]
      };
    });
  }

  void fetchDrivers() async {
    _driversList = await DriverDatabaseServices().getUnassociatedDrivers();

    if (_selectedDriverId != null) {
      var _selectedDriver = await DriverDatabaseServices().getDriverNameById(_selectedDriverId!);
      Map<String, dynamic> selectedDriverInfo = {"driverId": _selectedDriverId, "name": _selectedDriver};
      _driversList.add(selectedDriverInfo);
    }

    setState(() {});
  }

  void fetchBuses() async {
    _busList = await BusDatabaseMethods().getUnassociatedBuses();

    if (_selectedBusId != null) {
      var _selectedBus = await BusDatabaseMethods().getBusNumberById(_selectedBusId!);
      Map<String, dynamic> selectedBusInfo = {"busId": _selectedBusId, "bus_number": _selectedBus};
      _busList.add(selectedBusInfo);
    }

    setState(() {});
  }

  void _updateRoute() async {
    if (_routeNameController.text.isNotEmpty &&
        _startLocationController.text.isNotEmpty &&
        _endLocationController.text.isNotEmpty &&
        _selectedBusId != null &&
        _selectedDriverId != null) {
      Map<String, dynamic> _routeInfo = {
        "route_name": _routeNameController.text,
        "start_loc_name": _startLocationController.text,
        "end_loc_name": _endLocationController.text,
        "start_location": _startLocation,
        "end_location": _endLocation,
        "busId": _selectedBusId,
        "driverId": _selectedDriverId,
      };
      await RoutesDatabaseService()
          .updateRoute(widget.routeId, _routeInfo)
          .then((value) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Route Updated Successfully"),
            duration: Duration(seconds: 1),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update route details: ${error.toString()}"),
            duration: Duration(seconds: 1),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please fill all fields")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Route"),
        backgroundColor: Colors.yellow.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _routeNameController,
                decoration: InputDecoration(
                  labelText: "Route Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              GooglePlaceAutoCompleteTextField(
                textEditingController: _startLocationController,
                googleAPIKey: google_api_key_places,
                focusNode: _startLocationFocusNode,
                inputDecoration: InputDecoration(
                  labelText: "Start Location",
                  border: OutlineInputBorder(),
                ),
                debounceTime: 600,
                itemClick: (Prediction prediction) {
                  _startLocationController.text = prediction.description ?? "";
                  FocusScope.of(context).requestFocus(_endLocationFocusNode);
                },
                getPlaceDetailWithLatLng: (placeDetail) {
                  setState(() {
                    _startLocation = {
                      "latitude": double.tryParse(placeDetail.lat ?? "0") ?? 0.0,
                      "longitude": double.tryParse(placeDetail.lng ?? "0") ?? 0.0,
                    };
                  });
                },
              ),
              SizedBox(height: 10),
              GooglePlaceAutoCompleteTextField(
                textEditingController: _endLocationController,
                googleAPIKey: google_api_key_places,
                focusNode: _endLocationFocusNode,
                inputDecoration: InputDecoration(
                  labelText: "End Location",
                  border: OutlineInputBorder(),
                ),
                debounceTime: 600,
                itemClick: (Prediction prediction) {
                  _endLocationController.text = prediction.description ?? "";
                  FocusScope.of(context).unfocus();
                },
                getPlaceDetailWithLatLng: (placeDetail) {
                  setState(() {
                    _endLocation = {
                      "latitude": double.tryParse(placeDetail.lat ?? "0") ?? 0.0,
                      "longitude": double.tryParse(placeDetail.lng ?? "0") ?? 0.0,
                    };
                  });
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _busList.any((busList) => busList["busId"] == _selectedBusId) ? _selectedBusId : null,
                items: [
                  DropdownMenuItem<String>(
                    value: 'qwerty',
                    child: Text("Select Bus", style: TextStyle(color: Colors.black)),
                  ),
                  ..._busList.map((bus) {
                    return DropdownMenuItem<String>(
                      value: bus["busId"],
                      child: Text(bus["bus_number"]),
                    );
                  }).toList(),
                ],
                onChanged: (value) => setState(() => _selectedBusId = value),
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _driversList.any((driver) => driver["driverId"] == _selectedDriverId) ? _selectedDriverId : null,
                items: [
                  DropdownMenuItem<String>(
                    value: 'qwerty',
                    child: Text("Select Driver", style: TextStyle(color: Colors.black)),
                  ),
                  ..._driversList.map((driver) {
                    return DropdownMenuItem<String>(
                      value: driver["driverId"],
                      child: Text(driver["name"]),
                    );
                  }).toList(),
                ],
                onChanged: (value) => setState(() => _selectedDriverId = value),
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 25),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _updateRoute,
                    child: Text("Update", style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 25),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 14)),
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
