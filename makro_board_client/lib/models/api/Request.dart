import 'package:json_annotation/json_annotation.dart';
import 'package:makro_board_client/models/Plugin.dart';
import 'package:makro_board_client/models/group.dart';
import '../ViewConfigValue.dart';
import '../client.dart';
import '../page.dart';
import '../panel.dart';

/// This file uses generated code
/// To Generate execute:
///
/// > flutter pub run build_runner watch
///
part 'Request.g.dart';

@JsonSerializable()
class Request {
  Request();

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestToJson(this);
}

@JsonSerializable()
class Response {
  final ResponseStatus status;
  final String? error;

  Response(
    this.status,
    this.error,
  );

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);

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

  RequestTokensResponse(this.clients, ResponseStatus status, String? error)
      : super(status, error);

  factory RequestTokensResponse.fromJson(Map<String, dynamic> json) =>
      _$RequestTokensResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestTokensResponseToJson(this);
}

@JsonSerializable()
class CheckTokenResponse extends Response {
  final bool isValid;

  CheckTokenResponse(this.isValid, ResponseStatus status, String? error)
      : super(status, error);

  factory CheckTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckTokenResponseToJson(this);
}

@JsonSerializable()
class SubmitCodeRequest extends Request {
  final int code;

  SubmitCodeRequest(this.code);

  factory SubmitCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitCodeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitCodeRequestToJson(this);
}

@JsonSerializable()
class SubmitCodeResponse extends Response {
  final String validUntil;

  SubmitCodeResponse(this.validUntil, ResponseStatus status, String? error)
      : super(status, error);
  factory SubmitCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitCodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitCodeResponseToJson(this);
}

@JsonSerializable()
class ConfirmClientRequest extends Request {
  final Client client;

  ConfirmClientRequest(this.client);

  factory ConfirmClientRequest.fromJson(Map<String, dynamic> json) =>
      _$ConfirmClientRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmClientRequestToJson(this);
}

@JsonSerializable()
class ConfirmClientResponse extends Response {
  ConfirmClientResponse(ResponseStatus status, String? error)
      : super(status, error);

  factory ConfirmClientResponse.fromJson(Map<String, dynamic> json) =>
      _$ConfirmClientResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmClientResponseToJson(this);
}

@JsonSerializable()
class RemoveClientRequest extends Request {
  final Client client;

  RemoveClientRequest(this.client);

  factory RemoveClientRequest.fromJson(Map<String, dynamic> json) =>
      _$RemoveClientRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveClientRequestToJson(this);
}

@JsonSerializable()
class RemoveClientResponse extends Response {
  RemoveClientResponse(ResponseStatus status, String? error)
      : super(status, error);

  factory RemoveClientResponse.fromJson(Map<String, dynamic> json) =>
      _$RemoveClientResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveClientResponseToJson(this);
}

@JsonSerializable()
class AvailableControlsResponse extends Response {
  final List<Plugin> plugins;

  AvailableControlsResponse(this.plugins, ResponseStatus status, String? error)
      : super(status, error);

  factory AvailableControlsResponse.fromJson(Map<String, dynamic> json) =>
      _$AvailableControlsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableControlsResponseToJson(this);
}

@JsonSerializable()
class ExecuteRequest extends Request {
  final String symbolicName;
  final List<ViewConfigValue> configValues;

  ExecuteRequest(this.symbolicName, this.configValues);

  factory ExecuteRequest.fromJson(Map<String, dynamic> json) =>
      _$ExecuteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ExecuteRequestToJson(this);
}

@JsonSerializable()
class ExecuteResponse extends Response {
  final String result;

  ExecuteResponse(this.result, ResponseStatus status, String? error)
      : super(status, error);

  factory ExecuteResponse.fromJson(Map<String, dynamic> json) =>
      _$ExecuteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExecuteResponseToJson(this);
}

@JsonSerializable()
class AddPageRequest extends Request {
  final Page page;

  AddPageRequest(this.page);

  factory AddPageRequest.fromJson(Map<String, dynamic> json) =>
      _$AddPageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddPageRequestToJson(this);
}

@JsonSerializable()
class AddPageResponse extends Response {
  AddPageResponse(ResponseStatus status, String? error) : super(status, error);

  factory AddPageResponse.fromJson(Map<String, dynamic> json) =>
      _$AddPageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddPageResponseToJson(this);
}

@JsonSerializable()
class EditPageRequest extends Request {
  final Page page;

  EditPageRequest(this.page);

  factory EditPageRequest.fromJson(Map<String, dynamic> json) =>
      _$EditPageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EditPageRequestToJson(this);
}

@JsonSerializable()
class EditPageResponse extends Response {
  EditPageResponse(ResponseStatus status, String? error) : super(status, error);

  factory EditPageResponse.fromJson(Map<String, dynamic> json) =>
      _$EditPageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EditPageResponseToJson(this);
}

@JsonSerializable()
class AddGroupRequest extends Request {
  final Group group;

  AddGroupRequest(this.group);

  factory AddGroupRequest.fromJson(Map<String, dynamic> json) =>
      _$AddGroupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddGroupRequestToJson(this);
}

@JsonSerializable()
class AddGroupResponse extends Response {
  AddGroupResponse(ResponseStatus status, String? error) : super(status, error);

  factory AddGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$AddGroupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddGroupResponseToJson(this);
}

@JsonSerializable()
class EditGroupRequest extends Request {
  final Group group;

  EditGroupRequest(this.group);

  factory EditGroupRequest.fromJson(Map<String, dynamic> json) =>
      _$EditGroupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EditGroupRequestToJson(this);
}

@JsonSerializable()
class EditGroupResponse extends Response {
  EditGroupResponse(ResponseStatus status, String? error)
      : super(status, error);

  factory EditGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$EditGroupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EditGroupResponseToJson(this);
}

@JsonSerializable()
class RemoveGroupRequest extends Request {
  final int groupId;

  RemoveGroupRequest(this.groupId);

  factory RemoveGroupRequest.fromJson(Map<String, dynamic> json) =>
      _$RemoveGroupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveGroupRequestToJson(this);
}

@JsonSerializable()
class RemoveGroupResponse extends Response {
  RemoveGroupResponse(ResponseStatus status, String? error)
      : super(status, error);

  factory RemoveGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$RemoveGroupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveGroupResponseToJson(this);
}

@JsonSerializable()
class AddPanelRequest extends Request {
  final Panel panel;

  AddPanelRequest(this.panel);

  factory AddPanelRequest.fromJson(Map<String, dynamic> json) =>
      _$AddPanelRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddPanelRequestToJson(this);
}

@JsonSerializable()
class AddPanelResponse extends Response {
  AddPanelResponse(ResponseStatus status, String? error) : super(status, error);

  factory AddPanelResponse.fromJson(Map<String, dynamic> json) =>
      _$AddPanelResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddPanelResponseToJson(this);
}

@JsonSerializable()
class EditPanelRequest extends Request {
  final Panel panel;

  EditPanelRequest(this.panel);

  factory EditPanelRequest.fromJson(Map<String, dynamic> json) =>
      _$EditPanelRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EditPanelRequestToJson(this);
}

@JsonSerializable()
class EditPanelResponse extends Response {
  EditPanelResponse(ResponseStatus status, String? error)
      : super(status, error);

  factory EditPanelResponse.fromJson(Map<String, dynamic> json) =>
      _$EditPanelResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EditPanelResponseToJson(this);
}

@JsonSerializable()
class RemovePanelRequest extends Request {
  final int panelId;

  RemovePanelRequest(this.panelId);

  factory RemovePanelRequest.fromJson(Map<String, dynamic> json) =>
      _$RemovePanelRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RemovePanelRequestToJson(this);
}

@JsonSerializable()
class RemovePanelResponse extends Response {
  RemovePanelResponse(ResponseStatus status, String? error)
      : super(status, error);

  factory RemovePanelResponse.fromJson(Map<String, dynamic> json) =>
      _$RemovePanelResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RemovePanelResponseToJson(this);
}
