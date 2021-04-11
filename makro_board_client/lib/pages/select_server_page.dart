import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/widgets/WmskAppBar.dart';

class SelectServerPage extends StatelessWidget {
  const SelectServerPage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WmskAppBar(title: "SelectServer", showSettings: false).getAppBar(context),
      body: Container(
        child: Container(
          child: Column(
            children: [
              Text("TODO link to HomePage Downloads"),
              Text("TODO InputField for Server URL"),
              TextButton(
                onPressed: () => Modular.to.navigate('/login'),
                child: Text("Connect"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
