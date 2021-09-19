import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage() : super();

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: AppLocalizations.of(context)!.settings,
      children: [
        SettingsGroup(
          title: AppLocalizations.of(context)!.settings_connection,
          subtitle: AppLocalizations.of(context)!.settings_connection_sub,
          children: [
            TextInputSettingsTile(
              title: AppLocalizations.of(context)!.host,
              settingKey: "server_host",
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.error_hostrequired;
                }

                if (Uri.tryParse(value) == null) {
                  return "Der Host \"value\" ist keine gültige URI";
                }
                return null;
              },
            ),
            TextInputSettingsTile(
              title: AppLocalizations.of(context)!.port,
              keyboardType: TextInputType.number,
              settingKey: "server_port",
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.error_portrequired;
                }

                var port = int.parse(value);
                if (port < 1024) {
                  return AppLocalizations.of(context)!.error_systemportsnotallowed;
                }

                if (port > 49151) {
                  return AppLocalizations.of(context)!.error_dynamicportsnotallowed;
                }

                return null;
              },
            ),
          ],
        ),
      ],
    );
  }
}
