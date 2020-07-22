import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

class LocationBlock {
  // StreamController
  final BehaviorSubject<LocationData> _location =
      BehaviorSubject<LocationData>();

  //Stream
  Stream<LocationData> get locationResult => _location.stream;

//Functions
  Function(LocationData) get getLocation => _location.sink.add;

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

  //Dispose Stream.
  dispose() {
    _location.close();
  }
}
