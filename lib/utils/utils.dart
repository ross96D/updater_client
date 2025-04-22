
abstract class ToJson {
  const ToJson();
  Object toJson();
}

abstract class Err {
  const Err();
  String error();
}

class StringError extends Err {
  final String message;
  const StringError(this.message);

  @override
  String error() {
    return message;
  }
}

/// Ligthweigth class representing an empty value or void
/// but that can be used as an argument in functions
class Void {
  static const _instance = Void._internal();
  const Void._internal();
  /// Ligthweigth class representing an empty value or void
  /// but that can be used as an argument in functions
  factory Void() => _instance;
}

class Result<T extends Object, E extends Err> {
  bool _isSuccess;
  Object _value;

  Result._({required bool tag, required Object value}) : _value = value, _isSuccess = tag;

  factory Result.error(E error) {
    return Result._(tag: false, value: error);
  }

  factory Result.success(T value) {
    return Result._(tag: true, value: value);
  }

  bool isError() {
    return !_isSuccess;
  }

  bool isSuccess() {
    return _isSuccess;
  }

  T unsafeGetSuccess() {
    return _value as T;
  }

  E unsafeGetError() {
    return _value as E;
  }

  R match<R>({required R Function(T) onSuccess, required R Function(E) onError}) {
    if (_isSuccess) {
      return onSuccess(_value as T);
    } else {
      return onError(_value as E);
    }
  }

  @override
  String toString() {
    return match(
      onSuccess: (v) => "Result success $v",
      onError: (e) => "Result error $e",
    );
  }
}

Result<Uri, Err> parseUrl(String url, {
  bool requireScheme = true,
  bool requireHost = true,
}) {
  String remaining = url;
  String? fragment;
  String? query;
  String? scheme;
  String host = '';
  int? port;
  String path = '';

  // Extract fragment
  final fragmentIndex = remaining.indexOf('#');
  if (fragmentIndex != -1) {
    fragment = remaining.substring(fragmentIndex + 1);
    remaining = remaining.substring(0, fragmentIndex);
  }

  // Extract query
  final queryIndex = remaining.indexOf('?');
  if (queryIndex != -1) {
    query = remaining.substring(queryIndex + 1);
    remaining = remaining.substring(0, queryIndex);
  }

  // Extract scheme
  final schemeIndex = remaining.indexOf('://');
  if (schemeIndex != -1) {
    scheme = remaining.substring(0, schemeIndex);
    remaining = remaining.substring(schemeIndex + 3);
  } else if (requireScheme) {
    return Result.error(const StringError("scheme is missing"));
  }

  // Extract authority and path
  final pathIndex = remaining.indexOf('/');
  if (pathIndex != -1) {
    path = remaining.substring(pathIndex);
    remaining = remaining.substring(0, pathIndex);
  } else {
    path = '';
  }

  // Extract host and port from authority
  final authority = remaining;
  final portIndex = authority.indexOf(':');
  if (portIndex != -1) {
    host = authority.substring(0, portIndex);
    final portString = authority.substring(portIndex + 1);
    try {
      port = int.parse(portString);
    } catch (e)  {
      return Result.error(StringError("$e"));
    }
    if (port < 1 || port > 65535) {
      return Result.error(const StringError("invalid port number. Must be between 1 and 65535"));
    }
  } else {
    host = authority;
  }
  if (host == "" && requireHost) {
    return Result.error(const StringError("host is missing"));
  }

  return Result.success(Uri(
    scheme: scheme,
    host: host,
    port: port,
    path: path.isEmpty && (scheme != null || authority.isNotEmpty) ? '/' : path,
    query: query,
    fragment: fragment,
  ));
}
