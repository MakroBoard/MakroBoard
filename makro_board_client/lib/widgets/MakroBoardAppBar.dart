import 'package:flutter/material.dart';
import 'package:makro_board_client/router/page_action.dart';
import 'package:makro_board_client/router/page_configuration.dart';
import 'package:makro_board_client/router/page_state.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

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
                  onPressed: () => Provider.of<AppState>(context, listen: false).navigateTo(PageAction(state: PageState.addPage, page: settingsPageConfig)),
                ),
                if (showAdminPanel)
                  TextButton(
                    child: const Icon(
                      Icons.admin_panel_settings,
                      size: 24,
                      color: Colors.white,
                    ),
                    onPressed: () => Provider.of<AppState>(context, listen: false).navigateTo(PageAction(state: PageState.addPage, page: configPageConfig)),
                  )
              ],
        );

  // @override
  // Widget build(BuildContext context) {
  //   return AppBar(actions: [],);
  // }
}
