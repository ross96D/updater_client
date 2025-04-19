
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:updater_client/models/server.dart';
import 'package:updater_client/models/updater_models.dart';
import 'package:updater_client/utils/utils.dart';

sealed class ApiError extends Err {
  const ApiError();
}

class NetworkError extends ApiError {
  final String _error;
  NetworkError(this._error);

  @override
  String error() {
    return _error;
  }
}

/// Server returned a 401 status code
class AuthenticationError extends ApiError {
  @override
  String error() {
    return "authentication error";
  }
}

/// Server returned a 5xx status code
class ServerError extends ApiError {
  final String _error;
  final int _status;
  const ServerError(this._status, this._error);

  @override
  String error() {
    return "status: $_status\n$_error";
  }
}

/// Server returned a 4xx status code
class BadRequestError extends ApiError {
  final String _error;
  final int _status;
  const BadRequestError(this._status, this._error);

  @override
  String error() {
    return "status: $_status\n$_error";
  }
}

class JsonParseError extends ApiError {
  final String _error;
  final String? _source;

  const JsonParseError({required String error, String? source}) : _source = source, _error = error;

  @override
  String error() {
    return "invalid json ${_source ?? ''}\n$_error\n";
  }
}

class ObjectParseError<T> extends ApiError {
  final String _error;
  const ObjectParseError(this._error);

  @override
  String error() {
    return "error parsing $T\n$_error";
  }
}

class Session {
  final Server server;
  late Uri url;
  Completer<String> token;

  Session(this.server): token = Completer() {
    url = Uri.parse(server.address.value);
  }

  Future<Result<Void, ApiError>> open() async {
    final uri = _join(url, "login");
    final client = HttpClient();
    final request = await client.postUrl(uri);

    final basicAuth = utf8.encode("${ server.username.value}:${server.password.value}");
    request.headers.set("Authorization", "Basic ${base64.encode(basicAuth)}");

    final result = await _doRequest(request);
    if (result.isError()) {
      return Result.error(result.unsafeGetError());
    }
    final response = result.unsafeGetSuccess();

    final error = await _checkStatus(response);
    if (error != null) {
      return Result.error(error);
    }

    token.complete(response.transform(utf8.decoder).join(""));

    return Result.success(Void());
  }

  Uri _join(Uri url, String p) {
    return Uri(
      scheme: url.scheme,
      userInfo: url.userInfo,
      host: url.host,
      port: url.port,
      path: path.join(url.path, p),
      query: url.query,
      fragment: url.fragment,
    );
  }

  Future<ApiError?> _checkStatus(HttpClientResponse response) async {
    if (response.statusCode < 400) {
      return null;
    }
    if (response.statusCode == 401) {
      return AuthenticationError();
    }
    String resp;
    try {
      resp = await response.transform(utf8.decoder).join();
    } catch(e) {
      return NetworkError(e.toString());
    }

    if (response.statusCode >= 500) {
      return ServerError(response.statusCode, resp);
    } else {
      return BadRequestError(response.statusCode, resp);
    }
  }

  Future<Result<HttpClientResponse, ApiError>> _initRequest(String p) async {
    final uri = _join(url, p);
    final client = HttpClient();
    final request = await client.getUrl(uri);
    request.headers.add(HttpHeaders.authorizationHeader, "Bearer ${await token.future}");

    return await _doRequest(request);
  }

  Future<Result<HttpClientResponse, ApiError>> _doRequest(HttpClientRequest request) async {
    HttpClientResponse response;
    try {
      response = await request.close();
    } catch(e) {
      return Result.error(NetworkError(e.toString()));
    }
    final error = await _checkStatus(response);
    if (error != null) {
      return Result.error(error);
    }
    return Result.success(response);
  }

  Future<Result<ServerData, ApiError>> list() async {
    final result =  await _initRequest("list");
    if (result.isError()) {
      return Result.error(result.unsafeGetError());
    }
    final response = result.unsafeGetSuccess();
    String stringBody;
    try {
      stringBody = await response.transform(utf8.decoder).join("");
    } catch(e) {
      return Result.error(NetworkError(e.toString()));
    }
    return parseJsonObject(stringBody, ServerData.fromJson);
  }

  Future<Result<Void, ApiError>> upgrade() async {
    final result =  await _initRequest("upgrade");
    if (result.isError()) {
      return Result.error(result.unsafeGetError());
    }
    return Result.success(Void());
  }

  Future<Result<String, ApiError>> config() async {
    final result =  await _initRequest("config");
    if (result.isError()) {
      return Result.error(result.unsafeGetError());
    }
    final response = result.unsafeGetSuccess();
    String stringBody;
    try {
      stringBody = await response.transform(utf8.decoder).join("");
    } catch(e) {
      return Result.error(NetworkError(e.toString()));
    }
    return Result.success(stringBody);
  }

  Future<Result<Void, ApiError>> reload() async {
    final result =  await _initRequest("reload");
    if (result.isError()) {
      return Result.error(result.unsafeGetError());
    }
    return Result.success(Void());
  }
}


Result<Obj, ApiError> parseJsonObject<Obj extends Object, T extends Object>(
  String body,
  Obj Function(T) fromJson,
) {
  Object jsonObj;
  try {
    jsonObj = json.decode(body);
  } catch(e) {
    return Result.error(JsonParseError(error: e.toString(), source: body));
  }
  if (jsonObj is! T) {
    return Result.error(ObjectParseError<Obj>(
      "expected a subclass of $T got ${jsonObj.runtimeType}\njson source $body",
    ));
  }
  try {
   return Result.success(fromJson(jsonObj));
  } catch (e) {
    return Result.error(ObjectParseError<Obj>(e.toString()));
  }
}
