import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:makro_board_client/models/login_code.dart';
import 'package:makro_board_client/provider/auth_provider.dart';
import 'package:makro_board_client/widgets/snack_bar_notification.dart';
import 'package:makro_board_client/widgets/makro_board_app_bar.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MakroBoardAppBar(
        context: context,
        titleText: 'Client anmelden',
      ),
      body: SnackBarNotification(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: StreamBuilder<LoginCode>(
                    stream: Provider.of<AuthProvider>(context, listen: false).submitCode(),
                    builder: (context, snapshot) => !snapshot.hasData
                        ? const Text("No Code Available")
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Öffnen sie auf ihrem Zielsystem die Configuration und bestätigen Sie den Code."),
                              Text(
                                snapshot.data!.code.toString(),
                                style: const TextStyle(fontSize: 64),
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
