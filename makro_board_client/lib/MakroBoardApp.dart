import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:makro_board_client/models/page.dart' as models;
import 'package:makro_board_client/pages/config_page.dart';
import 'package:makro_board_client/pages/login_page.dart';
import 'package:makro_board_client/pages/pagePage.dart';
import 'package:makro_board_client/pages/select_server_page.dart';
import 'package:makro_board_client/pages/settings_page.dart';
import 'package:makro_board_client/pages/splash_screen.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/widgets/MakroBoardRouter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'pages/homePage.dart';
import 'theme/theme.dart';

class MakroBoardApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MakroBoardAppState createState() => _MakroBoardAppState();
}

class _MakroBoardAppState extends State<MakroBoardApp> {
  Uri? _selectedServer;
  var _isAuthenticated = false;
  models.Page? _selectedPage;

  @override
  Widget build(BuildContext context) {
    Provider.of<ApiProvider>(context, listen: false).isAuthenticatedStream.listen((isAuthenticated) {
      if (_isAuthenticated != isAuthenticated) {
        setState(() {
          _isAuthenticated = isAuthenticated;
        });
      }
    });

    return MaterialApp(
      title: 'MakroBoard',
      // theme: ThemeData(
      //   // This is the theme of your application.
      //   //
      //   // Try running your application with "flutter run". You'll see the
      //   // application has a blue toolbar. Then, without quitting the app, try
      //   // changing the primarySwatch below to Colors.green and then invoke
      //   // "hot reload" (press "r" in the console where you ran "flutter run",
      //   // or simply save your changes to "hot reload" in a Flutter IDE).
      //   // Notice that the counter didn't reset back to zero; the application
      //   // is not restarted.
      //   primarySwatch: Colors.blue,
      // ),
      theme: makroBoardTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Navigator(
        pages: [
          if (_selectedServer == null)
            MaterialPage(
              key: ValueKey('SplashScreen'),
              child: SplashScreen(
                selectedServerChanged: _handleSelectedServer,
              ),
            ),
          if (_selectedServer != null)
            if (!_selectedServer!.hasPort || !_selectedServer!.hasAuthority)
              MaterialPage(
                key: ValueKey('SelectServerPage'),
                child: SelectServerPage(
                  selectedServerChanged: _handleSelectedServer,
                  isAuthenticatedChanged: _handleIsAuthenticatedChanged,
                ),
              )
            else if (!_isAuthenticated)
              MaterialPage(
                key: ValueKey('LoginPage'),
                child: LoginPage(
                    // selectedServerChanged: _handleSelectedServer,
                    // isAuthenticatedChanged: _handleIsAuthenticatedChanged,
                    ),
              )
            else
              MaterialPage(
                key: ValueKey('HomePage'),
                child: HomePage(
                  selectedPageChanged: _handleSelectedPageChanged,
                ),
              ),
          if (_selectedServer != null && _selectedPage != null)
            MaterialPage(
              key: ValueKey('Page_' + _selectedPage!.symbolicName),
              child: PagePage(
                initialPage: _selectedPage!,
                key: ValueKey(_selectedPage!.symbolicName),
              ),
            ),
          if (MakroBoardRouter.of(context)!.showSettings)
            MaterialPage(
              key: ValueKey('Page_Settings'),
              child: SettingsPage(),
            ),
          if (MakroBoardRouter.of(context)!.showConfig)
            MaterialPage(
              key: ValueKey('Page_Config'),
              child: ConfigPage(),
            ),
        ],
        onPopPage: (route, result) {
          if (_selectedPage != null) {
            _selectedPage = null;
          }

          var router = MakroBoardRouter.of(context);
          router!.reset();

          return route.didPop(result);
        },
      ),
      builder: EasyLoading.init(),
    );
  }

  void _handleSelectedServer(selectedServer) {
    setState(() {
      _selectedServer = selectedServer;
    });
  }

  void _handleIsAuthenticatedChanged(isAuthenticated) {
    setState(() {
      _isAuthenticated = isAuthenticated;
    });
  }

  void _handleSelectedPageChanged(page) {
    setState(() {
      _selectedPage = page;
    });
  }
}
