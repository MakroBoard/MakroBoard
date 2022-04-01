import 'package:flutter/material.dart';

import 'app_router_delegate.dart';

class AppBackButtonDispatcher extends RootBackButtonDispatcher {
  final AppRouterDelegate _routerDelegate;

  AppBackButtonDispatcher(this._routerDelegate) : super();

  @override
  Future<bool> didPopRoute() {
    return _routerDelegate.popRoute();
  }
}
