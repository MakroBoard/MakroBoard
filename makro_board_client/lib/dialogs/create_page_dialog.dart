import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/models/page.dart' as models;

class CreatePageDialog extends StatelessWidget {
  const CreatePageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String pageLabel = "";
    String icon = "";
    final _createPageFormKey = GlobalKey<FormState>();

    return SimpleDialog(
      title: Text("Neue Seite anlegen"),
      children: [
        Form(
          key: _createPageFormKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
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
                  pageLabel = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  labelText: "Icon",
                  prefixIcon: Icon(Icons.dns_outlined),
                ),
                // validator: (value) {
                //   if (value == null) {
                //     return "Um fortzufahren wird ein Name benötigt.";
                //   }

                //   return null;
                // },
                onChanged: (value) {
                  icon = value;
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
                      EasyLoading.show(status: 'Neue Seite anlegen ...');
                      if (_createPageFormKey.currentState!.validate()) {
                        try {
                          await Modular.get<ApiProvider>().addPage(models.Page.createNew(label: pageLabel, icon: icon));

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
