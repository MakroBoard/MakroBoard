import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class WmskAppBar {
  final String title;
  final bool showAdminPanel;
  const WmskAppBar({required this.title, this.showAdminPanel = true});

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
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
  }
}
