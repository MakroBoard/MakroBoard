import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class WmskAppBar {
  final String title;
  final bool showSettings;
  const WmskAppBar({required this.title, this.showSettings = true});

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        if (showSettings)
          TextButton(
            child: const Icon(
              Icons.settings,
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
