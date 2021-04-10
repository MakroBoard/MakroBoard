import 'dart:async';
import 'dart:math';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:macro_board/models/login_code.dart';

import 'api_provider.dart';

@Injectable() // ← Injectable annotation
class AuthProvider {
  final ApiProvider apiProvider;
  AuthProvider({
    required this.apiProvider, // ← The parameters of the constructur will define the generated binding
  });

  Future<bool> isAuthenticated() async {
    return await apiProvider.isAuthenticated();
  }

  Future<bool> waitForAuthenticated() async {
    var token = await apiProvider.token.first;

    return true;
  }

  Stream<LoginCode> submitCode() async* {
    while (!(await isAuthenticated())) {
      var loginCode = await _getNewLoginCode();
      Duration timerDuration = loginCode.validUntil.difference(DateTime.now());
      yield loginCode;
      await Future.delayed(timerDuration);
    }
  }

  Future<LoginCode> _getNewLoginCode() async {
    Random random = new Random();

    //Random 10000 - 99999
    int randomNumber = 10000 + random.nextInt(89999);

    try {
      var dateTime = await apiProvider.submitCode(randomNumber);
      return LoginCode(code: randomNumber, validUntil: dateTime);
    } on Exception catch (e) {
      print('never reached' + e.toString());
    }

    return LoginCode(code: -1, validUntil: DateTime.now());
  }
}
