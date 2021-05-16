import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:makro_board_client/models/client.dart';
import 'package:makro_board_client/provider/api_provider.dart';

class AvailableClients extends StatelessWidget {
  const AvailableClients({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ownCode = Settings.getValue("server_code", 0);
    return StreamBuilder<List<Client>>(
      stream: Modular.get<ApiProvider>().clients,
      initialData: Modular.get<ApiProvider>().currentClients,
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.device_unknown,
                          ),
                          title: Text("Client:" + client.clientIp),
                          subtitle: Text("Token: " + client.code.toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(68.0, 0, 0, 0),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              Text(ClientState.getText(client.state)),
                              if (ownCode != 0 && ownCode != client.code)
                                client.state >= ClientState.confirmed
                                    ? TextButton.icon(
                                        onPressed: () => {Modular.get<ApiProvider>().removeClient(client)},
                                        icon: Icon(Icons.remove),
                                        label: Text("Löschen"),
                                      )
                                    : TextButton.icon(
                                        onPressed: () => {Modular.get<ApiProvider>().confirmClient(client)},
                                        icon: Icon(Icons.check),
                                        label: Text("Freischalten"),
                                      ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
