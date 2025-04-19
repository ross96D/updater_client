
abstract class ToJson {
  const ToJson();
  Object toJson();
}

abstract class Err {
  const Err();
  String error();
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
  bool _tag;
  Object _value;

  Result._({required bool tag, required Object value}) : _value = value, _tag = tag;

  factory Result.error(E error) {
    return Result._(tag: false, value: error);
  }

  factory Result.success(T value) {
    return Result._(tag: false, value: value);
  }

  bool isError() {
    return !_tag;
  }

  bool isSuccess() {
    return _tag;
  }

  T unsafeGetSuccess() {
    return _value as T;
  }

  E unsafeGetError() {
    return _value as E;
  }

  R match<R>({required R Function(T) onSuccess, required R Function(E) onError}) {
    if (_tag) {
      return onSuccess(_value as T);
    } else {
      return onError(_value as E);
    }
  }
}
