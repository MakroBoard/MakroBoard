import 'package:flutter/material.dart';
import 'package:makro_board_client/models/control.dart';
import 'package:makro_board_client/models/view_config_value.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:provider/provider.dart';

class ButtonPanel extends StatelessWidget {
  final List<ViewConfigValue> configValues;
  final Control control;
  const ButtonPanel({Key? key, required this.configValues, required this.control}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await Provider.of<ApiProvider>(context, listen: false).executeControl(control, configValues);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ChangeNotifierProvider.value(
          value: configValues.firstWhere((element) => element.symbolicName.split(".").last == "label"),
          builder: (context, _) => Text(context.watch<ViewConfigValue>().value.toString()),
        ),
      ),
    );
  }
}
