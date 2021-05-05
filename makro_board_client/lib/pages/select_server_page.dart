import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/provider/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectServerPage extends StatelessWidget {
  const SelectServerPage({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _loginFormKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // appBar: WmskAppBar(title: "MakroBoard", showSettings: false).getAppBar(context),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.cast_connected),
                          title: const Text('Mit MakroBoard verbinden'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            // border: OutlineInputBorder(),
                            labelText: "Host",
                            prefixIcon: Icon(Icons.dns_outlined),
                          ),
                          initialValue: Settings.getValue("server_host", "https://"),
                          validator: (value) {
                            if (value == null) {
                              return "Um fortzufahren wird ein Host benötigt.";
                            }

                            var uri = Uri.tryParse(value);
                            if (uri == null) {
                              return "Der Host \"value\" ist keine gültige URI";
                            }
                            if (!uri.isScheme("https")) {
                              return "Der Host ist kein https-Host";
                            }
                            return null;
                          },
                          onChanged: (value) async {
                            await Settings.setValue("server_host", value);
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            // border: OutlineInputBorder(),
                            labelText: "Port",
                            prefixIcon: Icon(Icons.tag),
                          ),
                          keyboardType: TextInputType.number,
                          initialValue: Settings.getValue("server_port", "5001"),
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], // Only number
                          validator: (value) {
                            if (value == null) {
                              return "Um fortzufahren wird ein Port benötigt.";
                            }

                            var port = int.parse(value);
                            if (port < 1024) {
                              return "System Ports dürfen nicht verwendet werden. Min. Port: 1024";
                            }

                            if (port > 49151) {
                              return "Dynamic Ports dürfen nicht verwendet werden. Max. Port: 49151";
                            }

                            return null;
                          },
                          onChanged: (value) async {
                            await Settings.setValue("server_port", value);
                          },
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              // onPressed: () => Modular.to.navigate('/login'),
                              onPressed: () async {
                                EasyLoading.show(status: 'verbinden ...');
                                if (_loginFormKey.currentState!.validate()) {
                                  var port = int.parse(Settings.getValue("server_port", "5001"));
                                  var serverUriString = Settings.getValue("server_host", "");
                                  var serverUri = Uri.parse(serverUriString);
                                  serverUri = serverUri.replace(port: port);
                                  if (await Modular.get<ApiProvider>().initialize(serverUri)) {
                                    var isAuthenticated = await Modular.get<AuthProvider>().isAuthenticated();
                                    if (isAuthenticated) {
                                      Modular.to.navigate('/home');
                                    } else {
                                      Modular.to.navigate('/login');
                                    }
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                                  } else {
                                    EasyLoading.showError("Es konnte keine Verbindung hergestellt werden: " + serverUri.toString(), dismissOnTap: true);
                                  }
                                }
                                EasyLoading.dismiss();
                              },
                              child: Text("Connect"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.cloud_download),
                        title: const Text('Jetzt MakroBoard Host installieren'),
                      ),
                      Text("Wenn Sie noch keine MakroBoard Installation haben, ..."),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            var url = "https://makroboard.app";
                            if (await canLaunch(url)) {
                              await launch(
                                url,
                                forceSafariVC: true,
                                forceWebView: true,
                                headers: <String, String>{'my_header_key': 'my_header_value'},
                              );
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          icon: Icon(Icons.file_download),
                          label: Text("https://makroboard.app"),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
