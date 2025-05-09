import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';
import 'package:updater_client/api.dart';
import 'package:updater_client/bdapi.dart';
import 'package:updater_client/models/base.dart';
import 'package:updater_client/utils/utils.dart';

class ConfigurationEditor extends StatefulWidget {
  const ConfigurationEditor({super.key, required this.manager});

  final SessionManager manager;

  Future<Result<ServerConfiguration, ApiError>> configuration() {
    return manager.config();
  }

  @override
  State<StatefulWidget> createState() => _ConfigurationEditorState();
}

class _ConfigurationEditorState extends State<ConfigurationEditor> {
  late final Future<Result<ServerConfiguration, ApiError>> state;

  @override
  void initState() {
    state = widget.manager.config();
    super.initState();
  }

  Widget onActive(Result<ServerConfiguration, ApiError> data) {
    return data.match(
      onSuccess: (v) => _Editor(v),
      onError: (e) => SelectableText("ERROR $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: state,
      builder: (context, state) {
        return switch (state.connectionState) {
          ConnectionState.none || ConnectionState.waiting => const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          ConnectionState.active ||
          ConnectionState.done =>
            state.data != null ? onActive(state.data!) : SelectableText("${state.error}"),
        };
      },
    );
  }
}

class _Editor extends StatefulWidget {
  final ServerConfiguration initial;
  const _Editor(this.initial);

  @override
  State<_Editor> createState() => _EditorState();
}

class _EditorState extends State<_Editor> {
  late CodeLineEditingController controller;

  @override
  void initState() {
    controller = CodeLineEditingController(
      // replace tab characters with 4 spaces because flutter does not handle tab characters
      codeLines: CodeLines.fromText(widget.initial.toString().replaceAll("\t", " " * 4)),
      options: const CodeLineOptions(indentSize: 4),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, right: 10),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        padding: const EdgeInsets.all(1),
        child: CodeEditor(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          controller: controller,
          style: CodeEditorStyle(
            backgroundColor: theme.colorScheme.background,
            fontSize: theme.textTheme.bodyMedium?.fontSize ?? 18,
            fontFamily: "CaskaydiaCoveNerd",
          ),
          indicatorBuilder: (context, editingController, chunkController, notifier) {
            return Row(
              children: [
                DefaultCodeLineNumber(
                  controller: editingController,
                  notifier: notifier,
                ),
                const SizedBox(width: 5),
              ],
            );
          },
          sperator: Container(width: 1, color: Colors.grey),
        ),
      ),
    );
  }
}
