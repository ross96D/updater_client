import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:updater_client/api.dart';
import 'package:updater_client/bdapi.dart';
import 'package:updater_client/models/updater_models.dart';
import 'package:updater_client/utils/utils.dart';
import 'package:updater_client/widgets/button.dart';
import 'package:updater_client/widgets/resizable_split_widget.dart';
import 'package:updater_client/widgets/stream.dart';
import 'package:updater_client/widgets/toast.dart';

class ServerDataView extends StatefulWidget {
  final SessionManager manager;

  const ServerDataView({super.key, required this.manager});

  @override
  State<StatefulWidget> createState() => ServerDataViewState();
}

class ServerDataViewState extends State<ServerDataView> {
  late final Stream<Result<ServerData, ApiError>> stream;

  @override
  void initState() {
    super.initState();
    stream = widget.manager.list();
  }

  Widget _onActive(
    BuildContext context,
    ResultSummary<ServerData, ApiError> summary,
  ) {
    if (summary.e != null) {
      return SelectableText("ERROR: ${summary.e} \n ${summary.st}");
    }
    List<ApiError> errs = [];
    while (true) {
      final error = summary.errors.pop();
      if (error == null) {
        break;
      }
      errs.add(error);
      showToast(context, ToastType.error, "Api Error", error.error());
    }
    if (summary.data != null) {
      return _ServerDataView(serverResult: Result.success(summary.data!));
    } else {
      return _ServerDataView(serverResult: Result.error(Errors(errs)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamResultBuilder(
      stream: stream,
      builder: (context, summary) {
        return switch (summary.connectionState) {
          StreamConnectionState.none => throw ArgumentError("unexpected state"),
          StreamConnectionState.waiting => const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          StreamConnectionState.active || StreamConnectionState.done => _onActive(
              context,
              summary,
            ),
        };
      },
    );
  }
}

class Errors extends Err with EquatableMixin {
  final List<ApiError> errors;
  const Errors(this.errors);

  @override
  String error() {
    return errors.map((e) => e.error()).join('\n\n');
  }

  @override
  List<Object?> get props => [errors];
}

class _ServerDataView extends StatefulWidget {
  final Result<ServerData, Errors> serverResult;

  const _ServerDataView({super.key, required this.serverResult});

  @override
  State<_ServerDataView> createState() => _ServerDataViewState();
}

class _ServerDataViewState extends State<_ServerDataView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return widget.serverResult.match(
      onSuccess: (v) => _buildSuccess(context, v),
      onError: (e) => Center(child: SelectableText(e.error())),
    );
  }

  Widget _buildSuccess(BuildContext context, ServerData server) {
    final applications = server.apps;
    final selectedApp = applications[_selectedIndex];
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 300 + 150 + 5) {
          return Center(
            child: Container(
              color: Theme.of(context).colorScheme.error,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "TODO: Make it responsive",
                  style: TextStyle(inherit: true, color: Theme.of(context).colorScheme.onError),
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
              border: Border(right: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: ListView.builder(
              itemCount: applications.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(applications[index].name),
                subtitle: Text(applications[index].serviceType),
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
                      if (selectedApp.githubRelease != null) const Tab(text: 'Release'),
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
      },
    );
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
            title: 'Pre Command',
          ),
        if (application.command != null)
          _CommandWidget(command: application.command!, title: 'Post Command'),
      ],
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
            _CommandWidget(command: assets[index].commandPre!, title: 'Pre-Command'),
          if (assets[index].command != null)
            _CommandWidget(command: assets[index].command!, title: 'Main Command'),
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
        _buildInfoRow('Repository', 'https://github.com/${release!.owner}/${release!.repo}'),
      ],
    );
  }
}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        const SizedBox(width: 16),
        SelectableText(value),
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
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: 16),
        Row(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 80),
              child: Text(
                List.filled(value.length, '•').join(),
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ),
            if (value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: SizedOverflowBox(
                  size: const Size(15, 15),
                  child: SmallIconButton(
                    onTap: () => Clipboard.setData(ClipboardData(text: value)),
                    icon: const Icon(Icons.copy, size: 15),
                  ),
                ),
              ),
          ],
        ),
      ],
    ),
  );
}

class _CommandWidget extends StatelessWidget {
  final Command command;
  final String title;

  const _CommandWidget({required this.command, required this.title});

  String get commandString {
    final buffer = StringBuffer();
    if (command.env != null) {
      buffer.write(
        command.env!.entries.map((e) => "${e.key}=${e.value}").join(" "),
      );
      buffer.write(" ");
    }
    buffer.write(command.command);
    if (command.args.isNotEmpty) {
      buffer.write(" ");
      buffer.write(command.args.join(" "));
    }
    return buffer.toString();
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(width: 5),
                    const Tooltip(
                      message: "TODO: tooltip",
                      preferBelow: false,
                      child: Icon(Icons.help_outline_sharp, size: 15),
                    ),
                  ],
                ),
                SizedOverflowBox(
                  size: const Size(25, 20),
                  child: IconButton(
                    onPressed: () => Clipboard.setData(ClipboardData(text: commandString)),
                    icon: const Icon(Icons.copy, size: 20),
                  ),
                ),
              ],
            ),
            _buildCommandLine(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildCommandLine(ThemeData theme) {
    final command = this.command.command;
    final args = this.command.args;
    final envs = this.command.env ?? const {};
    final path = this.command.path;

    final commandWidget = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SelectableText.rich(
        TextSpan(
          text: command,
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          children: [
            const TextSpan(text: ' '),
            ...args.map((arg) => TextSpan(text: '${arg.trim()} ')),
          ],
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commandWidget,
          if (path != null) const SizedBox(height: 15),
          if (path != null)
            Row(children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text("path:"),
              ),
              const SizedBox(width: 5),
              SelectableText.rich(TextSpan(text: path)),
            ]),
          if (envs.isNotEmpty) const SizedBox(height: 15),
          if (envs.isNotEmpty)
            ExpansionTile(
              title: const Text("Enviroment Variables"),
              tilePadding: const EdgeInsets.symmetric(horizontal: 5.0),
              expandedAlignment: Alignment.topLeft,
              childrenPadding: const EdgeInsets.only(left: 8),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...envs.entries.map((e) => Text("${e.key}=${e.value}\n")),
              ],
            ),
        ],
      ),
    );
  }
}
