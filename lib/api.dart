import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

import 'package:updater_client/models/server.dart';
import 'package:updater_client/models/updater_models.dart';
import 'package:updater_client/utils/utils.dart';

sealed class ApiError extends Err with EquatableMixin {
  const ApiError();
}

class NotLoggedIn extends ApiError {
  const NotLoggedIn();

  @override
  String error() {
    return "not logged in";
  }

  @override
  List<Object?> get props => [];
}

class NetworkError extends ApiError {
  final String _error;
  NetworkError(this._error);

  @override
  String error() {
    return _error;
  }

  @override
  List<Object?> get props => [_error];
}

/// Server returned a 401 status code
class AuthenticationError extends ApiError {
  @override
  String error() {
    return "authentication error";
  }

  @override
  List<Object?> get props => [];
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

  @override
  List<Object?> get props => [_error, _status];
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

  @override
  List<Object?> get props => [_error, _status];
}

class JsonParseError extends ApiError {
  final String _error;
  final String? _source;

  const JsonParseError({required String error, String? source})
      : _source = source,
        _error = error;

  @override
  String error() {
    return "invalid json ${_source ?? ''}\n$_error\n";
  }

  @override
  List<Object?> get props => [_error, _source];
}

class ObjectParseError<T> extends ApiError {
  final String _error;
  const ObjectParseError(this._error);

  @override
  String error() {
    return "error parsing $T\n$_error";
  }

  @override
  List<Object?> get props => [_error];
}

class InvalidUriError extends ApiError {
  final String _error;
  final String? _source;

  const InvalidUriError({required String error, String? source})
      : _source = source,
        _error = error;

  @override
  String error() {
    return "invalid uri ${_source ?? ''}\n$_error\n";
  }

  @override
  List<Object?> get props => [_error, _source];
}

class UnexpectedResponseError extends ApiError {
  final String _error;
  final int _status;
  const UnexpectedResponseError(this._status, this._error);

  @override
  String error() {
    return "Unexpected response $_status\n$_error";
  }

  @override
  List<Object?> get props => [_error, _status];
}

sealed class SessionConnectionState with EquatableMixin {
  const SessionConnectionState();
}

class NotConnected extends SessionConnectionState {
  const NotConnected();

  @override
  List<Object?> get props => [];
}

class Connected extends SessionConnectionState {
  const Connected();

  @override
  List<Object?> get props => [];
}

class ConnectionError extends SessionConnectionState {
  final ApiError error;
  const ConnectionError(this.error);

  @override
  List<Object?> get props => [error];
}

sealed class UpgradeResponse {
  const UpgradeResponse();
}

class Upgrade extends UpgradeResponse {
  const Upgrade();
}

class UpToDate extends UpgradeResponse {
  const UpToDate();
}

sealed class _MethodHttp {}
class GET extends _MethodHttp {}
class POST extends _MethodHttp {}

class Session with EquatableMixin {
  final Server server;
  late final Uri url;
  final Completer<String?> token;
  final ValueNotifier<SessionConnectionState> state;

  @override
  List<Object?> get props => [server, url];

  Session(this.server)
      : token = Completer(),
        state = ValueNotifier(const NotConnected()) {
    url = Uri.parse(server.address.value);
  }

  Future<Result<T, E>> _call<T extends Object, E extends ApiError, V>(
    Future<Result<T, E>> Function(V) fn,
    V param,
  ) async {
    final result = await fn(param);
    if (result.isError()) {
      state.value = ConnectionError(result.unsafeGetError());
    } else {
      state.value = const Connected();
    }
    return result;
  }

  Future<Result<Void, ApiError>> open() async {
    return _call<Void, ApiError, Void>(_open, Void());
  }

  Future<Result<Void, ApiError>> _open(Void _) async {
    final uri = _join(url, "login");
    final client = HttpClient();

    HttpClientRequest request;
    try {
      request = await client.postUrl(uri);
    } catch (e) {
      token.complete(Future(() => null));
      return Result.error(NetworkError("$e"));
    }

    final basicAuth = utf8.encode("${server.username.value}:${server.password.value}");
    request.headers.set("Authorization", "Basic ${base64.encode(basicAuth)}");

    final result = await _doRequest(request);
    if (result.isError()) {
      token.complete(Future(() => null));
      return Result.error(result.unsafeGetError());
    }
    final response = result.unsafeGetSuccess();

    final error = await _checkStatus(response);
    if (error != null) {
      token.complete(Future(() => null));
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
    } catch (e) {
      return NetworkError(e.toString());
    }

    if (response.statusCode >= 500) {
      return ServerError(response.statusCode, resp);
    } else {
      return BadRequestError(response.statusCode, resp);
    }
  }

  Future<Result<HttpClientResponse, ApiError>> _initRequest(String p, _MethodHttp method) async {
    final uri = _join(url, p);
    final client = HttpClient();

    final token_ = await token.future;
    if (token_ == null) {
      return Result.error(const NotLoggedIn());
    }
    HttpClientRequest request;
    try {
      request = switch(method) {
        GET() => await client.getUrl(uri),
        POST() => await client.postUrl(uri),
      };
    } catch (e) {
      return Result.error(NetworkError("$e"));
    }
    request.headers.add(HttpHeaders.authorizationHeader, "Bearer $token_");

    return await _doRequest(request);
  }

  Future<Result<HttpClientResponse, ApiError>> _doRequest(HttpClientRequest request) async {
    HttpClientResponse response;
    try {
      response = await request.close();
    } catch (e) {
      return Result.error(NetworkError(e.toString()));
    }
    final error = await _checkStatus(response);
    if (error != null) {
      return Result.error(error);
    }
    return Result.success(response);
  }

  Future<Result<ServerData, ApiError>> list() async {
    // TODO change this to a name more accordingly to what really does
    return _call<ServerData, ApiError, Void>(_list, Void());
  }

  Future<Result<ServerData, ApiError>> _list(Void _) async {
    final result = await _initRequest("list", GET());
    if (result.isError()) {
      return Result.error(result.unsafeGetError());
    }
    final response = result.unsafeGetSuccess();
    String stringBody;
    try {
      stringBody = await response.transform(utf8.decoder).join("");
    } catch (e) {
      return Result.error(NetworkError(e.toString()));
    }
    return parseJsonObject(stringBody, ServerData.fromJson);
  }

  Future<Result<UpgradeResponse, ApiError>> upgrade() async {
    return _call<UpgradeResponse, ApiError, Void>(_upgrade, Void());
  }

  Future<Result<UpgradeResponse, ApiError>> _upgrade(Void _) async {
    final result = await _initRequest("upgrade", POST());
    return result.match<FutureOr<Result<UpgradeResponse, ApiError>>>(
      onSuccess: (v) async {
        if (v.statusCode == 200) {
          return Result.success(const Upgrade());
        } else if (v.statusCode == 204) {
          return Result.success(const UpToDate());
        }
        try {
          final resp = await v.transform(utf8.decoder).join("");
          return Result.error(UnexpectedResponseError(v.statusCode, resp));
        } catch (e) {
          return Result.error(UnexpectedResponseError(v.statusCode, "error reading response $e"));
        }
      },
      onError: (e) => Result.error(e),
    );
  }

  Future<Result<String, ApiError>> config() async {
    return _call<String, ApiError, Void>(_config, Void());
  }

  Future<Result<String, ApiError>> _config(Void _) async {
    final result = await _initRequest("config", GET());
    if (result.isError()) {
      return Result.error(result.unsafeGetError());
    }
    final response = result.unsafeGetSuccess();
    String stringBody;
    try {
      stringBody = await response.transform(utf8.decoder).join("");
    } catch (e) {
      return Result.error(NetworkError(e.toString()));
    }
    return Result.success(stringBody);
  }

  Future<Result<Void, ApiError>> reload() async {
    return _call<Void, ApiError, Void>(_reload, Void());
  }

  Future<Result<Void, ApiError>> _reload(Void _) async {
    // TODO add reload data
    final result = await _initRequest("reload", POST());
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
  } catch (e) {
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
