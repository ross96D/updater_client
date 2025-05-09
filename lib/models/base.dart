import 'package:equatable/equatable.dart';
import 'package:updater_client/utils/formz.dart';
import 'package:updater_client/utils/utils.dart';

abstract class Base extends ToJson with EquatableMixin {
  const Base();
}

mixin BaseMixin on Base {}

abstract class BaseForm extends Base with FormzMixin {
  const BaseForm();
}

class StringForm extends FormzInput<String, ValidationError> with EquatableMixin {
  const StringForm.pure([super.value = '']) : super.pure();
  const StringForm.dirty([super.value = '']) : super.dirty();

  @override
  ValidationError? validator(String value) { return null; }

  @override
  List<Object?> get props => [super.value];
}

class Emtpy extends ValidationError {
  static final _instance = Emtpy._internal();
  Emtpy._internal();
  factory Emtpy() => _instance;

  @override
  String text() {
    return "empty input is not allowed";
  }
}

class NonEmptyString extends FormzInput<String, Emtpy> with EquatableMixin {
  const NonEmptyString.pure([super.value = '']) : super.pure();
  const NonEmptyString.dirty([super.value = '']) : super.dirty();

  @override
  List<Object?> get props => [super.value];

  @override
  Emtpy? validator(String value) {
    return value == "" ? Emtpy() : null;
  }

}

class ServerConfiguration extends Base implements Comparable<String>, Pattern {
  final String _internal;

  ServerConfiguration(this._internal);
  factory ServerConfiguration.fromJson(String object) {
    return ServerConfiguration(object);
  }
  
  @override
  String toString() {
    return _internal;
  }

  @override
  List<Object?> get props => [_internal];
  
  @override
  Object toJson() {
    return _internal;
  }
  
  @override
  Iterable<Match> allMatches(String string, [int start = 0]) {
    return _internal.allMatches(string, start);
  }
  
  @override
  int compareTo(String other) {
    return _internal.compareTo(other);
  }
  
  @override
  Match? matchAsPrefix(String string, [int start = 0]) {
    return _internal.matchAsPrefix(string, start);
  }
}