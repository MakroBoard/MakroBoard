// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Request _$RequestFromJson(Map<String, dynamic> json) => Request();

Map<String, dynamic> _$RequestToJson(Request instance) => <String, dynamic>{};

Response _$ResponseFromJson(Map<String, dynamic> json) => Response(
      _$enumDecode(_$ResponseStatusEnumMap, json['status']),
      json['error'] as String?,
    );

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'error': instance.error,
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
        Map<String, dynamic> json) =>
    RequestTokensResponse(
      (json['clients'] as List<dynamic>)
          .map((e) => Client.fromJson(e as Map<String, dynamic>))
          .toList(),
      _$enumDecode(_$ResponseStatusEnumMap, json['status']),
      json['error'] as String?,
    );

Map<String, dynamic> _$RequestTokensResponseToJson(
        RequestTokensResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'error': instance.error,
      'clients': instance.clients,
    };

CheckTokenResponse _$CheckTokenResponseFromJson(Map<String, dynamic> json) =>
    CheckTokenResponse(
      json['isValid'] as bool,
      _$enumDecode(_$ResponseStatusEnumMap, json['status']),
      json['error'] as String?,
    );

Map<String, dynamic> _$CheckTokenResponseToJson(CheckTokenResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'error': instance.error,
      'isValid': instance.isValid,
    };

SubmitCodeRequest _$SubmitCodeRequestFromJson(Map<String, dynamic> json) =>
    SubmitCodeRequest(
      json['code'] as int,
    );

Map<String, dynamic> _$SubmitCodeRequestToJson(SubmitCodeRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
    };

SubmitCodeResponse _$SubmitCodeResponseFromJson(Map<String, dynamic> json) =>
    SubmitCodeResponse(
      json['validUntil'] as String,
      _$enumDecode(_$ResponseStatusEnumMap, json['status']),
      json['error'] as String?,
    );

Map<String, dynamic> _$SubmitCodeResponseToJson(SubmitCodeResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'error': instance.error,
      'validUntil': instance.validUntil,
    };

ConfirmClientRequest _$ConfirmClientRequestFromJson(
        Map<String, dynamic> json) =>
    ConfirmClientRequest(
      Client.fromJson(json['client'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ConfirmClientRequestToJson(
        ConfirmClientRequest instance) =>
    <String, dynamic>{
      'client': instance.client,
    };

ConfirmClientResponse _$ConfirmClientResponseFromJson(
        Map<String, dynamic> json) =>
    ConfirmClientResponse(
      _$enumDecode(_$ResponseStatusEnumMap, json['status']),
      json['error'] as String?,
    );

Map<String, dynamic> _$ConfirmClientResponseToJson(
        ConfirmClientResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'error': instance.error,
    };

RemoveClientRequest _$RemoveClientRequestFromJson(Map<String, dynamic> json) =>
    RemoveClientRequest(
      Client.fromJson(json['client'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RemoveClientRequestToJson(
        RemoveClientRequest instance) =>
    <String, dynamic>{
      'client': instance.client,
    };

RemoveClientResponse _$RemoveClientResponseFromJson(
        Map<String, dynamic> json) =>
    RemoveClientResponse(
      _$enumDecode(_$ResponseStatusEnumMap, json['status']),
      json['error'] as String?,
    );

Map<String, dynamic> _$RemoveClientResponseToJson(
        RemoveClientResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'error': instance.error,
    };

AvailableControlsResponse _$AvailableControlsResponseFromJson(
        Map<String, dynamic> json) =>
    AvailableControlsResponse(
      (json['plugins'] as List<dynamic>)
          .map((e) => Plugin.fromJson(e as Map<String, dynamic>))
          .toList(),
      _$enumDecode(_$ResponseStatusEnumMap, json['status']),
      json['error'] as String?,
    );

Map<String, dynamic> _$AvailableControlsResponseToJson(
        AvailableControlsResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'error': instance.error,
      'plugins': instance.plugins,
    };

ExecuteRequest _$ExecuteRequestFromJson(Map<String, dynamic> json) =>
    ExecuteRequest(
      json['symbolicName'] as String,
      (json['configValues'] as List<dynamic>)
          .map((e) => ViewConfigValue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExecuteRequestToJson(ExecuteRequest instance) =>
    <String, dynamic>{
      'symbolicName': instance.symbolicName,
      'configValues': instance.configValues,
    };

ExecuteResponse _$ExecuteResponseFromJson(Map<String, dynamic> json) =>
    ExecuteResponse(
      json['result'] as String,
      _$enumDecode(_$ResponseStatusEnumMap, json['status']),
      json['error'] as String?,
    );

Map<String, dynamic> _$ExecuteResponseToJson(ExecuteResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'error': instance.error,
      'result': instance.result,
    };

AddPageRequest _$AddPageRequestFromJson(Map<String, dynamic> json) =>
    AddPageRequest(
      Page.fromJson(json['page'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddPageRequestToJson(AddPageRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
    };

AddPageResponse _$AddPageResponseFromJson(Map<String, dynamic> json) =>
    AddPageResponse(
      _$enumDecode(_$ResponseStatusEnumMap, json['status']),
      json['error'] as String?,
    );

Map<String, dynamic> _$AddPageResponseToJson(AddPageResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'error': instance.error,
    };

EditPageRequest _$EditPageRequestFromJson(Map<String, dynamic> json) =>
    EditPageRequest(
      Page.fromJson(json['page'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EditPageRequestToJson(EditPageRequest instance) =>
    <String, dynamic>{
      'page': instance.page,
    };

EditPageResponse _$EditPageResponseFromJson(Map<String, dynamic> json) =>
    EditPageResponse(
      _$enumDecode(_$ResponseStatusEnumMap, json['status']),
      json['error'] as String?,
    );

Map<String, dynamic> _$EditPageResponseToJson(EditPageResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'error': instance.error,
    };

AddGroupRequest _$AddGroupRequestFromJson(Map<String, dynamic> json) =>
    AddGroupRequest(
      Group.fromJson(json['group'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddGroupRequestToJson(AddGroupRequest instance) =>
    <String, dynamic>{
      'group': instance.group,
    };

AddGroupResponse _$AddGroupResponseFromJson(Map<String, dynamic> json) =>
    AddGroupResponse(
      _$enumDecode(_$ResponseStatusEnumMap, json['status']),
      json['error'] as String?,
    );

Map<String, dynamic> _$AddGroupResponseToJson(AddGroupResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'error': instance.error,
    };

EditGroupRequest _$EditGroupRequestFromJson(Map<String, dynamic> json) =>
    EditGroupRequest(
      Group.fromJson(json['group'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EditGroupRequestToJson(EditGroupRequest instance) =>
    <String, dynamic>{
      'group': instance.group,
    };

EditGroupResponse _$EditGroupResponseFromJson(Map<String, dynamic> json) =>
    EditGroupResponse(
      _$enumDecode(_$ResponseStatusEnumMap, json['status']),
      json['error'] as String?,
    );

Map<String, dynamic> _$EditGroupResponseToJson(EditGroupResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'error': instance.error,
    };

RemoveGroupRequest _$RemoveGroupRequestFromJson(Map<String, dynamic> json) =>
    RemoveGroupRequest(
      json['groupId'] as int,
    );

Map<String, dynamic> _$RemoveGroupRequestToJson(RemoveGroupRequest instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
    };

RemoveGroupResponse _$RemoveGroupResponseFromJson(Map<String, dynamic> json) =>
    RemoveGroupResponse(
      _$enumDecode(_$ResponseStatusEnumMap, json['status']),
      json['error'] as String?,
    );

Map<String, dynamic> _$RemoveGroupResponseToJson(
        RemoveGroupResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'error': instance.error,
    };

AddPanelRequest _$AddPanelRequestFromJson(Map<String, dynamic> json) =>
    AddPanelRequest(
      Panel.fromJson(json['panel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddPanelRequestToJson(AddPanelRequest instance) =>
    <String, dynamic>{
      'panel': instance.panel,
    };

AddPanelResponse _$AddPanelResponseFromJson(Map<String, dynamic> json) =>
    AddPanelResponse(
      _$enumDecode(_$ResponseStatusEnumMap, json['status']),
      json['error'] as String?,
    );

Map<String, dynamic> _$AddPanelResponseToJson(AddPanelResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'error': instance.error,
    };

EditPanelRequest _$EditPanelRequestFromJson(Map<String, dynamic> json) =>
    EditPanelRequest(
      Panel.fromJson(json['panel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EditPanelRequestToJson(EditPanelRequest instance) =>
    <String, dynamic>{
      'panel': instance.panel,
    };

EditPanelResponse _$EditPanelResponseFromJson(Map<String, dynamic> json) =>
    EditPanelResponse(
      _$enumDecode(_$ResponseStatusEnumMap, json['status']),
      json['error'] as String?,
    );

Map<String, dynamic> _$EditPanelResponseToJson(EditPanelResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'error': instance.error,
    };

RemovePanelRequest _$RemovePanelRequestFromJson(Map<String, dynamic> json) =>
    RemovePanelRequest(
      json['panelId'] as int,
    );

Map<String, dynamic> _$RemovePanelRequestToJson(RemovePanelRequest instance) =>
    <String, dynamic>{
      'panelId': instance.panelId,
    };

RemovePanelResponse _$RemovePanelResponseFromJson(Map<String, dynamic> json) =>
    RemovePanelResponse(
      _$enumDecode(_$ResponseStatusEnumMap, json['status']),
      json['error'] as String?,
    );

Map<String, dynamic> _$RemovePanelResponseToJson(
        RemovePanelResponse instance) =>
    <String, dynamic>{
      'status': _$ResponseStatusEnumMap[instance.status],
      'error': instance.error,
    };
