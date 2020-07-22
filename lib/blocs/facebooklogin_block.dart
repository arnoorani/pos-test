import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  // StreamController
  final BehaviorSubject<String> _facebookResult = BehaviorSubject<String>();
  final BehaviorSubject<bool> _facebookAuth = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _authResult = BehaviorSubject<bool>();

  // Streams
  Stream<bool> get authResult => _authResult.stream;
  Stream<bool> get facebookAuth => _facebookAuth.stream;

  // Function
  Function(bool) get changeStatus => _authResult.sink.add;
  Function(bool) get changeFacebookStatus => _facebookAuth.sink.add;

  static final FacebookLogin facebookSignIn = new FacebookLogin();
  static final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<Null> sigInFacebook() async {
    bool isAuthenticated = false;
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        _facebookResult.sink.add(token);
        isAuthenticated = true;

        break;
      case FacebookLoginStatus.cancelledByUser:
        isAuthenticated = false;
        _facebookResult.addError("Facebook auth error");

        break;
      case FacebookLoginStatus.error:
        isAuthenticated = false;
        _facebookResult.addError("Canceled by user");

        break;
    }
    isAuthenticated ? changeFacebookStatus(true) : changeFacebookStatus(false);
  }

  Future<void> authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason:
            "Please authenticate to view your transaction overview",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    isAuthenticated ? changeStatus(true) : changeStatus(false);

    if (isAuthenticated) {}
  }

  signOutFacebook() async {
    await facebookSignIn
        .logOut()
        .then(_facebookResult.sink.add)
        .then(changeFacebookStatus);
  }

  dispose() {
    _facebookResult.close();
    _facebookAuth.close();
    _authResult.close();
  }
}
