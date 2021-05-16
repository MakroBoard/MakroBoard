import 'package:json_annotation/json_annotation.dart';
import 'package:makro_board_client/models/Plugin.dart';
import '../ViewConfigValue.dart';
import '../client.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'Request.g.dart';

@JsonSerializable()
class Request {
  Request();

  factory Request.fromJson(Map<String, dynamic> json) => _$RequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestToJson(this);
}

@JsonSerializable()
class Response {
  final ResponseStatus status;
  final String errorMessage;

  Response(
    this.status,
    this.errorMessage,
  );

  factory Response.fromJson(Map<String, dynamic> json) => _$ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseToJson(this);
}

enum ResponseStatus {
  @JsonValue(0)
  Ok,

  @JsonValue(1)
  Error,
}

@JsonSerializable()
class RequestTokensResponse extends Response {
  final List<Client> clients;

  RequestTokensResponse(this.clients, ResponseStatus status, String errorMessage) : super(status, errorMessage);

  factory RequestTokensResponse.fromJson(Map<String, dynamic> json) => _$RequestTokensResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestTokensResponseToJson(this);
}

@JsonSerializable()
class CheckTokenResponse extends Response {
  final bool isValid;

  CheckTokenResponse(this.isValid, ResponseStatus status, String errorMessage) : super(status, errorMessage);

  factory CheckTokenResponse.fromJson(Map<String, dynamic> json) => _$CheckTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckTokenResponseToJson(this);
}

@JsonSerializable()
class SubmitCodeRequest extends Request {
  final int code;

  SubmitCodeRequest(this.code);

  factory SubmitCodeRequest.fromJson(Map<String, dynamic> json) => _$SubmitCodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitCodeRequestToJson(this);
}

@JsonSerializable()
class SubmitCodeResponse extends Response {
  final String validUntil;

  SubmitCodeResponse(this.validUntil, ResponseStatus status, String errorMessage) : super(status, errorMessage);
  factory SubmitCodeResponse.fromJson(Map<String, dynamic> json) => _$SubmitCodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitCodeResponseToJson(this);
}

@JsonSerializable()
class ConfirmClientRequest extends Request {
  final Client client;

  ConfirmClientRequest(this.client);

  factory ConfirmClientRequest.fromJson(Map<String, dynamic> json) => _$ConfirmClientRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmClientRequestToJson(this);
}

@JsonSerializable()
class ConfirmClientResponse extends Response {
  ConfirmClientResponse(ResponseStatus status, String errorMessage) : super(status, errorMessage);

  factory ConfirmClientResponse.fromJson(Map<String, dynamic> json) => _$ConfirmClientResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmClientResponseToJson(this);
}

@JsonSerializable()
class RemoveClientRequest extends Request {
  final Client client;

  RemoveClientRequest(this.client);

  factory RemoveClientRequest.fromJson(Map<String, dynamic> json) => _$RemoveClientRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveClientRequestToJson(this);
}

@JsonSerializable()
class RemoveClientResponse extends Response {
  RemoveClientResponse(ResponseStatus status, String errorMessage) : super(status, errorMessage);

  factory RemoveClientResponse.fromJson(Map<String, dynamic> json) => _$RemoveClientResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveClientResponseToJson(this);
}

@JsonSerializable()
class AvailableControlsResponse extends Response {
  final List<Plugin> plugins;

  AvailableControlsResponse(this.plugins, ResponseStatus status, String errorMessage) : super(status, errorMessage);

  factory AvailableControlsResponse.fromJson(Map<String, dynamic> json) => _$AvailableControlsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableControlsResponseToJson(this);
}

@JsonSerializable()
class ExecuteRequest extends Request {
  final String symbolicName;
  final List<ViewConfigValue> configValues;

  ExecuteRequest(this.symbolicName, this.configValues);

  factory ExecuteRequest.fromJson(Map<String, dynamic> json) => _$ExecuteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ExecuteRequestToJson(this);
}

@JsonSerializable()
class ExecuteResponse extends Response {
  ExecuteResponse(ResponseStatus status, String errorMessage) : super(status, errorMessage);

  factory ExecuteResponse.fromJson(Map<String, dynamic> json) => _$ExecuteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExecuteResponseToJson(this);
}
