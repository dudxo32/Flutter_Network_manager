import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:nufyn_flutter_network_manager/api_context.dart';
import 'package:nufyn_flutter_network_manager/network_response.dart';

class Network {
  static const Network _instance = Network._internal();
  static Network get current => _instance;

  const Network._internal();

  Future<Response<P, R>> requestMultipartFile<P, R>(
    MultipartFileApiContext<P, R> context,
  ) async {
    String httpMethod = switch (context.method) {
      HttpMethod.put => 'PUT',
      HttpMethod.post => 'POST',
      HttpMethod.delete => 'DELETE',
      HttpMethod.patch => 'PATCH',
      HttpMethod.get => 'GET',
    };

    final headers = {
      ...context.headers,
      ...{'Content-Type': 'multipart/form-data'}
    };

    final requestParams = switch (context.method) {
      HttpMethod.get => null,
      HttpMethod.put ||
      HttpMethod.post ||
      HttpMethod.delete ||
      HttpMethod.patch =>
        context.requestParameters?.toJson().map((key, value) {
          return MapEntry(key, value.toString());
        }),
    };

    final request = http.MultipartRequest(httpMethod, context.url)
      ..headers.addAll(headers)
      ..fields.addAll(requestParams ?? {})
      ..files.addAll(context.files ?? const Iterable.empty());

    try {
      final streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      return await _responseHandler(response, context);
    } catch (e) {
      rethrow;
    }
  }

  String? _createBody(ApiContext context) {
    switch (context.method) {
      case HttpMethod.get:
        return null;
      case HttpMethod.put:
      case HttpMethod.post:
      case HttpMethod.delete:
      case HttpMethod.patch:
        final json = context.requestParameters?.toJson();
        return json == null ? null : jsonEncode(json);
    }
  }

  Future<Response<P, R>> request<P, R>(
    ApiContext<P, R> context,
  ) async {
    try {
      final ApiContext(:url, :headers) = context;

      final body = _createBody(context);

      final response = await Future(
        () => switch (context.method) {
          HttpMethod.put => http.put(url, headers: headers, body: body),
          HttpMethod.post => http.post(url, headers: headers, body: body),
          HttpMethod.delete => http.delete(url, headers: headers, body: body),
          HttpMethod.patch => http.patch(url, headers: headers, body: body),
          HttpMethod.get => http.get(url, headers: headers),
        },
      );

      return await _responseHandler(response, context);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<P, R>> _responseHandler<P, R>(
    http.Response response,
    ApiContext<P, R> targetAPI,
  ) async {
    if (response.statusCode != 200) {
      final exception = NetworkException(
        errorCode: response.statusCode,
        errorMsg: response.reasonPhrase,
        response: response,
      );

      throw exception;
    }

    try {
      return Response(response, targetAPI.fromResponse);
    } catch (e, s) {
      _exceptionLogger(e, s, targetAPI);
      rethrow;
    }
  }

  void _exceptionLogger<T>(Object e, StackTrace s, ApiContext targetAPI) {
    if (e is ServerException) {
      String getLog() {
        try {
          return '서버에서 전달된 에러입니다.\n ${targetAPI.url.toString()}\nRequest:${targetAPI.requestParameters}';
        } catch (e) {
          return '서버에서 전달된 에러입니다.\n ${targetAPI.url.toString()}';
        }
      }

      log(getLog(), error: e);
    } else if (e is NetworkException) {
      log('네트워크 통신 실패 에러입니다.\n${targetAPI.url.toString()}',
          error: e.response?.request?.url);
    } else {
      log('${e.runtimeType} UnHandling Error!! \n$s', error: e);
    }
  }
}
