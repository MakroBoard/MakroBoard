import 'dart:io';

class MakroboardHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final HttpClient client = super.createHttpClient(context)
      ..maxConnectionsPerHost = 5
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return client;
  }
}
