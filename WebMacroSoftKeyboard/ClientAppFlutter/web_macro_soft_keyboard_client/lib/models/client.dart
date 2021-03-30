class Client {
  final int ID;
  final int Code;
  final String ValidUntil;
  final String Token;
  final String ClientIp;
  final String RegisterDate;
  final String LastConnection;
  final int State;

  Client({
    required this.ID,
    required this.Code,
    required this.ValidUntil,
    required this.Token,
    required this.ClientIp,
    required this.RegisterDate,
    required this.LastConnection,
    required this.State,
  });
}
