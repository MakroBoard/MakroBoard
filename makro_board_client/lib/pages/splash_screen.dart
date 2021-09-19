import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  final ValueChanged<Uri?> selectedServerChanged;

  SplashScreen({
    required this.selectedServerChanged,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    var minFuture = new Future.delayed(const Duration(seconds: 3));
    await Settings.init();

    _initializeEasyLoading();

    Uri? serverUri;

    if (kIsWeb) {
      serverUri = Uri.base;
    } else {
      var serverUriString = Settings.getValue<String>("server_host", "");
      if (serverUriString.isNotEmpty) {
        var portString = Settings.getValue("server_port", "5001");
        var port = portString.isNotEmpty ? int.parse(portString) : 5001;
        serverUri = Uri.tryParse(serverUriString);
        if (serverUri != null) {
          serverUri = serverUri.replace(port: port);
        }
      }
    }

    var apiProvider = Provider.of<ApiProvider>(context, listen: false);

    if (serverUri == null || !(await apiProvider.initialize(serverUri, AppLocalizations.of(context)!.localeName))) {
      serverUri = Uri();
    } else {
      await apiProvider.isAuthenticated();
    }

    await minFuture;
    this.widget.selectedServerChanged(serverUri);
  }

  void _initializeEasyLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false
      ..maskType = EasyLoadingMaskType.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 64, 64, 64),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Image.asset(
                  'assets/images/Logo_small_1024_1024.png',
                  width: 100.0,
                  alignment: Alignment.center,
                  height: 100.0,
                  isAntiAlias: true,
                  filterQuality: FilterQuality.high,
                ),
              ),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 64.0,
                  fontFamily: 'Hack',
                  letterSpacing: -5,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'MakroBoard',
                      speed: Duration(milliseconds: 200),
                    ),
                  ],
                ),
              ),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Hack',
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Console.WriteLine("' + AppLocalizations.of(context)!.hello + '")',
                      speed: Duration(milliseconds: 65),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
