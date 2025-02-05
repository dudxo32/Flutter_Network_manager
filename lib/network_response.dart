import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nufyn_flutter_network_manager/network_base_dto.dart';

typedef JsonMap = Map<String, dynamic>;

class Response<P, R> extends http.BaseResponse {
  final R Function(P json) from;
  late R body;

  Response(http.Response response, this.from)
      : super(
          response.statusCode,
          request: response.request,
          headers: response.headers,
          isRedirect: response.isRedirect,
          persistentConnection: response.persistentConnection,
          reasonPhrase: response.reasonPhrase,
          contentLength: response.contentLength,
        ) {
    final jsonResponse = jsonDecode(response.body);

    final responseData = BaseBody.fromJson(jsonResponse);

    switch (responseData.status.code) {
      case 204:
        this.body = from(null as dynamic);

      case 200:
        final responseK = from(responseData.results);

        this.body = responseK;

      default:
        final errorCode = responseData.status.code;
        final errorMsg = responseData.status.message;
        final summary = responseData.status.summary;
        final exception = ServerException(
          errorCode: errorCode,
          errorMsg: errorMsg,
          summary: summary,
          response: response,
        );

        throw exception;
    }
  }
}

class ServerException implements Exception {
  final int errorCode;
  final String? errorMsg;
  final String? summary;
  final http.BaseResponse response;

  ServerException({
    required this.errorCode,
    required this.errorMsg,
    required this.summary,
    required this.response,
  });

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '''
ServerException(
  errorCode: $errorCode
  errorMsg: $errorMsg
  summary: $summary
  response: $response
)
''';
  }
}

class NetworkException implements Exception {
  final int errorCode;
  final String? errorMsg;
  final http.Response? response;

  NetworkException({
    required this.errorCode,
    required this.errorMsg,
    required this.response,
  });

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '''
NetworkException(
  errorCode: $errorCode
  errorMsg: $errorMsg
  response: $response
)
    ''';
  }
}

// class BoolToIntConverter implements JsonConverter<bool, int> {
//   const BoolToIntConverter();

//   @override
//   bool fromJson(int json) {
//     return json == 0 ? false : true;
//   }

//   @override
//   int toJson(bool object) {
//     return !object ? 0 : 1;
//   }
// }

// /// String 으로 부터 dateTime 변환
// class DateTimeToStringConverter implements JsonConverter<DateTime, String> {
//   const DateTimeToStringConverter();

//   @override
//   DateTime fromJson(String json) => DateTime.parse(json);

//   @override
//   String toJson(DateTime date) => throw UnimplementedError();
// }
