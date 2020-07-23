import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

class LocationBlock {
  // StreamController
  final BehaviorSubject<LocationData> _location =
      BehaviorSubject<LocationData>();
  final BehaviorSubject<List<LatLng>> _polyResults =
      BehaviorSubject<List<LatLng>>();

  //Stream
  Stream<LocationData> get locationResult => _location.stream;
  Stream<List<LatLng>> get polyresults => _polyResults.stream;

//Functions
  Function(LocationData) get getLocation => _location.sink.add;
  Function(List<LatLng>) get getPolyResults => _polyResults.sink.add;

  PolylinePoints polylinePoints = PolylinePoints();

  //Function to get user location
  void getMyLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      getLocation(currentLocation);
    });

    getLocation(_locationData);
  }

  _getPolyline({LatLng destination, LatLng position}) async {
    List<LatLng> list = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "APIKEY",
      PointLatLng(position.latitude, position.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        list.add(LatLng(point.latitude, point.longitude));

        getPolyResults(list);
      });
    }
  }

  //Dispose Stream.
  dispose() {
    _polyResults.close();
    _location.close();
  }
}
