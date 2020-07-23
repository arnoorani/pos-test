import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../constants.dart';

class PolyBloc {
  final BehaviorSubject<List<LatLng>> _polyResults =
      BehaviorSubject<List<LatLng>>();

  Stream<List<LatLng>> get polyresults => _polyResults.stream;

  Function(List<LatLng>) get getPolyResults => _polyResults.sink.add;

  PolylinePoints polylinePoints = PolylinePoints();

  dispose() {
    _polyResults.close();
  }

  _getPolyline({LatLng destination, LatLng position}) async {
    List<LatLng> list = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      API_KEY,
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
}
