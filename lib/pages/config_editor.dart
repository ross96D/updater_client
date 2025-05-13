import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';
import 'package:updater_client/api.dart';
import 'package:updater_client/bdapi.dart';
import 'package:updater_client/models/base.dart';
import 'package:updater_client/utils/utils.dart';
import 'package:updater_client/widgets/toast.dart';
import 'package:re_highlight/re_highlight.dart';

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

  void sendConfig(BuildContext context, String configuration) {
    widget.manager.reload(configuration).then((result) {
      result.match(
        onSuccess: (v) {
          showToast(context, ToastType.info, "Reload success",
              "${widget.manager.server.name.value} has reloaded the configuration");
        },
        onError: (e) {
          showToast(context, ToastType.error, "Error reloading configuration", "$e");
        },
      );
    }).onError((error, stackTrace) {
      showToast(context, ToastType.error, "future error", "$error\n$stackTrace");
    });
  }

  Widget onActive(Result<ServerConfiguration, ApiError> data) {
    return data.match(
      onSuccess: (v) => _Editor(v, sendConfig),
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
  final void Function(BuildContext, String) send;
  const _Editor(this.initial, this.send);

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
      child: Column(
        children: [
          Expanded(
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
                  codeTheme: CodeHighlightTheme(
                    languages: {"cue": CodeHighlightThemeMode(mode: langCue)},
                    theme: atomOneLightTheme,
                  ),
                  backgroundColor: theme.colorScheme.background,
                  fontSize: theme.textTheme.bodyMedium?.fontSize ?? 18,
                  fontFamily: "CaskaydiaCoveNerd",
                ),
                indicatorBuilder: (context, editingController, chunkController, notifier) {
                  return Row(
                    children: [
                      const SizedBox(width: 5),
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
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () => widget.send(context, controller.text),
                child: const Text("send"),
              ),
              OutlinedButton(
                onPressed: () =>
                    showToast(context, ToastType.warning, "TODO", "missing functionality"),
                child: const Text("validate"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


/// AI generated and may contain several bugs. This needs review but is just code review so i dont
/// really care
final langCue = Mode(
    refs: {
      '~contains~0': Mode(className: 'string', variants: <Mode>[
        Mode(
            begin: '"""',
            end: '"""',
            contains: <Mode>[BACKSLASH_ESCAPE, Mode(ref: '~contains~0~contains~0')]),
        Mode(
            begin: "'''",
            end: "'''",
            contains: <Mode>[BACKSLASH_ESCAPE, Mode(ref: '~contains~0~contains~0')]),
        Mode(
            begin: '"',
            end: '"',
            contains: <Mode>[BACKSLASH_ESCAPE, Mode(ref: '~contains~0~contains~0')]),
        Mode(
            begin: "'",
            end: "'",
            contains: <Mode>[BACKSLASH_ESCAPE, Mode(ref: '~contains~0~contains~0')])
      ]),
      '~contains~0~contains~0':
          Mode(className: 'subst', begin: '\\\\(\\()', end: '\\)', contains: <Mode>[
        C_NUMBER_MODE,
        Mode(ref: '~contains~0') // Allow nested strings
      ])
    },
    name: "Cue",
    keywords: {
      "keyword": [
        "package",
        "import",
        "if",
        "else",
        "for",
        "in",
        "let",
        "struct",
        "or",
        "and",
        "not",
        "null",
        "true",
        "false"
      ],
      "built_in": ["bool", "string", "int", "float", "bytes", "len", "close", "open"],
      "\$pattern": "[A-Za-z_][A-Za-z0-9_]*"
    },
    contains: <Mode>[
      Mode(ref: '~contains~0'), // Strings
      C_LINE_COMMENT_MODE,
      C_BLOCK_COMMENT_MODE,
      C_NUMBER_MODE,
      Mode(
          // Struct definitions
          className: 'type',
          begin: '#[A-Za-z_][A-Za-z0-9_]*',
          relevance: 0),
      Mode(
          // Field labels
          className: 'symbol',
          begin: '\\b([A-Za-z_][A-Za-z0-9_]*)\\s*:',
          relevance: 0),
      Mode(
          // Operators
          className: 'operator',
          match: '==|!=|=|&|\\||\\?|:',
          relevance: 0)
    ]);

const atomOneLightTheme = {
  'root': TextStyle(color: Color(0xff383a42), backgroundColor: Color(0xfffafafa)),
  'comment': TextStyle(color: Color(0xffa0a1a7), fontStyle: FontStyle.italic),
  'quote': TextStyle(color: Color(0xffa0a1a7), fontStyle: FontStyle.italic),
  'doctag': TextStyle(color: Color(0xffa626a4)),
  'keyword': TextStyle(color: Color(0xffa626a4)),
  'formula': TextStyle(color: Color(0xffa626a4)),
  'section': TextStyle(color: Color(0xffe45649)),
  'name': TextStyle(color: Color(0xffe45649)),
  'selector-tag': TextStyle(color: Color(0xffe45649)),
  'deletion': TextStyle(color: Color(0xffe45649)),
  'subst': TextStyle(color: Color(0xffe45649)),
  'literal': TextStyle(color: Color(0xff0184bb)),
  'string': TextStyle(color: Color(0xff50a14f)),
  'regexp': TextStyle(color: Color(0xff50a14f)),
  'addition': TextStyle(color: Color(0xff50a14f)),
  'attribute': TextStyle(color: Color(0xff50a14f)),
  'meta-string': TextStyle(color: Color(0xff50a14f)),
  'attr': TextStyle(color: Color(0xff986801)),
  'variable': TextStyle(color: Color(0xff986801)),
  'template-variable': TextStyle(color: Color(0xff986801)),
  'type': TextStyle(color: Color(0xff986801)),
  'selector-class': TextStyle(color: Color(0xff986801)),
  'selector-attr': TextStyle(color: Color(0xff986801)),
  'selector-pseudo': TextStyle(color: Color(0xff986801)),
  'number': TextStyle(color: Color(0xff986801)),
  'symbol': TextStyle(color: Color(0xff4078f2)),
  'bullet': TextStyle(color: Color(0xff4078f2)),
  'link': TextStyle(color: Color(0xff4078f2)),
  'meta': TextStyle(color: Color(0xff4078f2)),
  'selector-id': TextStyle(color: Color(0xff4078f2)),
  'title': TextStyle(color: Color(0xff4078f2)),
  'built_in': TextStyle(color: Color(0xffc18401)),
  'title.class_': TextStyle(color: Color(0xffc18401)),
  'class-title': TextStyle(color: Color(0xffc18401)),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
  'strong': TextStyle(fontWeight: FontWeight.bold),
};
