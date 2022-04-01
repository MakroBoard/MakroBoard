import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:makro_board_client/app_state.dart';
import 'package:makro_board_client/provider/api_provider.dart';
import 'package:makro_board_client/provider/auth_provider.dart';
import 'package:makro_board_client/router/page_action.dart';
import 'package:makro_board_client/router/page_configuration.dart';
import 'package:makro_board_client/router/page_state.dart';
import 'package:makro_board_client/widgets/snack_bar_notification.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectServerPage extends StatelessWidget {
  const SelectServerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _loginFormKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // appBar: MakroBoardAppBar(title: "MakroBoard", showSettings: false).getAppBar(context),
      body: SnackBarNotification(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
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
                          const ListTile(
                            leading: Icon(Icons.cast_connected),
                            title: Text('Mit MakroBoard verbinden'),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              // border: OutlineInputBorder(),
                              labelText: "Host",
                              prefixIcon: Icon(Icons.dns_outlined),
                            ),
                            initialValue: Settings.getValue("server_host", "https://"),
                            validator: (value) {
                              if (value == null || value == "https://") {
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
                              if (value != "" && value != "https://" && value.startsWith("https://")) {
                                await Settings.setValue("server_host", value);
                              }
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
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
                                onPressed: () async {
                                  EasyLoading.show(status: 'verbinden ...');
                                  if (_loginFormKey.currentState!.validate()) {
                                    var port = int.parse(Settings.getValue("server_port", "0"));
                                    var serverUriString = Settings.getValue("server_host", "");
                                    if (port == 0) {
                                      await Settings.setValue("server_port", "5001");
                                      port = 5001;
                                    }
                                    var serverUri = Uri.parse(serverUriString);
                                    serverUri = serverUri.replace(port: port);
                                    var apiProvider = Provider.of<ApiProvider>(context, listen: false);
                                    if (await apiProvider.initialize(serverUri, AppLocalizations.of(context)!.localeName)) {
                                      var authProvider = Provider.of<AuthProvider>(context, listen: false);

                                      var loginCode = await authProvider.getNewLoginCode();
                                      await Settings.setValue("server_code", loginCode.code);

                                      var isAuthenticated = await authProvider.isAuthenticated();
                                      if (isAuthenticated) {
                                        Provider.of<AppState>(context, listen: false).navigateTo(PageAction(state: PageState.replaceAll, page: homePageConfig));
                                      } else {
                                        Provider.of<AppState>(context, listen: false).navigateTo(PageAction(state: PageState.replaceAll, page: loginPageConfig));
                                      }
                                    } else {
                                      EasyLoading.showError("Es konnte keine Verbindung hergestellt werden: " + serverUri.toString(), dismissOnTap: true);
                                    }
                                  }
                                  EasyLoading.dismiss();
                                },
                                child: const Text("Connect"),
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
                        const ListTile(
                          leading: Icon(Icons.cloud_download),
                          title: Text('Jetzt MakroBoard Host installieren'),
                        ),
                        const Text("Wenn Sie noch keine MakroBoard Installation haben, ..."),
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
                            icon: const Icon(Icons.file_download),
                            label: const Text("https://makroboard.app"),
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
      ),
    );
  }
}
