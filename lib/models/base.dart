import 'package:equatable/equatable.dart';
import 'package:updater_client/utils/formz.dart';
import 'package:updater_client/utils/utils.dart';

abstract class Base extends ToJson with EquatableMixin {
  const Base();
}

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
