import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:macro_board/models/client.dart';
import 'package:macro_board/provider/api_provider.dart';

class AvailableClients extends StatelessWidget {
  const AvailableClients({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
