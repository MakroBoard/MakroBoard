import 'package:flutter_modular/flutter_modular.dart';
import 'package:web_macro_soft_keyboard_client/provider/auth_provider.dart';

class AuthGuard implements RouteGuard {
  @override
  Future<bool> canActivate(String url, ModularRoute route) async {
    var isAuth = await Modular.get<AuthProvider>().isAuthenticated();
    if (!isAuth) {
      Modular.to.pushNamed('/login');
    }
    return isAuth;
  }
}
