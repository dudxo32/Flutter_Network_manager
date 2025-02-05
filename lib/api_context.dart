import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

typedef Headers = Map<String, String>;

enum HttpMethod {
  get,
  put,
  post,
  delete,
  patch,
}

enum Protocol { http, https }

abstract class RequestParams {
  Map<String, dynamic> toJson();
}

@protected
abstract class ApiContext<P, R> {
  Protocol get protocol;
  @protected
  int? get port;
  @protected
  String get baseUrl;
  @protected
  String get startPoint;
  @protected
  String get endPoint;

  Uri get url {
    final queryParameters = method == HttpMethod.get
        ? queryParameter?.toJson().map((key, value) {
            if (value == null) return MapEntry(key, null);
            if (value is String) return MapEntry(key, value);
            return MapEntry(key, jsonEncode(value));
          })
        : null;

    return Uri(
      scheme: protocol.name,
      host: baseUrl,
      port: port,
      path: startPoint + endPoint,
      queryParameters: queryParameters,
    );
  }

  Headers get headers;
  HttpMethod get method;
  RequestParams? get queryParameter;
  RequestParams? get requestParameters;
  R fromResponse(P response);
}

abstract class MultipartFileApiContext<P, R> extends ApiContext<P, R> {
  List<MultipartFile>? get files;
}
