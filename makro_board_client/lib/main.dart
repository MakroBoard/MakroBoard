import 'dart:io';

import 'package:flutter/material.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/provider/auth_provider.dart';
import 'package:makro_board_client/provider/env_provider.dart';
import 'package:makro_board_client/provider/notification_provider.dart';
import 'package:makro_board_client/widgets/GlobalSettings.dart';
import 'package:makro_board_client/widgets/MakroBoardRouter.dart';
import 'package:provider/provider.dart';

import 'MakroBoardApp.dart';
import 'MakroboardHttpOverrides.dart';

void main() {
  HttpOverrides.global = new MakroboardHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        Provider<EnvProvider>(create: (c) => EnvProvider()),
        Provider<NotificationProvider>(create: (c) => NotificationProvider()),
        Provider<ApiProvider>(create: (c) => ApiProvider(envProvider: Provider.of(c, listen: false), notificationProvider: Provider.of(c, listen: false))),
        Provider<AuthProvider>(create: (c) => AuthProvider(apiProvider: Provider.of(c, listen: false)))
      ],
      child: GlobalSettings(
        child: MakroBoardRouter(
          child: MakroBoardApp(),
        ),
      ),
    ),
  );
}
