
import 'package:flutter/material.dart';
import 'package:updater_client/models/updater_models.dart';

class ViewApplication extends StatelessWidget {
  final Application app;
  const ViewApplication({super.key, required this.app,});

  Widget _buildAsset(BuildContext context, Asset asset) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(asset.name, style: theme.textTheme.headlineSmall),
      ],
    );
  }

  List<Widget> _buildAssets(BuildContext context) {
    final result = <Widget>[];
    for (final asset in app.assets) {
      result.add(_buildAsset(context, asset));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(app.name.toUpperCase(), style: theme.textTheme.displaySmall),
          ..._buildAssets(context),
        ]
      ),
    );
  }
}
