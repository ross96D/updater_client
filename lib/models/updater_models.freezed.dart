// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'updater_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServerData _$ServerDataFromJson(Map<String, dynamic> json) {
  return _ServerData.fromJson(json);
}

/// @nodoc
mixin _$ServerData {
  List<Application> get apps => throw _privateConstructorUsedError;
  VersionData get version => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServerDataCopyWith<ServerData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServerDataCopyWith<$Res> {
  factory $ServerDataCopyWith(
          ServerData value, $Res Function(ServerData) then) =
      _$ServerDataCopyWithImpl<$Res, ServerData>;
  @useResult
  $Res call({List<Application> apps, VersionData version});
}

/// @nodoc
class _$ServerDataCopyWithImpl<$Res, $Val extends ServerData>
    implements $ServerDataCopyWith<$Res> {
  _$ServerDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apps = null,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      apps: null == apps
          ? _value.apps
          : apps // ignore: cast_nullable_to_non_nullable
              as List<Application>,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as VersionData,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServerDataImplCopyWith<$Res>
    implements $ServerDataCopyWith<$Res> {
  factory _$$ServerDataImplCopyWith(
          _$ServerDataImpl value, $Res Function(_$ServerDataImpl) then) =
      __$$ServerDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Application> apps, VersionData version});
}

/// @nodoc
class __$$ServerDataImplCopyWithImpl<$Res>
    extends _$ServerDataCopyWithImpl<$Res, _$ServerDataImpl>
    implements _$$ServerDataImplCopyWith<$Res> {
  __$$ServerDataImplCopyWithImpl(
      _$ServerDataImpl _value, $Res Function(_$ServerDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apps = null,
    Object? version = null,
  }) {
    return _then(_$ServerDataImpl(
      apps: null == apps
          ? _value._apps
          : apps // ignore: cast_nullable_to_non_nullable
              as List<Application>,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as VersionData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServerDataImpl implements _ServerData {
  const _$ServerDataImpl(
      {required final List<Application> apps, required this.version})
      : _apps = apps;

  factory _$ServerDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServerDataImplFromJson(json);

  final List<Application> _apps;
  @override
  List<Application> get apps {
    if (_apps is EqualUnmodifiableListView) return _apps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_apps);
  }

  @override
  final VersionData version;

  @override
  String toString() {
    return 'ServerData(apps: $apps, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerDataImpl &&
            const DeepCollectionEquality().equals(other._apps, _apps) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_apps), version);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerDataImplCopyWith<_$ServerDataImpl> get copyWith =>
      __$$ServerDataImplCopyWithImpl<_$ServerDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServerDataImplToJson(
      this,
    );
  }
}

abstract class _ServerData implements ServerData {
  const factory _ServerData(
      {required final List<Application> apps,
      required final VersionData version}) = _$ServerDataImpl;

  factory _ServerData.fromJson(Map<String, dynamic> json) =
      _$ServerDataImpl.fromJson;

  @override
  List<Application> get apps;
  @override
  VersionData get version;
  @override
  @JsonKey(ignore: true)
  _$$ServerDataImplCopyWith<_$ServerDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Application _$ApplicationFromJson(Map<String, dynamic> json) {
  return _Application.fromJson(json);
}

/// @nodoc
mixin _$Application {
  int get index => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: "auth_token")
  String get authToken => throw _privateConstructorUsedError;
  String get service => throw _privateConstructorUsedError;
  @JsonKey(name: "service_type")
  String get serviceType => throw _privateConstructorUsedError;
  List<Asset> get assets => throw _privateConstructorUsedError;
  @JsonKey(name: "cmd_pre")
  Command? get commandPre => throw _privateConstructorUsedError;
  @JsonKey(name: "cmd")
  Command? get command => throw _privateConstructorUsedError;
  @JsonKey(name: "github_release")
  GithubRelease? get githubRelease => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApplicationCopyWith<Application> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationCopyWith<$Res> {
  factory $ApplicationCopyWith(
          Application value, $Res Function(Application) then) =
      _$ApplicationCopyWithImpl<$Res, Application>;
  @useResult
  $Res call(
      {int index,
      String name,
      @JsonKey(name: "auth_token") String authToken,
      String service,
      @JsonKey(name: "service_type") String serviceType,
      List<Asset> assets,
      @JsonKey(name: "cmd_pre") Command? commandPre,
      @JsonKey(name: "cmd") Command? command,
      @JsonKey(name: "github_release") GithubRelease? githubRelease});

  $CommandCopyWith<$Res>? get commandPre;
  $CommandCopyWith<$Res>? get command;
  $GithubReleaseCopyWith<$Res>? get githubRelease;
}

/// @nodoc
class _$ApplicationCopyWithImpl<$Res, $Val extends Application>
    implements $ApplicationCopyWith<$Res> {
  _$ApplicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? name = null,
    Object? authToken = null,
    Object? service = null,
    Object? serviceType = null,
    Object? assets = null,
    Object? commandPre = freezed,
    Object? command = freezed,
    Object? githubRelease = freezed,
  }) {
    return _then(_value.copyWith(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      authToken: null == authToken
          ? _value.authToken
          : authToken // ignore: cast_nullable_to_non_nullable
              as String,
      service: null == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as String,
      serviceType: null == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String,
      assets: null == assets
          ? _value.assets
          : assets // ignore: cast_nullable_to_non_nullable
              as List<Asset>,
      commandPre: freezed == commandPre
          ? _value.commandPre
          : commandPre // ignore: cast_nullable_to_non_nullable
              as Command?,
      command: freezed == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as Command?,
      githubRelease: freezed == githubRelease
          ? _value.githubRelease
          : githubRelease // ignore: cast_nullable_to_non_nullable
              as GithubRelease?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CommandCopyWith<$Res>? get commandPre {
    if (_value.commandPre == null) {
      return null;
    }

    return $CommandCopyWith<$Res>(_value.commandPre!, (value) {
      return _then(_value.copyWith(commandPre: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CommandCopyWith<$Res>? get command {
    if (_value.command == null) {
      return null;
    }

    return $CommandCopyWith<$Res>(_value.command!, (value) {
      return _then(_value.copyWith(command: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GithubReleaseCopyWith<$Res>? get githubRelease {
    if (_value.githubRelease == null) {
      return null;
    }

    return $GithubReleaseCopyWith<$Res>(_value.githubRelease!, (value) {
      return _then(_value.copyWith(githubRelease: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApplicationImplCopyWith<$Res>
    implements $ApplicationCopyWith<$Res> {
  factory _$$ApplicationImplCopyWith(
          _$ApplicationImpl value, $Res Function(_$ApplicationImpl) then) =
      __$$ApplicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int index,
      String name,
      @JsonKey(name: "auth_token") String authToken,
      String service,
      @JsonKey(name: "service_type") String serviceType,
      List<Asset> assets,
      @JsonKey(name: "cmd_pre") Command? commandPre,
      @JsonKey(name: "cmd") Command? command,
      @JsonKey(name: "github_release") GithubRelease? githubRelease});

  @override
  $CommandCopyWith<$Res>? get commandPre;
  @override
  $CommandCopyWith<$Res>? get command;
  @override
  $GithubReleaseCopyWith<$Res>? get githubRelease;
}

/// @nodoc
class __$$ApplicationImplCopyWithImpl<$Res>
    extends _$ApplicationCopyWithImpl<$Res, _$ApplicationImpl>
    implements _$$ApplicationImplCopyWith<$Res> {
  __$$ApplicationImplCopyWithImpl(
      _$ApplicationImpl _value, $Res Function(_$ApplicationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? name = null,
    Object? authToken = null,
    Object? service = null,
    Object? serviceType = null,
    Object? assets = null,
    Object? commandPre = freezed,
    Object? command = freezed,
    Object? githubRelease = freezed,
  }) {
    return _then(_$ApplicationImpl(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      authToken: null == authToken
          ? _value.authToken
          : authToken // ignore: cast_nullable_to_non_nullable
              as String,
      service: null == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as String,
      serviceType: null == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String,
      assets: null == assets
          ? _value._assets
          : assets // ignore: cast_nullable_to_non_nullable
              as List<Asset>,
      commandPre: freezed == commandPre
          ? _value.commandPre
          : commandPre // ignore: cast_nullable_to_non_nullable
              as Command?,
      command: freezed == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as Command?,
      githubRelease: freezed == githubRelease
          ? _value.githubRelease
          : githubRelease // ignore: cast_nullable_to_non_nullable
              as GithubRelease?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicationImpl implements _Application {
  const _$ApplicationImpl(
      {required this.index,
      required this.name,
      @JsonKey(name: "auth_token") required this.authToken,
      required this.service,
      @JsonKey(name: "service_type") required this.serviceType,
      required final List<Asset> assets,
      @JsonKey(name: "cmd_pre") required this.commandPre,
      @JsonKey(name: "cmd") required this.command,
      @JsonKey(name: "github_release") required this.githubRelease})
      : _assets = assets;

  factory _$ApplicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationImplFromJson(json);

  @override
  final int index;
  @override
  final String name;
  @override
  @JsonKey(name: "auth_token")
  final String authToken;
  @override
  final String service;
  @override
  @JsonKey(name: "service_type")
  final String serviceType;
  final List<Asset> _assets;
  @override
  List<Asset> get assets {
    if (_assets is EqualUnmodifiableListView) return _assets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assets);
  }

  @override
  @JsonKey(name: "cmd_pre")
  final Command? commandPre;
  @override
  @JsonKey(name: "cmd")
  final Command? command;
  @override
  @JsonKey(name: "github_release")
  final GithubRelease? githubRelease;

  @override
  String toString() {
    return 'Application(index: $index, name: $name, authToken: $authToken, service: $service, serviceType: $serviceType, assets: $assets, commandPre: $commandPre, command: $command, githubRelease: $githubRelease)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.authToken, authToken) ||
                other.authToken == authToken) &&
            (identical(other.service, service) || other.service == service) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            const DeepCollectionEquality().equals(other._assets, _assets) &&
            (identical(other.commandPre, commandPre) ||
                other.commandPre == commandPre) &&
            (identical(other.command, command) || other.command == command) &&
            (identical(other.githubRelease, githubRelease) ||
                other.githubRelease == githubRelease));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      index,
      name,
      authToken,
      service,
      serviceType,
      const DeepCollectionEquality().hash(_assets),
      commandPre,
      command,
      githubRelease);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationImplCopyWith<_$ApplicationImpl> get copyWith =>
      __$$ApplicationImplCopyWithImpl<_$ApplicationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationImplToJson(
      this,
    );
  }
}

abstract class _Application implements Application {
  const factory _Application(
      {required final int index,
      required final String name,
      @JsonKey(name: "auth_token") required final String authToken,
      required final String service,
      @JsonKey(name: "service_type") required final String serviceType,
      required final List<Asset> assets,
      @JsonKey(name: "cmd_pre") required final Command? commandPre,
      @JsonKey(name: "cmd") required final Command? command,
      @JsonKey(name: "github_release")
      required final GithubRelease? githubRelease}) = _$ApplicationImpl;

  factory _Application.fromJson(Map<String, dynamic> json) =
      _$ApplicationImpl.fromJson;

  @override
  int get index;
  @override
  String get name;
  @override
  @JsonKey(name: "auth_token")
  String get authToken;
  @override
  String get service;
  @override
  @JsonKey(name: "service_type")
  String get serviceType;
  @override
  List<Asset> get assets;
  @override
  @JsonKey(name: "cmd_pre")
  Command? get commandPre;
  @override
  @JsonKey(name: "cmd")
  Command? get command;
  @override
  @JsonKey(name: "github_release")
  GithubRelease? get githubRelease;
  @override
  @JsonKey(ignore: true)
  _$$ApplicationImplCopyWith<_$ApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GithubRelease _$GithubReleaseFromJson(Map<String, dynamic> json) {
  return _GithubRelease.fromJson(json);
}

/// @nodoc
mixin _$GithubRelease {
  String get token => throw _privateConstructorUsedError;
  String get repo => throw _privateConstructorUsedError;
  String get owner => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GithubReleaseCopyWith<GithubRelease> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GithubReleaseCopyWith<$Res> {
  factory $GithubReleaseCopyWith(
          GithubRelease value, $Res Function(GithubRelease) then) =
      _$GithubReleaseCopyWithImpl<$Res, GithubRelease>;
  @useResult
  $Res call({String token, String repo, String owner});
}

/// @nodoc
class _$GithubReleaseCopyWithImpl<$Res, $Val extends GithubRelease>
    implements $GithubReleaseCopyWith<$Res> {
  _$GithubReleaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? repo = null,
    Object? owner = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      repo: null == repo
          ? _value.repo
          : repo // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GithubReleaseImplCopyWith<$Res>
    implements $GithubReleaseCopyWith<$Res> {
  factory _$$GithubReleaseImplCopyWith(
          _$GithubReleaseImpl value, $Res Function(_$GithubReleaseImpl) then) =
      __$$GithubReleaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, String repo, String owner});
}

/// @nodoc
class __$$GithubReleaseImplCopyWithImpl<$Res>
    extends _$GithubReleaseCopyWithImpl<$Res, _$GithubReleaseImpl>
    implements _$$GithubReleaseImplCopyWith<$Res> {
  __$$GithubReleaseImplCopyWithImpl(
      _$GithubReleaseImpl _value, $Res Function(_$GithubReleaseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? repo = null,
    Object? owner = null,
  }) {
    return _then(_$GithubReleaseImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      repo: null == repo
          ? _value.repo
          : repo // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GithubReleaseImpl implements _GithubRelease {
  const _$GithubReleaseImpl(
      {required this.token, required this.repo, required this.owner});

  factory _$GithubReleaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GithubReleaseImplFromJson(json);

  @override
  final String token;
  @override
  final String repo;
  @override
  final String owner;

  @override
  String toString() {
    return 'GithubRelease(token: $token, repo: $repo, owner: $owner)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GithubReleaseImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.repo, repo) || other.repo == repo) &&
            (identical(other.owner, owner) || other.owner == owner));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, token, repo, owner);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GithubReleaseImplCopyWith<_$GithubReleaseImpl> get copyWith =>
      __$$GithubReleaseImplCopyWithImpl<_$GithubReleaseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GithubReleaseImplToJson(
      this,
    );
  }
}

abstract class _GithubRelease implements GithubRelease {
  const factory _GithubRelease(
      {required final String token,
      required final String repo,
      required final String owner}) = _$GithubReleaseImpl;

  factory _GithubRelease.fromJson(Map<String, dynamic> json) =
      _$GithubReleaseImpl.fromJson;

  @override
  String get token;
  @override
  String get repo;
  @override
  String get owner;
  @override
  @JsonKey(ignore: true)
  _$$GithubReleaseImplCopyWith<_$GithubReleaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Command _$CommandFromJson(Map<String, dynamic> json) {
  return _Command.fromJson(json);
}

/// @nodoc
mixin _$Command {
  String get command => throw _privateConstructorUsedError;
  List<String> get args => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  Map<String, String> get env => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommandCopyWith<Command> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommandCopyWith<$Res> {
  factory $CommandCopyWith(Command value, $Res Function(Command) then) =
      _$CommandCopyWithImpl<$Res, Command>;
  @useResult
  $Res call(
      {String command,
      List<String> args,
      String path,
      Map<String, String> env});
}

/// @nodoc
class _$CommandCopyWithImpl<$Res, $Val extends Command>
    implements $CommandCopyWith<$Res> {
  _$CommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? command = null,
    Object? args = null,
    Object? path = null,
    Object? env = null,
  }) {
    return _then(_value.copyWith(
      command: null == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as String,
      args: null == args
          ? _value.args
          : args // ignore: cast_nullable_to_non_nullable
              as List<String>,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      env: null == env
          ? _value.env
          : env // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommandImplCopyWith<$Res> implements $CommandCopyWith<$Res> {
  factory _$$CommandImplCopyWith(
          _$CommandImpl value, $Res Function(_$CommandImpl) then) =
      __$$CommandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String command,
      List<String> args,
      String path,
      Map<String, String> env});
}

/// @nodoc
class __$$CommandImplCopyWithImpl<$Res>
    extends _$CommandCopyWithImpl<$Res, _$CommandImpl>
    implements _$$CommandImplCopyWith<$Res> {
  __$$CommandImplCopyWithImpl(
      _$CommandImpl _value, $Res Function(_$CommandImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? command = null,
    Object? args = null,
    Object? path = null,
    Object? env = null,
  }) {
    return _then(_$CommandImpl(
      command: null == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as String,
      args: null == args
          ? _value._args
          : args // ignore: cast_nullable_to_non_nullable
              as List<String>,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      env: null == env
          ? _value._env
          : env // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommandImpl implements _Command {
  const _$CommandImpl(
      {required this.command,
      required final List<String> args,
      required this.path,
      required final Map<String, String> env})
      : _args = args,
        _env = env;

  factory _$CommandImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommandImplFromJson(json);

  @override
  final String command;
  final List<String> _args;
  @override
  List<String> get args {
    if (_args is EqualUnmodifiableListView) return _args;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_args);
  }

  @override
  final String path;
  final Map<String, String> _env;
  @override
  Map<String, String> get env {
    if (_env is EqualUnmodifiableMapView) return _env;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_env);
  }

  @override
  String toString() {
    return 'Command(command: $command, args: $args, path: $path, env: $env)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommandImpl &&
            (identical(other.command, command) || other.command == command) &&
            const DeepCollectionEquality().equals(other._args, _args) &&
            (identical(other.path, path) || other.path == path) &&
            const DeepCollectionEquality().equals(other._env, _env));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      command,
      const DeepCollectionEquality().hash(_args),
      path,
      const DeepCollectionEquality().hash(_env));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommandImplCopyWith<_$CommandImpl> get copyWith =>
      __$$CommandImplCopyWithImpl<_$CommandImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommandImplToJson(
      this,
    );
  }
}

abstract class _Command implements Command {
  const factory _Command(
      {required final String command,
      required final List<String> args,
      required final String path,
      required final Map<String, String> env}) = _$CommandImpl;

  factory _Command.fromJson(Map<String, dynamic> json) = _$CommandImpl.fromJson;

  @override
  String get command;
  @override
  List<String> get args;
  @override
  String get path;
  @override
  Map<String, String> get env;
  @override
  @JsonKey(ignore: true)
  _$$CommandImplCopyWith<_$CommandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Asset _$AssetFromJson(Map<String, dynamic> json) {
  return _Asset.fromJson(json);
}

/// @nodoc
mixin _$Asset {
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: "system_path")
  String get systemPath => throw _privateConstructorUsedError;
  String get service => throw _privateConstructorUsedError;
  @JsonKey(name: "service_type")
  String get serviceType => throw _privateConstructorUsedError;
  @JsonKey(name: "keep_old")
  bool get keepOld => throw _privateConstructorUsedError;
  bool get unzip => throw _privateConstructorUsedError;
  @JsonKey(name: "cmd_pre")
  Command? get commandPre => throw _privateConstructorUsedError;
  @JsonKey(name: "cmd")
  Command? get command => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssetCopyWith<Asset> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetCopyWith<$Res> {
  factory $AssetCopyWith(Asset value, $Res Function(Asset) then) =
      _$AssetCopyWithImpl<$Res, Asset>;
  @useResult
  $Res call(
      {String name,
      @JsonKey(name: "system_path") String systemPath,
      String service,
      @JsonKey(name: "service_type") String serviceType,
      @JsonKey(name: "keep_old") bool keepOld,
      bool unzip,
      @JsonKey(name: "cmd_pre") Command? commandPre,
      @JsonKey(name: "cmd") Command? command});

  $CommandCopyWith<$Res>? get commandPre;
  $CommandCopyWith<$Res>? get command;
}

/// @nodoc
class _$AssetCopyWithImpl<$Res, $Val extends Asset>
    implements $AssetCopyWith<$Res> {
  _$AssetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? systemPath = null,
    Object? service = null,
    Object? serviceType = null,
    Object? keepOld = null,
    Object? unzip = null,
    Object? commandPre = freezed,
    Object? command = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      systemPath: null == systemPath
          ? _value.systemPath
          : systemPath // ignore: cast_nullable_to_non_nullable
              as String,
      service: null == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as String,
      serviceType: null == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String,
      keepOld: null == keepOld
          ? _value.keepOld
          : keepOld // ignore: cast_nullable_to_non_nullable
              as bool,
      unzip: null == unzip
          ? _value.unzip
          : unzip // ignore: cast_nullable_to_non_nullable
              as bool,
      commandPre: freezed == commandPre
          ? _value.commandPre
          : commandPre // ignore: cast_nullable_to_non_nullable
              as Command?,
      command: freezed == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as Command?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CommandCopyWith<$Res>? get commandPre {
    if (_value.commandPre == null) {
      return null;
    }

    return $CommandCopyWith<$Res>(_value.commandPre!, (value) {
      return _then(_value.copyWith(commandPre: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CommandCopyWith<$Res>? get command {
    if (_value.command == null) {
      return null;
    }

    return $CommandCopyWith<$Res>(_value.command!, (value) {
      return _then(_value.copyWith(command: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AssetImplCopyWith<$Res> implements $AssetCopyWith<$Res> {
  factory _$$AssetImplCopyWith(
          _$AssetImpl value, $Res Function(_$AssetImpl) then) =
      __$$AssetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      @JsonKey(name: "system_path") String systemPath,
      String service,
      @JsonKey(name: "service_type") String serviceType,
      @JsonKey(name: "keep_old") bool keepOld,
      bool unzip,
      @JsonKey(name: "cmd_pre") Command? commandPre,
      @JsonKey(name: "cmd") Command? command});

  @override
  $CommandCopyWith<$Res>? get commandPre;
  @override
  $CommandCopyWith<$Res>? get command;
}

/// @nodoc
class __$$AssetImplCopyWithImpl<$Res>
    extends _$AssetCopyWithImpl<$Res, _$AssetImpl>
    implements _$$AssetImplCopyWith<$Res> {
  __$$AssetImplCopyWithImpl(
      _$AssetImpl _value, $Res Function(_$AssetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? systemPath = null,
    Object? service = null,
    Object? serviceType = null,
    Object? keepOld = null,
    Object? unzip = null,
    Object? commandPre = freezed,
    Object? command = freezed,
  }) {
    return _then(_$AssetImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      systemPath: null == systemPath
          ? _value.systemPath
          : systemPath // ignore: cast_nullable_to_non_nullable
              as String,
      service: null == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as String,
      serviceType: null == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String,
      keepOld: null == keepOld
          ? _value.keepOld
          : keepOld // ignore: cast_nullable_to_non_nullable
              as bool,
      unzip: null == unzip
          ? _value.unzip
          : unzip // ignore: cast_nullable_to_non_nullable
              as bool,
      commandPre: freezed == commandPre
          ? _value.commandPre
          : commandPre // ignore: cast_nullable_to_non_nullable
              as Command?,
      command: freezed == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as Command?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetImpl implements _Asset {
  const _$AssetImpl(
      {required this.name,
      @JsonKey(name: "system_path") required this.systemPath,
      required this.service,
      @JsonKey(name: "service_type") required this.serviceType,
      @JsonKey(name: "keep_old") required this.keepOld,
      required this.unzip,
      @JsonKey(name: "cmd_pre") required this.commandPre,
      @JsonKey(name: "cmd") required this.command});

  factory _$AssetImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey(name: "system_path")
  final String systemPath;
  @override
  final String service;
  @override
  @JsonKey(name: "service_type")
  final String serviceType;
  @override
  @JsonKey(name: "keep_old")
  final bool keepOld;
  @override
  final bool unzip;
  @override
  @JsonKey(name: "cmd_pre")
  final Command? commandPre;
  @override
  @JsonKey(name: "cmd")
  final Command? command;

  @override
  String toString() {
    return 'Asset(name: $name, systemPath: $systemPath, service: $service, serviceType: $serviceType, keepOld: $keepOld, unzip: $unzip, commandPre: $commandPre, command: $command)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.systemPath, systemPath) ||
                other.systemPath == systemPath) &&
            (identical(other.service, service) || other.service == service) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.keepOld, keepOld) || other.keepOld == keepOld) &&
            (identical(other.unzip, unzip) || other.unzip == unzip) &&
            (identical(other.commandPre, commandPre) ||
                other.commandPre == commandPre) &&
            (identical(other.command, command) || other.command == command));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, systemPath, service,
      serviceType, keepOld, unzip, commandPre, command);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetImplCopyWith<_$AssetImpl> get copyWith =>
      __$$AssetImplCopyWithImpl<_$AssetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetImplToJson(
      this,
    );
  }
}

abstract class _Asset implements Asset {
  const factory _Asset(
      {required final String name,
      @JsonKey(name: "system_path") required final String systemPath,
      required final String service,
      @JsonKey(name: "service_type") required final String serviceType,
      @JsonKey(name: "keep_old") required final bool keepOld,
      required final bool unzip,
      @JsonKey(name: "cmd_pre") required final Command? commandPre,
      @JsonKey(name: "cmd") required final Command? command}) = _$AssetImpl;

  factory _Asset.fromJson(Map<String, dynamic> json) = _$AssetImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(name: "system_path")
  String get systemPath;
  @override
  String get service;
  @override
  @JsonKey(name: "service_type")
  String get serviceType;
  @override
  @JsonKey(name: "keep_old")
  bool get keepOld;
  @override
  bool get unzip;
  @override
  @JsonKey(name: "cmd_pre")
  Command? get commandPre;
  @override
  @JsonKey(name: "cmd")
  Command? get command;
  @override
  @JsonKey(ignore: true)
  _$$AssetImplCopyWith<_$AssetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
