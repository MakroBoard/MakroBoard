import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'pages/splash_screen.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: "/",
      home: SplashScreen(),
    ).modular();
  }
}