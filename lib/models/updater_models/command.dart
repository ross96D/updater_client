import 'package:updater_client/models/base.dart';

part 'command.freezed.dart';
part 'command.g.dart';

class Command extends Base with _$Command {
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

  factory Command.fromJson(Map<String, Object?> json) => _$CommandFromJson(json);
}
