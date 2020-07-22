import 'package:flutter/material.dart';
import 'package:postestapp/blocs/location_bloc.dart';

class LocationProvider extends InheritedWidget {
  final LocationBlock bloc;

  LocationProvider({Key key, Widget child})
      : bloc = LocationBlock(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LocationBlock of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<LocationProvider>()
        .bloc);
  }
}
