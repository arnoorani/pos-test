import 'package:flutter/material.dart';
import 'package:postestapp/Screens/MapsScreen/MapsScreenView.dart';

import 'package:postestapp/blocs/location_provider.dart';
import 'package:postestapp/blocs/login_bloc.dart';
import 'package:postestapp/blocs/login_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final SharedPreferences prefs;
  LoginPage({this.prefs});
  @override
  Widget build(BuildContext context) {
    final bloc = LoginProvider.of(context);

    //Listner for Facebook Login Event.
    bloc.facebookAuth.listen((event) {
      if (event) {
        prefs.setBool('isLoggedin', true);
        Navigator.pushNamed(context, '/mapsScreen');
      }
    });

    //Listner for Touch-ID Sign in Event.
    bloc.authResult.listen((event) {
      if (event) {
        prefs.setBool('isLoggedin', true);
        Navigator.pushNamed(context, '/mapsScreen');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Login screen'),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(20.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildFbLoginBt(bloc),
            _buildLocalLogin(bloc),
            _buildSignOutBt(bloc),
            Padding(padding: EdgeInsets.only(top: 20.0)),
          ],
        )),
      ),
    );
  }

//Facebook LoginButton.
  Widget _buildFbLoginBt(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.facebookAuth,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return RaisedButton(
              child: Text('Login with Facebook'),
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: !snapshot.hasData
                  ? () async {
                      bloc.sigInFacebook();
                    }
                  : null);
        });
  }

//FingerPrint LoginButton
  Widget _buildLocalLogin(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.authResult,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return RaisedButton(
            child: Text('Log-in using touch-id'),
            color: Colors.black,
            textColor: Colors.white,
            onPressed: !snapshot.hasData
                ? () async {
                    bloc.authenticateUser();
                  }
                : null);
      },
    );
  }

  //Finger Print LoginButton
  Widget getFlatbutton(
      AsyncSnapshot<bool> snapshot, LoginBloc bloc, String text) {
    return RaisedButton(
        child: Text(text),
        color: Colors.black,
        textColor: Colors.white,
        onPressed: () {
          bloc.authenticateUser();
        });
  }

  //Facebook Log-Out Button.
  Widget _buildSignOutBt(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.authResult,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
            child: Text('Logout Facebook'),
            color: Color(Colors.blue.blue),
            textColor: Colors.white,
            onPressed: snapshot.hasData
                ? () async {
                    prefs.setBool('isLoggedin', false);
                    bloc.signOutFacebook();
                  }
                : null);
      },
    );
  }
}
