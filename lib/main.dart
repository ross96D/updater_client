import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:updater_client/database.dart';
import 'package:updater_client/models/server.dart';
import 'package:updater_client/models/updater_models.dart';
import 'package:updater_client/pages/add_server.dart';
import 'package:updater_client/pages/show_server.dart';
import 'package:updater_client/theme.dart';
import 'package:updater_client/widgets/button.dart';
import 'package:updater_client/widgets/showfps.dart';
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

class _AppChangeTheme extends InheritedWidget {
  final void Function(Brightness) callback;
  const _AppChangeTheme({required super.child, required this.callback});

  static void Function(Brightness) of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_AppChangeTheme>()!
        .callback;
  }

  @override
  bool updateShouldNotify(_AppChangeTheme oldWidget) {
    return callback != oldWidget.callback;
  }
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
    return _AppChangeTheme(
      callback: changeTheme,
      child: MaterialApp.router(
        title: 'Updater client',
        theme: materialTheme.light(),
        darkTheme: materialTheme.dark(),
        themeMode: mode,
        debugShowCheckedModeBanner: false,
        routerConfig: routes,
      ),
    );
  }
}

class AppLayout extends StatelessWidget {
  const AppLayout({
    super.key,
    required this.title,
    required this.changeTheme,
    required this.child,
  });

  final String title;
  final Widget child;
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
          const ShowFPS(
            borderRadius: BorderRadius.all(Radius.circular(11)),
            showChart: false,
            child: SizedBox.shrink(),
          ),
        ],
        backgroundColor: theme.colorScheme.inversePrimary,
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => GoRouter.of(context).go("/"),
            child: Text(title),
          ),
        ),
      ),
      body: Row(
        children: <Widget>[
          ListenableBuilder(
            listenable: GetIt.instance.get<Store<Server, ServerStore>>(),
            builder: (context, _) {
              final store = GetIt.instance.get<Store<Server, ServerStore>>();
              final items = <SidebarItem>[];
              for (final e in store.items.values) {
                items.add(SidebarItem(
                  icon: Icons.dry,
                  text: e.name.value,
                ));
              }
              return AnimatedSidebar(
                onItemSelected: (index) {
                  GoRouter.of(context).go("/view-server/$index");
                },
                expanded: MediaQuery.of(context).size.width > 600,
                items: items,
                selectedIndex: 0,
                headerIconColor: theme.brightness == Brightness.light
                    ? theme.primaryColorDark
                    : theme.primaryColorLight,
                header: (isExpanded) {
                  return Button(
                    onTap: () {
                      GoRouter.of(context).go("/add-server");
                    },
                    child: SizedBox(
                      height: 30,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 2.0, bottom: 2.0),
                        child: Row(
                          children: [
                            Icon(Icons.add, color: theme.colorScheme.onPrimary),
                            isExpanded
                                ? const Flexible(
                                    fit: FlexFit.tight,
                                    child: Text(
                                      "Add a new server",
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      softWrap: false,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Flexible(
            fit: FlexFit.tight,
            child: child,
          ),
        ],
      ),
    );
  }
}

final routes = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppLayout(
          title: 'This is my title',
          changeTheme: _AppChangeTheme.of(context),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: "/",
          builder: (context, state) {
            return Center(
              child: Text(
                "Hello",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            );
          },
        ),
        GoRoute(
          path: "/application/:name",
          builder: (context, state) => Text("HESLO")
        ),
        GoRoute(
          path: "/view-server/application/:name",
          builder: (context, state) {
            return const ViewApplication(app: Application(
              assets: [],
              authToken: "",
              index: 0,
              name: '',
              service: '',
              serviceType: '',
              commandPre: null,
              command: null,
              githubRelease: null,
            ));
          }
        ),
        GoRoute(
          path: "/view-server/:id",
          builder: (context, state) {
            return const ViewServer(
              serverData: ServerData(
                apps: [],
                version: VersionData(),
              ),
            );
          },
        ),
        GoRoute(
          path: "/add-server",
          builder: (context, state) {
            return const AddServer();
          },
        ),
      ],
    ),
  ],
);
