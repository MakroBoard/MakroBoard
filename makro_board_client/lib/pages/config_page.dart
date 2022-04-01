import 'package:flutter/material.dart';
import 'package:makro_board_client/widgets/available_clients.dart';
import 'package:makro_board_client/widgets/available_controls.dart';
import 'package:makro_board_client/widgets/snack_bar_notification.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
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
          title: const Text('Administration'),
        ),
        body: const SnackBarNotification(
          child: TabBarView(
            children: [
              AvailableClients(),
              AvailableControls(),
            ],
          ),
        ),
      ),
    );
  }
}
