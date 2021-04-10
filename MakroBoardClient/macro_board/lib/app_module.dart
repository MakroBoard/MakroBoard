// app_module.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:macro_board/guards/auth_guard.dart';
import 'package:macro_board/pages/config_page.dart';
import 'package:macro_board/pages/login_page.dart';
import 'package:macro_board/pages/splash_screen.dart';
import 'package:macro_board/provider/api_provider.dart';
import 'package:macro_board/provider/env_provider.dart';

import 'pages/homePage.dart';
import 'app_widget.dart';
import 'provider/auth_provider.dart';

class AppModule extends Module {
  // Provide a list of dependencies to inject into your project
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => EnvProvider()),
    Bind.singleton<ApiProvider>((i) => ApiProvider(envProvider: i<EnvProvider>())),
    Bind.lazySingleton((i) => AuthProvider(apiProvider: i<ApiProvider>())),
  ];

  // Provide all the routes for your module
  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => SplashScreen()),
    ChildRoute('/home', child: (_, __) => HomePage(key: UniqueKey()), guards: [AuthGuard()]),
    ChildRoute('/config', child: (_, __) => ConfigPage(key: UniqueKey())),
    ChildRoute('/login', child: (_, __) => LoginPage(key: UniqueKey())),
  ];

  // add your main widget here
  @override
  Widget get bootstrap => AppWidget();
}
