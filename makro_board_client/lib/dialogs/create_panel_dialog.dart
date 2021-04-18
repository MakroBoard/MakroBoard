import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/models/group.dart' as models;
import 'package:makro_board_client/models/panel.dart' as models;

class CreatePanelDialog extends StatelessWidget {
  final models.Group group;
  const CreatePanelDialog({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _createGroupFormKey = GlobalKey<FormState>();

    return SimpleDialog(
      title: Text("Panel zur Gruppe " + group.label + " hinzufügen"),
      children: [
        Form(
          key: _createGroupFormKey,
          child: Column(
            children: [
              FutureBuilder(
                future: Modular.get<ApiProvider>().getAvailableControls(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Text("TODO Show available Controls");
                },
              ),
              ButtonBar(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                    child: Text("Abbrechen"),
                  ),
                  TextButton(
                    child: Text("Anlegen"),
                    onPressed: () async {
                      EasyLoading.show(status: 'Neue Gruppe anlegen ...');
                      if (_createGroupFormKey.currentState!.validate()) {
                        try {
                          // await Modular.get<ApiProvider>().addPanel(models.Panel.createNew());

                          Navigator.of(context, rootNavigator: true).pop();
                        } catch (e) {
                          // TODO Fehler anzeigen?
                        }
                      }
                      EasyLoading.dismiss();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
