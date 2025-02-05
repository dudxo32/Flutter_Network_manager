class BaseBody {
  final String? version;
  final String? method;
  final String? endpoint;
  final Status status;
  final dynamic results;

  BaseBody({
    required this.version,
    required this.method,
    required this.endpoint,
    required this.status,
    required this.results,
  });

  factory BaseBody.fromJson(Map<String, dynamic> map) {
    return BaseBody(
      version: map['version'] as String?,
      method: map['method'] as String?,
      endpoint: map['endpoint'] as String?,
      status: Status.fromJson(map['status'] as Map<String, dynamic>),
      results: map['results'] as dynamic,
    );
  }
}

class Status {
  final int code;
  final String? message;
  final String? summary;

  Status({required this.code, required this.message, required this.summary});

  factory Status.fromJson(Map<String, dynamic> map) {
    return Status(
      code: map['status_code'] as int,
      message: map['status_message'] as String?,
      summary: map['status_summary'] as String?,
    );
  }
}
