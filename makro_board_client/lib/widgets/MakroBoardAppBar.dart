import 'package:flutter/material.dart';
import 'package:makro_board_client/widgets/MakroBoardRouter.dart';

class MakroBoardAppBar extends AppBar {
  final BuildContext context;
  final String titleText;
  final bool showAdminPanel;
  final List<Widget> additionalActions;
  final Widget? icon;

  MakroBoardAppBar({
    required this.context,
    required this.titleText,
    this.showAdminPanel = true,
    this.additionalActions = const <Widget>[],
    this.icon,
  }) : super(
          title: Row(
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: icon,
                ),
              Text(titleText),
            ],
          ),
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
