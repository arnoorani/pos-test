import 'package:flutter/material.dart';
import 'package:postestapp/blocs/location_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/LoginScreen/LoginFrontScreen.dart';
import 'Screens/MapsScreen/MapsScreenView.dart';
import 'blocs/login_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    runApp(MyApp(prefs: prefs));
  });
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  MyApp({this.prefs});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/mapsScreen':
            return MaterialPageRoute(
                builder: (context) => LocationProvider(child: MapsScreen()));
            break;
          case '/loginScreen':
            return MaterialPageRoute(
                builder: (context) => LoginProvider(
                        child: LoginPage(
                      prefs: prefs,
                    )));
            break;
          default:
            return null;
        }
      },
      home: _handleCurrentScreen(),
      title: 'POS-Tests App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }

  Widget _handleCurrentScreen() {
    bool seen = (prefs.getBool('isLoggedin') ?? false);
    if (seen) {
      return LocationProvider(child: MapsScreen());
    } else {
      return LoginProvider(
          child: LoginPage(
        prefs: prefs,
      ));
    }
  }
}
