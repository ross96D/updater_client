// import 'package:flutter/material.dart';
// import 'package:updater_client/models/updater_models.dart';

// class ViewApplication extends StatelessWidget {
//   final Application app;
//   const ViewApplication({
//     super.key,
//     required this.app,
//   });

//   Widget _buildAsset(BuildContext context, Asset asset) {
//     final theme = Theme.of(context);
//     return Card(
//       elevation: 10,
//       shadowColor: const Color.fromRGBO(66, 66, 66, 0.75),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(asset.name, style: theme.textTheme.headlineSmall),
//             Text(asset.service, style: theme.textTheme.headlineSmall),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildAssets(BuildContext context) {
//     final result = <Widget>[];
//     for (final asset in app.assets) {
//       result.add(_buildAsset(context, asset));
//     }
//     return result;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Center(
//             child: Text(
//               app.name.toUpperCase(),
//               style: theme.textTheme.displaySmall,
//             ),
//           ),
//           ..._buildAssets(context),
//         ],
//       ),
//     );
//   }
// }

// ------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:updater_client/models/updater_models.dart';
import 'package:updater_client/widgets/resizable_split_widget.dart';

class ApplicationDetailView extends StatefulWidget {
  final List<Application> applications;

  const ApplicationDetailView({super.key, required this.applications});

  @override
  State<ApplicationDetailView> createState() => _ApplicationDetailViewState();
}

class _ApplicationDetailViewState extends State<ApplicationDetailView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedApp = widget.applications[_selectedIndex];
    return LayoutBuilder(builder: (context, constraints) {
      if ((constraints.maxWidth) < 300 + 150 + 5) {
        return Center(
          child: Container(
            color: Theme.of(context).colorScheme.error,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "TODO: Make it responsive",
                style: TextStyle(
                    inherit: true,
                    color: Theme.of(context).colorScheme.onError),
              ),
            ),
          ),
        );
      }
      return ResizableSplitWidget(
        minRightWidth: 300,
        minLeftWidth: 150,
        leftChild: Container(
          decoration: BoxDecoration(
            border: Border(
                right: BorderSide(color: Theme.of(context).dividerColor)),
          ),
          child: ListView.builder(
            itemCount: widget.applications.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(widget.applications[index].name),
              subtitle: Text(widget.applications[index].serviceType),
              selected: index == _selectedIndex,
              onTap: () => setState(() => _selectedIndex = index),
            ),
          ),
        ),
        rigthChild: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DefaultTabController(
            length: selectedApp.githubRelease != null ? 3 : 2,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    const Tab(text: 'Overview'),
                    const Tab(text: 'Assets'),
                    if (selectedApp.githubRelease != null)
                      const Tab(text: 'Release'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _OverviewTab(application: selectedApp),
                      _AssetsTab(assets: selectedApp.assets),
                      if (selectedApp.githubRelease != null)
                        _GithubReleaseTab(release: selectedApp.githubRelease),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _OverviewTab extends StatelessWidget {
  final Application application;

  const _OverviewTab({required this.application});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        // _buildInfoRow('Index', application.index.toString()),
        _buildInfoRow('Name', application.name),
        _buildSecureRow('token', application.authToken),
        _buildInfoRow('Service', application.service),
        _buildInfoRow('Service Type', application.serviceType),
        if (application.commandPre != null)
          _CommandWidget(
            command: application.commandPre!,
            title: 'Pre-Command',
          ),
        if (application.command != null)
          _CommandWidget(command: application.command!, title: 'Main Command'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 120,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
          const SizedBox(width: 16),
          Expanded(child: SelectableText(value)),
        ],
      ),
    );
  }

  Widget _buildSecureRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 120,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                const Text('••••••••'),
                IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: () =>
                        Clipboard.setData(ClipboardData(text: value))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetsTab extends StatelessWidget {
  final List<Asset> assets;

  const _AssetsTab({required this.assets});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: assets.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) => ExpansionTile(
        title: Text(assets[index].name, style: const TextStyle(fontSize: 16)),
        subtitle: Text(assets[index].serviceType),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildInfoRow('System Path', assets[index].systemPath),
          _buildInfoRow('Keep Old', assets[index].keepOld.toString()),
          _buildInfoRow('Unzip', assets[index].unzip.toString()),
          if (assets[index].commandPre != null)
            _CommandWidget(
                command: assets[index].commandPre!, title: 'Pre-Command'),
          if (assets[index].command != null)
            _CommandWidget(
                command: assets[index].command!, title: 'Main Command'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 16),
          SelectableText(value),
        ],
      ),
    );
  }
}

class _GithubReleaseTab extends StatelessWidget {
  final GithubRelease? release;

  const _GithubReleaseTab({required this.release});

  @override
  Widget build(BuildContext context) {
    if (release == null) {
      return const Center(child: Text('No GitHub release configuration'));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        _buildSecureRow('Token', release!.token),
        _buildInfoRow('Repository', '${release!.owner}/${release!.repo}'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 16),
          Expanded(child: SelectableText(value)),
        ],
      ),
    );
  }

  Widget _buildSecureRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                const Text('••••••••'),
                IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: () =>
                        Clipboard.setData(ClipboardData(text: value),),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommandWidget extends StatelessWidget {
  final Command command;
  final String title;

  const _CommandWidget({required this.command, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            _buildCommandLine(theme, command.command, command.args),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                if (command.path != null)
                  Chip(
                    label: Text('Path: ${command.path}'),
                    backgroundColor: Colors.grey[200],
                  ),
                ...(command.env ?? {}).entries.map((e) => Chip(
                      label: Text('${e.key}=${e.value}'),
                      backgroundColor: Colors.blue[50],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommandLine(ThemeData theme, String command, List<String> args) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(80),
        borderRadius: BorderRadius.circular(4),
      ),
      child: SelectableText.rich(
        TextSpan(
          children: [
            TextSpan(
              text: command,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: ' '),
            ...args.expand((arg) => [
                  TextSpan(text: arg.contains(' ') ? '"$arg" ' : '$arg '),
                ])
          ],
        ),
      ),
    );
  }
}
