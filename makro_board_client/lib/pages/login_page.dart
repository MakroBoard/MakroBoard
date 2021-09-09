import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:makro_board_client/models/login_code.dart';
import 'package:makro_board_client/provider/auth_provider.dart';
import 'package:makro_board_client/widgets/SnackBarNotification.dart';
import 'package:makro_board_client/widgets/WmskAppBar.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WmskAppBar(titleText: 'Client anmelden'),
      body: SnackBarNotification(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: StreamBuilder<LoginCode>(
                    stream: Provider.of<AuthProvider>(context, listen: false).submitCode(),
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
      ),
    );
  }
}
