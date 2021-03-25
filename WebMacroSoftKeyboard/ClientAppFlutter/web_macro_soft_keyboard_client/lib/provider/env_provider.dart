import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';

@Injectable() // ← Injectable annotation
class EnvProvider {
  String getBaseUrl() {
    if (kDebugMode) {
      if (kIsWeb) {
        return "localhost:5001";
      } else if (Platform.isAndroid) {
        return "10.0.2.2:5001";
      }
    }

    return "localhost:5001";
  }
}
