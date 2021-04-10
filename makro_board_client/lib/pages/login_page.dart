import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:makro_board_client/models/login_code.dart';
import 'package:makro_board_client/provider/auth_provider.dart';
import 'package:makro_board_client/widgets/WmskAppBar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();

    Modular.get<AuthProvider>().waitForAuthenticated().then(
          (isAutenticated) => {if (isAutenticated) Modular.to.navigate('/home') else Modular.to.navigate('/login')},
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WmskAppBar(title: 'Client anmelden').getAppBar(context),
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
