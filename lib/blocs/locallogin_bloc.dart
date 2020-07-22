import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rxdart/rxdart.dart';

class LocalLoginBloc {
  final BehaviorSubject<bool> _authResult = BehaviorSubject<bool>();

  // Streams
  Stream<bool> get authResult => _authResult.stream;

  Function(bool) get changeStatus => _authResult.sink.add;
  final LocalAuthentication _localAuthentication = LocalAuthentication();

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

  dispose() {
    _authResult.close();
  }
}
