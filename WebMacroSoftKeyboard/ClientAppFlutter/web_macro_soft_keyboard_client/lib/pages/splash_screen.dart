import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:web_macro_soft_keyboard_client/provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Modular.get<AuthProvider>().isAuthenticated().then((isAutenticated) => {if (isAutenticated) Modular.to.navigate('/home') else Modular.to.navigate('/login')});
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
