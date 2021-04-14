import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/provider/auth_provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
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
        var port = int.parse(Settings.getValue("server_port", "5001"));
        serverUri = Uri.tryParse(serverUriString);
        if (serverUri != null) {
          serverUri = serverUri.replace(port: port);
        }
      }
    }

    String navigationTarget;
    if (serverUri == null || !(await Modular.get<ApiProvider>().initialize(serverUri))) {
      navigationTarget = '/selectserver';
    } else {
      var isAuthenticated = await Modular.get<AuthProvider>().isAuthenticated();
      if (isAuthenticated) {
        navigationTarget = '/home';
      } else {
        navigationTarget = '/login';
      }
    }

    await minFuture;
    Modular.to.navigate(navigationTarget);
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
        // child: Image.asset('assets/splash.png'),
        child: SizedBox(
          width: 250.0,
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 30.0,
              fontFamily: 'Hack',
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'MakroBoard',
                  speed: Duration(milliseconds: 200),
                ),
              ],
              onTap: () {
                print("Tap Event");
              },
            ),
          ),
        ),
      ),
    );
  }
}
