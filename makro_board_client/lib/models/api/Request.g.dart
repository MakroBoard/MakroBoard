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
