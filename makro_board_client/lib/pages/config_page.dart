import 'package:flutter/material.dart';
import 'package:makro_board_client/widgets/AvailableClients.dart';
import 'package:makro_board_client/widgets/AvailableControls.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.devices),
                text: "Available Clients",
              ),
              Tab(
                icon: Icon(Icons.settings_display),
                text: "Available Controls",
              ),
            ],
          ),
          title: Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            AvailableClients(),
            AvailableControls(),
          ],
        ),
      ),
    );
  }
}
