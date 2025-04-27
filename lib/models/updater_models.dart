// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:updater_client/models/base.dart';

part 'updater_models.freezed.dart';
part 'updater_models.g.dart';

class ServerDataBase extends Base {
  final ServerData _field;
  const ServerDataBase(this._field);

  factory ServerDataBase.fromJson(Map<String, Object?> json) {
    return ServerDataBase(ServerData.fromJson(json));
  }

  @override
  List<Object?> get props => [_field];

  @override
  Object toJson() {
    return _field.toJson();
  }

  ServerData toServerData() {
    return _field;
  }
}

@freezed
class ServerData with _$ServerData {
  const factory ServerData({
    required List<Application> apps,
    required VersionData version,
  }) = _ServerData;

  factory ServerData.fromJson(Map<String, Object?> json) => _$ServerDataFromJson(json);
}

class VersionData {
  final int major;
  final int minor;
	final int patch;

	const VersionData([this.major = 0, this.minor = 0, this.patch = 0]);

	factory VersionData.fromJson(String json) {
	  final splitted = json.split(".");
		if (splitted.length != 3) {
		  throw FormatException("string must contain at least 2 dots", json);
		}
		final major = int.tryParse(splitted[0]);
		if (major == null) {
      throw FormatException("unable to parse major version", json, 0);
		}
		final minor = int.tryParse(splitted[1]);
		if (minor == null) {
      throw FormatException("unable to parse major version", json, splitted[0].length + 1);
		}
		final patch = int.tryParse(splitted[2]);
		if (patch == null) {
      throw FormatException("unable to parse major version", json, splitted[0].length + splitted[1].length + 2);
		}
	  return VersionData(major, minor, patch);
	}

	String toJson() {
	  return "$major.$minor.$patch";
	}

  @override
  String toString() {
    return toJson();
  }
}

@freezed
class Application with _$Application {
  const factory Application({
    required int index,

    required String name,

    @JsonKey(name: "auth_token")
    required String authToken,

    required String service,

    @JsonKey(name: "service_type")
    required String serviceType,

    required List<Asset> assets,

    @JsonKey(name: "cmd_pre")
    required Command? commandPre,

    @JsonKey(name: "cmd")
    required Command? command,

    @JsonKey(name: "github_release")
    required GithubRelease? githubRelease,
  }) = _Application;

  factory Application.fromJson(Map<String, Object?> json) => _$ApplicationFromJson(json);
}

@freezed
class GithubRelease with _$GithubRelease {
  const factory GithubRelease({
    required String token,
    required String repo,
    required String owner,
  }) = _GithubRelease;

  factory GithubRelease.fromJson(Map<String, Object?> json) => _$GithubReleaseFromJson(json);
}

@freezed
class Command with _$Command {
  const factory Command({
    required String command,
    required List<String> args,
    required String? path,
    required Map<String, String>? env,
  }) = _Command;

  factory Command.fromJson(Map<String, Object?> json) => _$CommandFromJson(json);
}

@freezed
class Asset with _$Asset {
  const factory Asset({
    required String name,

    @JsonKey(name: "system_path")
    required String systemPath,

    required String service,

    @JsonKey(name: "service_type")
    required String serviceType,

    @JsonKey(name: "keep_old")
    required bool keepOld,

    required bool unzip,

    @JsonKey(name: "cmd_pre")
    required Command? commandPre,

    @JsonKey(name: "cmd")
    required Command? command,
  }) = _Asset;

  factory Asset.fromJson(Map<String, Object?> json) => _$AssetFromJson(json);
}
