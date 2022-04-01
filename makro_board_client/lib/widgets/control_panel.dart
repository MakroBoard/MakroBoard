import 'package:flutter/material.dart';
import 'package:makro_board_client/dialogs/delete_dialog.dart';
import 'package:makro_board_client/dialogs/edit_panel_dialog.dart';
import 'package:makro_board_client/models/control.dart';
import 'package:makro_board_client/models/view.dart';
import 'package:makro_board_client/models/view_config_value.dart';
import 'package:makro_board_client/models/panel.dart';
import 'package:makro_board_client/pages/page_page.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/widgets/panels/button_panel.dart';
import 'package:provider/provider.dart';

import 'global_settings.dart';
import 'panels/progress_panel.dart';
import 'panels/text_panel.dart';

class ControlPanel extends StatelessWidget {
  final Panel? panel;
  final Control control;
  final List<ViewConfigValue> configValues;

  const ControlPanel({Key? key, required this.panel, required this.control, required this.configValues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (panel != null && (GlobalSettings.of(context)?.editMode ?? false))
          ? Row(
              children: [
                Expanded(
                  child: _createControl(context, control, configValues),
                ),
                PopupMenuButton<GroupContextMenu>(
                  onSelected: (selectedValue) {
                    switch (selectedValue) {
                      case GroupContextMenu.delete:
                        _showRemovePanelDialog(context, panel!);
                        break;
                      case GroupContextMenu.edit:
                        _showEditPanelDialog(context, control, panel!);
                        break;
                      case GroupContextMenu.addPanel:
                        // Not available in this case.
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<GroupContextMenu>(
                      value: GroupContextMenu.delete,
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Löschen'),
                      ),
                    ),
                    const PopupMenuItem<GroupContextMenu>(
                      value: GroupContextMenu.edit,
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Bearbeiten'),
                      ),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            )
          : _createControl(context, control, configValues),
    );
  }

  Widget _createControl(BuildContext context, Control control, List<ViewConfigValue> configValues) {
    return _createControlWithView(context, control, control.view, configValues);
  }

  Widget _createControlWithView(BuildContext context, Control control, View view, List<ViewConfigValue> configValues) {
    switch (view.viewType) {
      case "Button":
        return ButtonPanel(configValues: configValues, control: control);
      case "Text":
        return TextPanel(configValues: configValues);
      case "ProgressBar":
        return ProgressPanel(configValues: configValues);
      case "List":
        return ListView.builder(
          shrinkWrap: true,
          itemCount: control.view.subViews!.length,
          itemBuilder: (context, index) {
            var subControl = control.subControls![index];
            return _createControlWithView(
                context, subControl, control.view.subViews![index], configValues.where((element) => element.symbolicName.split(".").first == subControl.symbolicName).toList());
          },
        );
      default:
        return Text("Missing Control: " + control.view.viewType);
    }
  }

  Future _showEditPanelDialog(BuildContext context, Control control, Panel panel) {
    return showDialog(
      context: context,
      builder: (context) {
        return EditPanelDialog(
          control: control,
          panel: panel,
        );
      },
    );
  }

  Future _showRemovePanelDialog(BuildContext context, Panel panel) {
    return showDialog(
      context: context,
      builder: (context) {
        return DeleteDialog(
          title: "Löschen",
          deleteText: "Soll ${panel.symbolicName} wirklich gelöscht werden?",
          executeText: "${panel.symbolicName} wird gelöscht ...",
          deleteCallback: () => Provider.of<ApiProvider>(context, listen: false).removePanel(panel),
        );
      },
    );
  }
}
