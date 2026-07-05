enum HttpMethod { post, get, put, patch, delete }

abstract class RequestParameter {
  Map<String, dynamic> toJson();
}

abstract class ApiRequestBase {
  HttpMethod get method;

  String get path;

  bool get isNeedAuth;

  RequestParameter get parameter;
}
