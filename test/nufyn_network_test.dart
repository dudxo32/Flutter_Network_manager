import 'package:flutter_test/flutter_test.dart';
import 'package:nufyn_flutter_network_manager/api_context.dart';
import 'package:nufyn_flutter_network_manager/network.dart';
import 'package:nufyn_flutter_network_manager/network_response.dart';

class TestAC extends ApiContext<JsonMap, dynamic> {
  @override
  Protocol get protocol => Protocol.http;

  @override
  String get baseUrl => '43.202.51.79';

  @override
  String get startPoint => '/apis/client/v1/system';

  @override
  String get endPoint => '/policy';

  @override
  int? get port => 9802;

  @override
  HttpMethod get method => HttpMethod.get;

  @override
  Headers get headers => {};

  @override
  fromResponse(JsonMap response) {
    // TODO: implement fromResponse
    throw UnimplementedError();
  }

  @override
  RequestParams? get queryParameter => TestParemeter();

  @override
  RequestParams? get requestParameters => throw UnimplementedError();
}

class TestParemeter implements RequestParams {
  @override
  Map<String, dynamic> toJson() {
    return {'fd': 3};
  }
}

void main() {
  test('adds one to input values', () async {
    var e = await Network.current.request(TestAC());
  });
}
