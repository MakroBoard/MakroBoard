import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage() : super();

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      title: "Einstellungen",
      children: [
        SettingsGroup(
          title: "Verbindungseinstellungen",
          subtitle: "Verbindung zum MakroBoard Host einstellen",
          children: [
            TextInputSettingsTile(
              title: "Host",
              settingKey: "server_host",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Um fortzufahren wird ein Host benötigt.";
                }

                if (Uri.tryParse(value) == null) {
                  return "Der Host \"value\" ist keine gültige URI";
                }
                return null;
              },
            ),
            TextInputSettingsTile(
              title: "Port",
              keyboardType: TextInputType.number,
              settingKey: "server_port",
              validator: (value) {
                if (value!.isEmpty) {
                  return "Um fortzufahren wird ein Port benötigt.";
                }

                var port = int.parse(value);
                if (port < 1024) {
                  return "System Ports dürfen nicht verwendet werden. Min. Port: 1024";
                }

                if (port > 49151) {
                  return "Dynamic Ports dürfen nicht verwendet werden. Max. Port: 49151";
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
