import 'package:flutter/material.dart';

import 'facebooklogin_block.dart';
import 'locallogin_bloc.dart';

class LocalLoginProvider extends InheritedWidget {
  final LocalLoginBloc bloc;

  LocalLoginProvider({Key key, Widget child})
      : bloc = LocalLoginBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LocalLoginBloc of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<LocalLoginProvider>()
        .bloc);
  }
}
