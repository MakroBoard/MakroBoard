import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/router/app_back_button_dispatcher.dart';
import 'package:makro_board_client/router/app_route_parser.dart';
import 'package:makro_board_client/router/app_router_delegate.dart';
import 'package:makro_board_client/router/page_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'app_state.dart';

class MakroBoardApp extends StatefulWidget {
  final ThemeData? theme;

  const MakroBoardApp({Key? key, required this.theme}) : super(key: key);

  // This widget is the root of your application.
  @override
  MakroBoardAppState createState() => MakroBoardAppState();
}

class MakroBoardAppState extends State<MakroBoardApp> {
  final appState = AppState();

  late AppRouterDelegate delegate;
  late AppRouteParser parser;
  late BackButtonDispatcher backButtonDispatcher;

  @override
  void initState() {
    super.initState();

    parser = AppRouteParser();

    delegate = AppRouterDelegate(appState);
    if (kIsWeb) {
      var uri = Uri.base;
      var config = parser.parseUri(uri);
      appState.initialConfig = config;
    } else {
      appState.initialConfig = splashPageConfig;
    }

    backButtonDispatcher = AppBackButtonDispatcher(delegate);

    Future.delayed(Duration.zero, () {
      appState.init(context);

      Provider.of<ApiProvider>(context, listen: false).updateContext(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => appState,
      child: MaterialApp.router(
        routeInformationParser: parser,
        routerDelegate: delegate,
        theme: widget.theme,
        title: "MakroBoard",
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: EasyLoading.init(),
      ),
    );
  }
}
