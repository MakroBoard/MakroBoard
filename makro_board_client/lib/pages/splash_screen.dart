import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/provider/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Uri? serverUri;
    if (kIsWeb) {
      serverUri = Uri.base;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var serverUriString = prefs.getString('uribase');
      if (serverUriString != null) {
        var port = prefs.getInt('port') ?? 5001;
        serverUri = Uri.tryParse(serverUriString);
        if (serverUri != null) {
          serverUri = serverUri.replace(port: port);
        }
      }
    }

    if (serverUri == null || !(await Modular.get<ApiProvider>().initialize(serverUri))) {
      Modular.to.navigate('/selectserver');
    } else {
      var isAuthenticated = await Modular.get<AuthProvider>().isAuthenticated();
      if (isAuthenticated) {
        Modular.to.navigate('/home');
      } else {
        Modular.to.navigate('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        // child: Image.asset('assets/splash.png'),
        child: Text("SplashScreen"),
      ),
    );
  }
}
