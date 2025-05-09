import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';

class ConfigurationEditor extends StatefulWidget {
  const ConfigurationEditor({super.key, this.intialText = ""});

  final String intialText;

  @override
  State<StatefulWidget> createState() => _ConfigurationEditorState();
}

class _ConfigurationEditorState extends State<ConfigurationEditor> {
  late CodeLineEditingController controller;

  @override
  void initState() {
    controller = CodeLineEditingController(
      codeLines: CodeLines.fromText(widget.intialText),
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
