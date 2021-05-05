// @dart=2.9

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/widgets/EditMode.dart';

import 'app_module.dart';
import 'app_widget.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(ModularApp(
    module: AppModule(),
    // child: EditMode(
    //   editMode: false,
    //   child: AppWidget(),
    // ),
    child: AppWidget(),
  ));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    final HttpClient client = super.createHttpClient(context)
      ..maxConnectionsPerHost = 5
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return client;
  }
}
