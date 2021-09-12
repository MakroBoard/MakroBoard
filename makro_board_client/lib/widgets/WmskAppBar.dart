import 'package:flutter/material.dart';
import 'package:makro_board_client/widgets/MakroBoardRouter.dart';

class WmskAppBar extends AppBar {
  final BuildContext context;
  final String titleText;
  final bool showAdminPanel;
  final List<Widget> additionalActions;
  WmskAppBar({required this.context, required this.titleText, this.showAdminPanel = true, this.additionalActions = const <Widget>[]})
      : super(
          title: Text(titleText),
          actions: additionalActions +
              <Widget>[
                TextButton(
                  child: const Icon(
                    Icons.settings,
                    size: 24,
                    color: Colors.white,
                  ),
                  onPressed: () => MakroBoardRouter.of(context)!.updateShowSettings(true),
                ),
                if (showAdminPanel)
                  TextButton(
                    child: const Icon(
                      Icons.admin_panel_settings,
                      size: 24,
                      color: Colors.white,
                    ),
                    onPressed: () => MakroBoardRouter.of(context)!.updateShowConfig(true),
                  )
              ],
        );

  // @override
  // Widget build(BuildContext context) {
  //   return AppBar(actions: [],);
  // }
}
