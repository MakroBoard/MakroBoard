class Client {
  final int id;
  final int code;
  final String validUntil;
  final String? token;
  final String clientIp;
  final String registerDate;
  final String lastConnection;
  final int state;

  Client({
    required this.id,
    required this.code,
    required this.validUntil,
    required this.token,
    required this.clientIp,
    required this.registerDate,
    required this.lastConnection,
    required this.state,
  });

  Client.empty()
      : id = -1,
        code = -1,
        validUntil = '',
        token = '',
        clientIp = '',
        registerDate = '',
        lastConnection = '',
        state = -1;

  Client.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        clientIp = json["clientIp"],
        code = json["code"],
        lastConnection = json["lastConnection"],
        registerDate = json["registerDate"],
        state = json["state"],
        token = json["token"],
        validUntil = json["validUntil"];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientIp': clientIp,
      'code': code,
      'lastConnection': lastConnection,
      'registerDate': registerDate,
      'state': state,
      'token': token,
      'validUntil': validUntil,
    };
  }

  bool get isEmpty => id < 0;
}

class ClientState {
  static const none = 0;
  static const blocked = 10;
  static const confirmed = 100;
  static const admin = 1000;

  static String getText(int clientState) {
    switch (clientState) {
      case none:
        return "Benutzer nicht freigeschalten";
      case blocked:
        return "Benutzer gesperrt";
      case confirmed:
        return "Benutzer";
      case admin:
        return "Administrator";
      default:
        return "ClientState noch nicht unterstützt: $clientState";
    }
  }
}
