import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:postestapp/blocs/location_bloc.dart';
import 'package:postestapp/blocs/location_provider.dart';

class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  Completer<GoogleMapController> _controller = Completer();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const APIKEY = 'AIzaSyDfyn3iLx9M05EvE4eE4R9xRE78q_pR2Kw';
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  Set<Marker> _markers = {};
  PolylinePoints polylinePoints = PolylinePoints();
  LocationData loc;
  @override
  Widget build(BuildContext context) {
    final bloc = LocationProvider.of(context);
    return Scaffold(
        appBar: AppBar(
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/loginScreen');
              },
              child: Text(
                'LogOut',
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
                height: MediaQuery.of(context).size.height,
                child: _mapView(bloc)),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    color: Colors.white,
                    height: 50,
                    width: 300,
                    child: Text(
                      'Tap on the Map to get a route..',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    )))
          ],
        ));
  }

//Function to build the mapView
  Widget _mapView(LocationBlock bloc) {
    bloc.getMyLocation();
    return StreamBuilder(
        stream: bloc.locationResult,
        builder: (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
          if (snapshot.hasData) {
            loc = snapshot.data;
            return GoogleMap(
              onTap: _handleTap,
              markers: _markers,
              key: _scaffoldKey,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(snapshot.data.latitude, snapshot.data.longitude),
                zoom: 12,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        bearing: 192.8334901395799,
                        target: LatLng(
                            snapshot.data.latitude, snapshot.data.longitude),
                        zoom: 12)));
              },
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              compassEnabled: true,
              polylines: Set<Polyline>.of(polylines.values),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  /* Function to get route location. 
  param: destination - Location of the destination.
  param: position - Location of the origin point.
  */
  _getPolyline({LatLng destination, LatLng position}) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIKEY,
      PointLatLng(position.latitude, position.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  //Function to add PolyLine.
  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  /* Function to handle tap on map. 
  param: point - Location of the tap.
  */
  _handleTap(LatLng point) {
    setState(() {
      polylineCoordinates.clear();
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ));
      _getPolyline(
          destination: point, position: LatLng(loc.latitude, loc.longitude));
    });
  }
}
