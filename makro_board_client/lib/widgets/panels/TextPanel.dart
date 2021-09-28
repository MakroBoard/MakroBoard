import 'package:flutter/material.dart';
import 'package:makro_board_client/models/ViewConfigValue.dart';
import 'package:provider/provider.dart';

class TextPanel extends StatelessWidget {
  final List<ViewConfigValue> configValues;
  const TextPanel({required this.configValues}) : super();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChangeNotifierProvider.value(
        value: configValues.firstWhere((element) => element.symbolicName.split(".").last == "text", orElse: () => new ViewConfigValue(symbolicName: "text")),
        builder: (context, _) => Text(context.watch<ViewConfigValue>().value.toString()),
      ),
    );
  }
}
