import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:web_macro_soft_keyboard_client/models/client.dart';
import 'package:web_macro_soft_keyboard_client/provider/data_provider.dart';

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
                text: "AvailableClients",
              ),
              Tab(icon: Icon(Icons.settings_display)),
              // Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
          title: Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<List<Client>>(
              stream: Modular.get<DataProvider>().clients,
              initialData: Modular.get<DataProvider>().currentClients,
              builder: (context, snapshot) => !snapshot.hasData
                  ? Text("No Code Available")
                  : ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var client = snapshot.data![index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.device_unknown,
                                  ),
                                  title: Text("Client:" + client.clientIp),
                                  subtitle: Text("Token: " + client.code.toString()),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    client.state == 1
                                        ? TextButton.icon(
                                            onPressed: () => {Modular.get<DataProvider>().confirmClient(client)},
                                            icon: Icon(Icons.check),
                                            label: Text("Freischalten"),
                                          )
                                        : TextButton.icon(
                                            onPressed: () => {Modular.get<DataProvider>().removeClient(client)},
                                            icon: Icon(Icons.remove),
                                            label: Text("Löschen"),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
            ),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}
