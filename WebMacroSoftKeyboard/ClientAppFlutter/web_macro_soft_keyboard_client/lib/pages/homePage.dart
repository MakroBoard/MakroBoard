import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:web_macro_soft_keyboard_client/provider/auth_provider.dart';
import 'package:web_macro_soft_keyboard_client/widgets/WmskAppBar.dart';

class HomePage extends StatelessWidget {
  const HomePage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WmskAppBar(title: "Home").getAppBar(context),
      body: Container(
        child: TokenTest(key: UniqueKey()),
      ),
    );
  }
}

class TokenTest extends StatefulWidget {
  TokenTest({required Key key}) : super(key: key);

  @override
  TokenTestState createState() => TokenTestState();
}

class TokenTestState extends State<TokenTest> {
  bool auth = false;

  // async TokenTestState() {
  //   final authProvider = Modular.get<AuthProvider>();
  //   final isAuthenticated = await authProvider.isAuthenticated();
  //   setState(() {
  //     auth = isAuthenticated;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<bool>(
        future: Modular.get<AuthProvider>().isAuthenticated(),
        builder: (context, snapshot) => Text(snapshot.data == true ? "Authenticated" : "Not Authenticated"),
      ),
    );
  }
}
