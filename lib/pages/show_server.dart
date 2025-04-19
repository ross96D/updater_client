import 'package:flutter/material.dart';
import 'package:updater_client/models/updater_models.dart';

class ShowServer extends StatefulWidget {
  final ServerData serverData;

  const ShowServer({super.key, required this.serverData});

  @override
  State<StatefulWidget> createState() => _ShowServerState();
}

class _ShowServerState extends State<ShowServer> {
  Widget _item(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _Item(child: Text(text)),
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
        ElevatedButton(
          onPressed: () => {},
          child: Text("HELLO"),
        ),
      ],
    );
  }
}

class _Item extends StatefulWidget {
  final Widget child;

  const _Item({required this.child});

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
        onTap: () => {},
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
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
