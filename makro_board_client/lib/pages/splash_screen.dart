import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/provider/auth_provider.dart';

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
    await Modular.get<ApiProvider>().initialize();
    var isAuthenticated = await Modular.get<AuthProvider>().isAuthenticated();
    if (isAuthenticated) {
      Modular.to.navigate('/home');
    } else {
      Modular.to.navigate('/login');
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
