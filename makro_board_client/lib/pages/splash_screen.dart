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
    String? serverUri;
    if (kIsWeb) {
      serverUri = Uri.base.path;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      serverUri = prefs.getString('uribase');
    }

    if (serverUri == null) {
      Modular.to.navigate('/selectserver');
    } else {
      await Modular.get<ApiProvider>().initialize();
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
      backgroundColor: Colors.white,
      body: Center(
        // child: Image.asset('assets/splash.png'),
        child: Text("SplashScreen"),
      ),
    );
  }
}
