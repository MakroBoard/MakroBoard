// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Request _$RequestFromJson(Map<String, dynamic> json) {
  return Request();
}

Map<String, dynamic> _$RequestToJson(Request instance) => <String, dynamic>{};

Response _$ResponseFromJson(Map<String, dynamic> json) {
  return Response(
    _$enumDecode(_$ResponseStatusEnumMap, json['status']),
    json['errorMessage'] as String,
  );
}

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'errorMessage': instance.errorMessage,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ResponseStatusEnumMap = {
  ResponseStatus.Ok: 0,
  ResponseStatus.Error: 1,
};

RequestTokensResponse _$RequestTokensResponseFromJson(
    Map<String, dynamic> json) {
  return RequestTokensResponse(
    (json['clients'] as List<dynamic>)
        .map((e) => Client.fromJson(e as Map<String, dynamic>))
        .toList(),
    _$enumDecode(_$ResponseStatusEnumMap, json['status']),
    json['errorMessage'] as String,
  );
}

Map<String, dynamic> _$RequestTokensResponseToJson(
        RequestTokensResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'errorMessage': instance.errorMessage,
      'clients': instance.clients,
    };

CheckTokenResponse _$CheckTokenResponseFromJson(Map<String, dynamic> json) {
  return CheckTokenResponse(
    json['isValid'] as bool,
    _$enumDecode(_$ResponseStatusEnumMap, json['status']),
    json['errorMessage'] as String,
  );
}

Map<String, dynamic> _$CheckTokenResponseToJson(CheckTokenResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'errorMessage': instance.errorMessage,
      'isValid': instance.isValid,
    };

SubmitCodeRequest _$SubmitCodeRequestFromJson(Map<String, dynamic> json) {
  return SubmitCodeRequest(
    json['code'] as int,
  );
}

Map<String, dynamic> _$SubmitCodeRequestToJson(SubmitCodeRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
    };

SubmitCodeResponse _$SubmitCodeResponseFromJson(Map<String, dynamic> json) {
  return SubmitCodeResponse(
    json['validUntil'] as String,
    _$enumDecode(_$ResponseStatusEnumMap, json['status']),
    json['errorMessage'] as String,
  );
}

Map<String, dynamic> _$SubmitCodeResponseToJson(SubmitCodeResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'errorMessage': instance.errorMessage,
      'validUntil': instance.validUntil,
    };

ConfirmClientRequest _$ConfirmClientRequestFromJson(Map<String, dynamic> json) {
  return ConfirmClientRequest(
    Client.fromJson(json['client'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ConfirmClientRequestToJson(
        ConfirmClientRequest instance) =>
    <String, dynamic>{
      'client': instance.client,
    };

ConfirmClientResponse _$ConfirmClientResponseFromJson(
    Map<String, dynamic> json) {
  return ConfirmClientResponse(
    _$enumDecode(_$ResponseStatusEnumMap, json['status']),
    json['errorMessage'] as String,
  );
}

Map<String, dynamic> _$ConfirmClientResponseToJson(
        ConfirmClientResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'errorMessage': instance.errorMessage,
    };

RemoveClientRequest _$RemoveClientRequestFromJson(Map<String, dynamic> json) {
  return RemoveClientRequest(
    Client.fromJson(json['client'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RemoveClientRequestToJson(
        RemoveClientRequest instance) =>
    <String, dynamic>{
      'client': instance.client,
    };

RemoveClientResponse _$RemoveClientResponseFromJson(Map<String, dynamic> json) {
  return RemoveClientResponse(
    _$enumDecode(_$ResponseStatusEnumMap, json['status']),
    json['errorMessage'] as String,
  );
}

Map<String, dynamic> _$RemoveClientResponseToJson(
        RemoveClientResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'errorMessage': instance.errorMessage,
    };

AvailableControlsResponse _$AvailableControlsResponseFromJson(
    Map<String, dynamic> json) {
  return AvailableControlsResponse(
    (json['plugins'] as List<dynamic>)
        .map((e) => Plugin.fromJson(e as Map<String, dynamic>))
        .toList(),
    _$enumDecode(_$ResponseStatusEnumMap, json['status']),
    json['errorMessage'] as String,
  );
}

Map<String, dynamic> _$AvailableControlsResponseToJson(
        AvailableControlsResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'errorMessage': instance.errorMessage,
      'plugins': instance.plugins,
    };

ExecuteRequest _$ExecuteRequestFromJson(Map<String, dynamic> json) {
  return ExecuteRequest(
    json['symbolicName'] as String,
    (json['configValues'] as List<dynamic>)
        .map((e) => ViewConfigValue.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ExecuteRequestToJson(ExecuteRequest instance) =>
    <String, dynamic>{
      'symbolicName': instance.symbolicName,
      'configValues': instance.configValues,
    };

ExecuteResponse _$ExecuteResponseFromJson(Map<String, dynamic> json) {
  return ExecuteResponse(
    json['result'] as String,
    _$enumDecode(_$ResponseStatusEnumMap, json['status']),
    json['errorMessage'] as String,
  );
}

Map<String, dynamic> _$ExecuteResponseToJson(ExecuteResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'errorMessage': instance.errorMessage,
      'result': instance.result,
    };

AddPageRequest _$AddPageRequestFromJson(Map<String, dynamic> json) {
  return AddPageRequest(
    Page.fromJson(json['page'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AddPageRequestToJson(AddPageRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
    };

AddPageResponse _$AddPageResponseFromJson(Map<String, dynamic> json) {
  return AddPageResponse(
    _$enumDecode(_$ResponseStatusEnumMap, json['status']),
    json['errorMessage'] as String,
  );
}

Map<String, dynamic> _$AddPageResponseToJson(AddPageResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'errorMessage': instance.errorMessage,
    };

AddGroupRequest _$AddGroupRequestFromJson(Map<String, dynamic> json) {
  return AddGroupRequest(
    Group.fromJson(json['group'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AddGroupRequestToJson(AddGroupRequest instance) =>
    <String, dynamic>{
      'group': instance.group,
    };

AddGroupResponse _$AddGroupResponseFromJson(Map<String, dynamic> json) {
  return AddGroupResponse(
    _$enumDecode(_$ResponseStatusEnumMap, json['status']),
    json['errorMessage'] as String,
  );
}

Map<String, dynamic> _$AddGroupResponseToJson(AddGroupResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'errorMessage': instance.errorMessage,
    };

EditGroupRequest _$EditGroupRequestFromJson(Map<String, dynamic> json) {
  return EditGroupRequest(
    Group.fromJson(json['group'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$EditGroupRequestToJson(EditGroupRequest instance) =>
    <String, dynamic>{
      'group': instance.group,
    };

EditGroupResponse _$EditGroupResponseFromJson(Map<String, dynamic> json) {
  return EditGroupResponse(
    _$enumDecode(_$ResponseStatusEnumMap, json['status']),
    json['errorMessage'] as String,
  );
}

Map<String, dynamic> _$EditGroupResponseToJson(EditGroupResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'errorMessage': instance.errorMessage,
    };

RemoveGroupRequest _$RemoveGroupRequestFromJson(Map<String, dynamic> json) {
  return RemoveGroupRequest(
    json['groupId'] as int,
  );
}

Map<String, dynamic> _$RemoveGroupRequestToJson(RemoveGroupRequest instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
    };

RemoveGroupResponse _$RemoveGroupResponseFromJson(Map<String, dynamic> json) {
  return RemoveGroupResponse(
    _$enumDecode(_$ResponseStatusEnumMap, json['status']),
    json['errorMessage'] as String,
  );
}

Map<String, dynamic> _$RemoveGroupResponseToJson(
        RemoveGroupResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'errorMessage': instance.errorMessage,
    };

AddPanelRequest _$AddPanelRequestFromJson(Map<String, dynamic> json) {
  return AddPanelRequest(
    Panel.fromJson(json['panel'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AddPanelRequestToJson(AddPanelRequest instance) =>
    <String, dynamic>{
      'panel': instance.panel,
    };

AddPanelResponse _$AddPanelResponseFromJson(Map<String, dynamic> json) {
  return AddPanelResponse(
    _$enumDecode(_$ResponseStatusEnumMap, json['status']),
    json['errorMessage'] as String,
  );
}

Map<String, dynamic> _$AddPanelResponseToJson(AddPanelResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'errorMessage': instance.errorMessage,
    };
