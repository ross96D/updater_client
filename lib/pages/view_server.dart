import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:updater_client/models/updater_models.dart';

class ViewServer extends StatefulWidget {
  final int id;
  final ServerData serverData;

  const ViewServer({super.key, required this.id, required this.serverData});

  @override
  State<StatefulWidget> createState() => _ViewServerState();
}

class _ViewServerState extends State<ViewServer> {
  Widget _item(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _Item(
        baseURL: "/view-server/${widget.id}",
        app: Application(
        index: 0,
        name: text,
        authToken: 'tok',
        service: 'ser',
        serviceType: 'sds',
        assets: [],
        commandPre: null,
        command: null,
        githubRelease: null,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      children: [
        _item("HELLO1", theme),
        _item("HELLO2", theme),
        _item("HELLO3", theme),
        _item("HELLO4", theme),
        _item("HELLO5", theme),
      ],
    );
  }
}

class _Item extends StatefulWidget {
  final Application app;
  final String baseURL;

  const _Item({required this.app, required this.baseURL});

  @override
  State<StatefulWidget> createState() => _StateItem();
}

class _StateItem extends State<_Item> {
  bool _isHovered = false;

  Color _color(ThemeData theme) {
    if (_isHovered) {
      return theme.colorScheme.primary.withAlpha(80);
    } else {
      return theme.cardColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (event) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () => GoRouter.of(context).push("${widget.baseURL}/application/${widget.app.name}"),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: _color(theme),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(66, 66, 66, 0.75),
                blurRadius: 8,
                blurStyle: BlurStyle.outer,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.app.name),
          ),
        ),
      ),
    );
  }
}
