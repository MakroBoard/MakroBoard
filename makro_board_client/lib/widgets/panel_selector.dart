import 'package:flutter/material.dart';
import 'package:makro_board_client/models/control.dart';
import 'package:makro_board_client/models/plugin.dart' as models;

import 'image_widget.dart';

class PanelSelector extends StatelessWidget {
  final List<models.Plugin> plugins;
  final Function(models.Plugin, Control) onPanelSelected;
  final Control? selectedControl;

  const PanelSelector({Key? key, required this.plugins, required this.onPanelSelected, required this.selectedControl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: plugins.length,
          itemBuilder: (context, pluginIndex) {
            var plugin = plugins[pluginIndex];
            var isSelectedPlugin = plugin.controls.contains(selectedControl);
            return ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (plugin.icon != null)
                    ImageWidget(
                      pluginName: plugin.pluginName,
                      image: plugin.icon!,
                    ),
                  if (plugin.icon == null)
                    const SizedBox(
                      width: 32,
                      height: 32,
                    ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    plugin.title.getText(),
                    style: isSelectedPlugin ? Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold) : Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              initiallyExpanded: isSelectedPlugin,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: plugin.controls.length,
                  itemBuilder: (context, index) {
                    var control = plugin.controls[index];
                    return Container(
                      color: (selectedControl == control) ? Theme.of(context).primaryColor.withAlpha(128) : Colors.transparent,
                      child: ListTile(
                        title: Text(control.symbolicName),
                        onTap: () {
                          if (selectedControl != control) {
                            onPanelSelected(plugin, control);
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
