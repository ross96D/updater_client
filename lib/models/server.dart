import 'package:equatable/equatable.dart';
import 'package:updater_client/models/base.dart';
import 'package:updater_client/utils/formz.dart';
import 'package:updater_client/utils/utils.dart';

class Server extends BaseForm {
  final NonEmptyString name;
  final Address address;
  final NonEmptyString username;
  final NonEmptyString password;

  const Server({
    required this.name,
    required this.address,
    required this.username,
    required this.password,
  });

  Server copyWith({
    NonEmptyString? name,
    Address? address,
    NonEmptyString? username,
    NonEmptyString? password,
  }) {
    return Server(
      name: name ?? this.name,
      address: address ?? this.address,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  factory Server.emtpy() {
    return const Server(
      name: NonEmptyString.pure(),
      address: Address.pure(),
      username: NonEmptyString.pure(),
      password: NonEmptyString.pure(),
    );
  }

  @override
  List<Object?> get props => [name, address, username, password];

  @override
  List<FormzInput> get inputs => [name, address, username, password];

  @override
  Map<String, Object> toJson() {
    return {
      "name": name.value,
      "address": address.value,
      "username": username.value,
      "password": password.value
    };
  }

  factory Server.fromJson(Map<String, Object?> json) {
    try {
      return Server(
        name: NonEmptyString.pure(json["name"] as String),
        address: Address.pure(json["address"] as String),
        username: NonEmptyString.pure(json["username"] as String),
        password: NonEmptyString.pure(json["password"] as String),
      );
    } catch (_) {
      // TODO ??
      rethrow;
    }
  }
}

sealed class AddressValidationError extends ValidationError {}

class EmptyAddress extends AddressValidationError {
  @override
  String text() {
    return "Empty address is not allowed";
  }
}

class InvalidAddress extends AddressValidationError {
  InvalidAddress(this.error);
  String error;

  @override
  String text() {
    return error;
  }
}

class Address extends FormzInput<String, AddressValidationError> with EquatableMixin {
  const Address.pure([super.value = '']) : super.pure();
  const Address.dirty([super.value = '']) : super.dirty();

  @override
  List<Object?> get props => [super.value];

  @override
  AddressValidationError? validator(String value) {
    if (value == "") {
      return EmptyAddress();
    }
    final result = parseUrl(value);
    if (result.isError()) {
      final error = result.unsafeGetError();
      return InvalidAddress(error.error());
    }
    final uri = result.unsafeGetSuccess();
    if (!uri.isScheme("http") && !uri.isScheme("https")) {
      return InvalidAddress("Unsupported scheme '${uri.scheme}' (http or https only)");
    }
    return null;
  }
}

class Password extends FormzInput<String, ValidationError> with EquatableMixin {
  const Password.pure([super.value = '']) : super.pure();
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  List<Object?> get props => [super.value];

  @override
  ValidationError? validator(String value) {
    return null;
  }
}
