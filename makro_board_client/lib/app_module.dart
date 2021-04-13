// app_module.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/guards/auth_guard.dart';
import 'package:makro_board_client/pages/config_page.dart';
import 'package:makro_board_client/pages/settings_page.dart';
import 'package:makro_board_client/pages/select_server_page.dart';
import 'package:makro_board_client/pages/login_page.dart';
import 'package:makro_board_client/pages/splash_screen.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/provider/env_provider.dart';

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
    ChildRoute('/selectserver', child: (_, __) => SelectServerPage(key: UniqueKey())),
    ChildRoute('/home', child: (_, __) => HomePage(key: UniqueKey()), guards: [AuthGuard()]),
    ChildRoute('/config', child: (_, __) => ConfigPage(key: UniqueKey())),
    ChildRoute('/login', child: (_, __) => LoginPage(key: UniqueKey())),
    ChildRoute('/settings', child: (_, __) => SettingsPage(key: UniqueKey())),
  ];

  // add your main widget here
  @override
  Widget get bootstrap => AppWidget();
}
