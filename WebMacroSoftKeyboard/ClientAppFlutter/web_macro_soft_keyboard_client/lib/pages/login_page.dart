import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:web_macro_soft_keyboard_client/models/login_code.dart';
import 'package:web_macro_soft_keyboard_client/provider/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();

    // Modular.get<AuthProvider>().isAuthenticated().then((isAutenticated) => {if (isAutenticated) Modular.to.navigate('/home') else Modular.to.navigate('/login')});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client anmelden'),
        actions: [
          TextButton(
            child: Icon(
              Icons.settings,
              size: 24,
              color: Colors.white,
            ),
            onPressed: () => Modular.to.pushNamed(
              '/config',
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: StreamBuilder<LoginCode>(
                  stream: Modular.get<AuthProvider>().submitCode(),
                  builder: (context, snapshot) => !snapshot.hasData
                      ? Text("No Code Available")
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Öffnen sie auf ihrem Zielsystem die Configuration und bestätigen Sie den Code."),
                            Text(
                              snapshot.data!.code.toString(),
                              style: TextStyle(fontSize: 64),
                            ),
                            Text("Code gültig bis: " + DateFormat("HH:mm:ss").format(snapshot.data!.validUntil.toLocal())),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}