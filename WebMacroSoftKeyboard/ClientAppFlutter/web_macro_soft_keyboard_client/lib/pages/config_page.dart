import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:web_macro_soft_keyboard_client/provider/auth_provider.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Config'),
      ),
      body: Container(
        child: Text("Blubb"),
      ),
    );
  }
}
