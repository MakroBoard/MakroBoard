import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class WmskAppBar extends AppBar {
  final String titleText;
  final bool showAdminPanel;
  final List<Widget> additionalActions;
  WmskAppBar({required this.titleText, this.showAdminPanel = true, this.additionalActions = const <Widget>[]})
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
                  onPressed: () => Modular.to.pushNamed(
                    '/settings',
                  ),
                ),
                if (showAdminPanel)
                  TextButton(
                    child: const Icon(
                      Icons.admin_panel_settings,
                      size: 24,
                      color: Colors.white,
                    ),
                    onPressed: () => Modular.to.pushNamed(
                      '/config',
                    ),
                  )
              ],
        );

  @override
  Widget build(BuildContext context) {
    return AppBar();
  }
}
