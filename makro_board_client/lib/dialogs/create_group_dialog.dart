import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/models/page.dart' as models;
import 'package:makro_board_client/models/group.dart' as models;

class CreateGroupDialog extends StatelessWidget {
  final models.Page page;
  const CreateGroupDialog({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String groupLabel = "";
    final _createGroupFormKey = GlobalKey<FormState>();

    return SimpleDialog(
      title: Text("Neue Gruppe anlegen"),
      children: [
        Form(
          key: _createGroupFormKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(Icons.dns_outlined),
                ),
                validator: (value) {
                  if (value == null) {
                    return "Um fortzufahren wird ein Name benötigt.";
                  }

                  return null;
                },
                onChanged: (value) {
                  groupLabel = value;
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
                          await Modular.get<ApiProvider>().addGroup(models.Group.createNew(label: groupLabel, pageId: page.id));

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
