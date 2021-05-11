import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/theme/theme.dart';

import 'pages/splash_screen.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: makroBoardTheme,
      home: SplashScreen(),
      builder: EasyLoading.init(),
    ).modular();
  }
}
