import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:updater_client/database.dart';
import 'package:updater_client/models/server.dart';
import 'package:updater_client/models/updater_models.dart';
import 'package:updater_client/pages/add_server.dart';
import 'package:updater_client/pages/show_server.dart';
import 'package:updater_client/theme.dart';
import 'package:updater_client/widgets/sidebar/sidebar.dart';
import 'package:updater_client/widgets/sidebar/sidebar_item.dart';
import 'package:path/path.dart' as path;

void main() {
  getApplicationDocumentsDirectory().then((dir) async {
    dir = Directory(path.join(dir.path, "updater_client"));
    await dir.create();
    final dbPath = path.join(dir.path, "database");
    GetIt.instance.registerSingleton(DataBase(dbPath));
    GetIt.instance.registerSingleton<Store<Server, ServerStore>>(
      Store<Server, ServerStore>(
        database: GetIt.instance.get<DataBase>(),
        store: ServerStore(),
      ),
    );
    runApp(const App());
  });
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _App();
}

class _App extends State<App> {
  ThemeMode mode = ThemeMode.system;

  void changeTheme(Brightness b) {
    setState(() {
      if (b == Brightness.dark) {
        mode = ThemeMode.light;
      } else {
        mode = ThemeMode.dark;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final materialTheme = MaterialTheme(ThemeData().textTheme);
    return MaterialApp(
      title: 'Updater client',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: mode,
      debugShowCheckedModeBanner: false,
      home: AppLayout(title: 'This is my title', changeTheme: changeTheme),
    );
  }
}

class AppLayout extends StatelessWidget {
  const AppLayout({super.key, required this.title, required this.changeTheme});

  final String title;
  final void Function(Brightness) changeTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.brightness_4 // Show sun if dark mode
                  : Icons.brightness_7, // Show moon if light mode
            ),
            onPressed: () {
              changeTheme(theme.brightness);
            },
          ),
        ],
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Row(
        children: <Widget>[
          ListenableBuilder(
              listenable: GetIt.instance.get<Store<Server, ServerStore>>(),
              builder: (context, _) {
                final store =
                    GetIt.instance.get<Store<Server, ServerStore>>();
                final items = <SidebarItem>[];
                for (final e in store.items.values) {
                  items.add(SidebarItem(icon: Icons.dry, text: e.name.value));
                }
                return AnimatedSidebar(
                  expanded: MediaQuery.of(context).size.width > 600,
                  items: items,
                  selectedIndex: 0,
                  onItemSelected: (index) => {},
                  headerIcon: Icons.ac_unit_sharp,
                  headerIconColor: theme.brightness == Brightness.light
                      ? theme.primaryColorDark
                      : theme.primaryColorLight,
                  headerText: 'Example',
                );
              }),
          const Flexible(fit: FlexFit.tight, child: ShowServer(serverData: ServerData(
            apps: [],
            version: VersionData(),
          ))),
        ],
      )
    );
  }
}
