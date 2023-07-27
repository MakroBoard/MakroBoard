import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:makro_board_client/models/client.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:provider/provider.dart';

class AvailableClients extends StatelessWidget {
  const AvailableClients({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ownCode = Settings.getValue("server_code", defaultValue: 0);
    return StreamBuilder<List<Client>>(
      stream: Provider.of<ApiProvider>(context, listen: false).clients,
      initialData: Provider.of<ApiProvider>(context, listen: false).currentClients,
      builder: (context, snapshot) => !snapshot.hasData
          ? const Text("No Code Available")
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
                          leading: const Icon(
                            Icons.device_unknown,
                          ),
                          title: Text("Client:${client.clientIp}"),
                          subtitle: Text("Token: ${client.code}"),
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
                                        onPressed: () => {Provider.of<ApiProvider>(context, listen: false).removeClient(client)},
                                        icon: const Icon(Icons.remove),
                                        label: const Text("Löschen"),
                                      )
                                    : TextButton.icon(
                                        onPressed: () => {Provider.of<ApiProvider>(context, listen: false).confirmClient(client)},
                                        icon: const Icon(Icons.check),
                                        label: const Text("Freischalten"),
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
