import 'package:flutter/material.dart';
import 'package:makro_board_client/models/view_config_value.dart';
import 'package:provider/provider.dart';

class TextPanel extends StatelessWidget {
  final List<ViewConfigValue> configValues;
  const TextPanel({Key? key, required this.configValues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChangeNotifierProvider.value(
        value: configValues.firstWhere((element) => element.symbolicName.split(".").last == "text", orElse: () => ViewConfigValue(symbolicName: "text")),
        builder: (context, _) => Text(context.watch<ViewConfigValue>().value.toString()),
      ),
    );
  }
}
