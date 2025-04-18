import 'package:updater_client/models/base.dart';

class ServerData {

}

class Application extends Base {
  final String name;
  final String authToken;
  final String service;
  final String serviceType;
}

class Asset extends Base {
  final String name;
  final String systemPath;
  final String service;
  final String serviceType;
  final bool keepOld;
  final bool unzip;
  final Command? commandPre;
  final Command? command;
}

class Command extends Base {
  final String command;
  final List<String> args;
  final String path;
  final Map<String, String> env;

  Command({
    required this.command,
    required this.args,
    required this.path,
    required this.env,
  });

  factory Command.fromJson(Map<String, Object?> json) {
    return Command(
      command: json["commnad"] as String,
      args: json["args"] as List<String>,
      path: json["path"] as String,
      env: json["env"] as Map<String, String>,
    );
  }

  @override
  List<Object?> get props => [command, args, path, env];

  @override
  Object toJson() {
    return {
      "command": command,
      "args": args,
      "path": path,
      "env": env,
    };
  }
}
