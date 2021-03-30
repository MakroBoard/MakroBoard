import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:signalr_core/signalr_core.dart';

import 'env_provider.dart';

@Injectable() // ← Injectable annotation
class DataProvider {
  static const String requestTokenUrl = "/hub/clients";

  final EnvProvider envProvider;
  DataProvider({
    required this.envProvider, // ← The parameters of the constructur will define the generated binding
  }) {
    final connection = HubConnectionBuilder()
        .withUrl(
            Uri.http(envProvider.getBaseUrl(), requestTokenUrl).toString(),
            HttpConnectionOptions(
              logging: (level, message) => print(message),
            ))
        .build();

    connection.start()!.then((value) => {});

// connection.on('ReceiveMessage', (message) {
//     print(message.toString());
// });

// await connection.invoke('SendMessage', args: ['Bob', 'Says hi!']);
  }

  // Stream<Client> subscribeClients() async* {
  //   // while (!(await isAuthenticated())) {
  //   //   var loginCode = await _getNewLoginCode();
  //   //   Duration timerDuration = loginCode.validUntil.difference(DateTime.now());
  //   //   yield loginCode;
  //   //   await Future.delayed(timerDuration);
  //   // }
  // }
}
