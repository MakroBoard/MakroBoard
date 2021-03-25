import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:web_macro_soft_keyboard_client/models/login_code.dart';

import 'env_provider.dart';

@Injectable() // ← Injectable annotation
class AuthProvider {
  static const String checkTokenUrl = "/api/client/checktoken";
  static const String submitCodeUrl = "/api/client/submitcode";

  final EnvProvider envProvider;
  AuthProvider({
    required this.envProvider, // ← The parameters of the constructur will define the generated binding
  });

  Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('token');
    if (authToken == null) {
      return false;
    }
    Response response = await http.get(
      Uri.http(envProvider.getBaseUrl(), checkTokenUrl),
      headers: {HttpHeaders.authorizationHeader: authToken},
    );

    return true;
  }

  Stream<LoginCode> submitCode() async* {
    Random random = new Random();

    //Random 10000 - 99999
    int randomNumber = 10000 + random.nextInt(89999);

    try {
      Response response = await http.post(
        Uri.https(envProvider.getBaseUrl(), submitCodeUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(randomNumber),
      );
      var dateTime = DateTime.parse(json.decode(response.body));
      yield LoginCode(code: randomNumber, validUntil: dateTime);
    } on Exception catch (e) {
      print('never reached' + e.toString());
    }
  }
}
