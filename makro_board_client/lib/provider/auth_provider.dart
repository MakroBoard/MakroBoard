import 'dart:async';
import 'dart:math';

import 'package:makro_board_client/models/login_code.dart';

import 'api_provider.dart';

class AuthProvider {
  final ApiProvider apiProvider;
  AuthProvider({
    required this.apiProvider, // ← The parameters of the constructur will define the generated binding
  });

  Future<bool> isAuthenticated() async {
    return await apiProvider.isAuthenticated();
  }

  Stream<LoginCode> submitCode() async* {
    while (!(await isAuthenticated())) {
      var loginCode = await getNewLoginCode();
      Duration timerDuration = loginCode.validUntil.difference(DateTime.now());
      yield loginCode;
      await Future.delayed(timerDuration);
    }
  }

  Future<LoginCode> getNewLoginCode() async {
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
