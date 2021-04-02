// app_module.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:web_macro_soft_keyboard_client/guards/auth_guard.dart';
import 'package:web_macro_soft_keyboard_client/pages/config_page.dart';
import 'package:web_macro_soft_keyboard_client/pages/login_page.dart';
import 'package:web_macro_soft_keyboard_client/pages/splash_screen.dart';
import 'package:web_macro_soft_keyboard_client/provider/data_provider.dart';
import 'package:web_macro_soft_keyboard_client/provider/env_provider.dart';

import 'pages/homePage.dart';
import 'app_widget.dart';
import 'provider/auth_provider.dart';

class AppModule extends Module {
  // Provide a list of dependencies to inject into your project
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => EnvProvider()),
    Bind.singleton<DataProvider>((i) {
      var dataProvider = DataProvider(envProvider: i<EnvProvider>());
      dataProvider.initialize();
      return dataProvider;
    }),
    Bind.lazySingleton((i) => AuthProvider(envProvider: i<EnvProvider>())),
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
