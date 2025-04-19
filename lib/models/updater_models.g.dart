// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updater_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServerDataImpl _$$ServerDataImplFromJson(Map<String, dynamic> json) =>
    _$ServerDataImpl(
      apps: (json['apps'] as List<dynamic>)
          .map((e) => Application.fromJson(e as Map<String, dynamic>))
          .toList(),
      version: VersionData.fromJson(json['version'] as String),
    );

Map<String, dynamic> _$$ServerDataImplToJson(_$ServerDataImpl instance) =>
    <String, dynamic>{
      'apps': instance.apps,
      'version': instance.version,
    };

_$ApplicationImpl _$$ApplicationImplFromJson(Map<String, dynamic> json) =>
    _$ApplicationImpl(
      index: (json['index'] as num).toInt(),
      name: json['name'] as String,
      authToken: json['auth_token'] as String,
      service: json['service'] as String,
      serviceType: json['service_type'] as String,
      assets: (json['assets'] as List<dynamic>)
          .map((e) => Asset.fromJson(e as Map<String, dynamic>))
          .toList(),
      commandPre: json['cmd_pre'] == null
          ? null
          : Command.fromJson(json['cmd_pre'] as Map<String, dynamic>),
      command: json['cmd'] == null
          ? null
          : Command.fromJson(json['cmd'] as Map<String, dynamic>),
      githubRelease: json['github_release'] == null
          ? null
          : GithubRelease.fromJson(
              json['github_release'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ApplicationImplToJson(_$ApplicationImpl instance) =>
    <String, dynamic>{
      'index': instance.index,
      'name': instance.name,
      'auth_token': instance.authToken,
      'service': instance.service,
      'service_type': instance.serviceType,
      'assets': instance.assets,
      'cmd_pre': instance.commandPre,
      'cmd': instance.command,
      'github_release': instance.githubRelease,
    };

_$GithubReleaseImpl _$$GithubReleaseImplFromJson(Map<String, dynamic> json) =>
    _$GithubReleaseImpl(
      token: json['token'] as String,
      repo: json['repo'] as String,
      owner: json['owner'] as String,
    );

Map<String, dynamic> _$$GithubReleaseImplToJson(_$GithubReleaseImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'repo': instance.repo,
      'owner': instance.owner,
    };

_$CommandImpl _$$CommandImplFromJson(Map<String, dynamic> json) =>
    _$CommandImpl(
      command: json['command'] as String,
      args: (json['args'] as List<dynamic>).map((e) => e as String).toList(),
      path: json['path'] as String,
      env: Map<String, String>.from(json['env'] as Map),
    );

Map<String, dynamic> _$$CommandImplToJson(_$CommandImpl instance) =>
    <String, dynamic>{
      'command': instance.command,
      'args': instance.args,
      'path': instance.path,
      'env': instance.env,
    };

_$AssetImpl _$$AssetImplFromJson(Map<String, dynamic> json) => _$AssetImpl(
      name: json['name'] as String,
      systemPath: json['system_path'] as String,
      service: json['service'] as String,
      serviceType: json['service_type'] as String,
      keepOld: json['keep_old'] as bool,
      unzip: json['unzip'] as bool,
      commandPre: json['cmd_pre'] == null
          ? null
          : Command.fromJson(json['cmd_pre'] as Map<String, dynamic>),
      command: json['cmd'] == null
          ? null
          : Command.fromJson(json['cmd'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AssetImplToJson(_$AssetImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'system_path': instance.systemPath,
      'service': instance.service,
      'service_type': instance.serviceType,
      'keep_old': instance.keepOld,
      'unzip': instance.unzip,
      'cmd_pre': instance.commandPre,
      'cmd': instance.command,
    };
