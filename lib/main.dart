import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:updater_client/api.dart';
import 'package:updater_client/bdapi.dart';
import 'package:updater_client/database.dart';
import 'package:updater_client/pages/add_server.dart';
import 'package:updater_client/theme.dart';
import 'package:updater_client/utils/utils.dart';
import 'package:updater_client/widgets/button.dart';
import 'package:updater_client/widgets/showfps.dart';
import 'package:updater_client/widgets/sidebar.dart';
import 'package:path/path.dart' as path;
import 'package:updater_client/widgets/toast.dart';

import 'pages/view_application.dart';

void main() {
  getApplicationDocumentsDirectory().then((dir) async {
    dir = Directory(path.join(dir.path, "updater_client"));
    await dir.create();
    final dbPath = path.join(dir.path, "database");
    GetIt.instance.registerSingleton(DataBase(dbPath));
    GetIt.instance.registerSingleton<ServerStore>(
      ServerStore(
        database: GetIt.instance.get<DataBase>(),
        store: ServerStores(),
      ),
    );
    GetIt.instance.registerSingleton(ServerDataStore(
      store: ServerDataStores(),
      database: GetIt.instance.get<DataBase>(),
    ));
    GetIt.instance.registerSingleton(Sessionaizer());
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
    return context.dependOnInheritedWidgetOfExactType<_AppChangeTheme>()!.callback;
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

  Widget _buildSideBar(BuildContext context) {
    final theme = Theme.of(context);
    final manager = GetIt.instance.get<Sessionaizer>();
    return ListenableBuilder(
      listenable: manager,
      builder: (context, _) {
        final items = <SidebarItem>[];
        final keys = <int>[];
        for (final key in manager.sessions.keys) {
          final session = manager.sessions[key]!;
          final serverdata = session.store.givemeSync(session.server)?.toServerData();
          items.add(SidebarItem(
              icon: switch (session.state.value) {
                NotConnected() => Icons.cloud,
                Connected() => Icons.cloud_done,
                ConnectionError() => Icons.cloud_off,
              },
              text: "${session.server.name.value} ${serverdata?.version.toString() ?? ""}",
              deleteAction: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Are you sure you want to delete "
                              "\"${session.server.name.value}\" server",
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    manager.serverStore.delete(IntKey(key)).onError(
                                      (error, stackTrace) {
                                        showToast(
                                          context,
                                          ToastType.error,
                                          "error deleting server",
                                          "Error: $error\nStacktrace: $stackTrace",
                                        );
                                        return true;
                                      },
                                    );
                                    context.pop();
                                  },
                                  child: const Text("Yes"),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: const Text("No"),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }));
          keys.add(key);
        }
        return AnimatedSidebar(
          itemIconSize: 25,
          onItemSelected: (index) {
            final k = keys[index];
            GoRouter.of(context).push("/view-server/$k");
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
                showDialog(
                  context: context,
                  builder: (context) {
                    return const Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.elliptical(20, 15)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 400,
                          child: IntrinsicHeight(
                            child: AddServer(),
                          ),
                        ),
                      ),
                    );
                  },
                );
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
    );
  }

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
        title: Row(
          children: [
            ListenableBuilder(
                listenable: canPopTracker,
                builder: (context, _) {
                  if (GoRouter.of(context).canPop()) {
                    return BackButton(
                      onPressed: () => GoRouter.of(context).pop(),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
            const SizedBox(width: 5),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => GoRouter.of(context).push("/"),
                child: Text(title),
              ),
            ),
          ],
        ),
      ),
      body: Row(
        children: <Widget>[
          _buildSideBar(context),
          Flexible(
            fit: FlexFit.tight,
            child: child,
          ),
        ],
      ),
    );
  }
}

// 1. Create a navigation state tracker
class NavigatorChangeTracker extends ChangeNotifier {
  void update() {
    notifyListeners();
  }
}

// 2. Create a navigation observer
class RouteObserver extends NavigatorObserver {
  final NavigatorChangeTracker tracker;

  RouteObserver(this.tracker);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    tracker.update();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    tracker.update();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    tracker.update();
  }
}

final canPopTracker = NavigatorChangeTracker();

final RouteObserver routeObserver = RouteObserver(canPopTracker);

final navigatorKey = GlobalKey<NavigatorState>();

final routes = GoRouter(
  observers: [routeObserver],
  routes: [
    ShellRoute(
      navigatorKey: navigatorKey,
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
            return Container();
          },
        ),
        GoRoute(
          parentNavigatorKey: navigatorKey,
          path: "/view-server/:id",
          builder: (context, state) {
            final store = GetIt.instance.get<ServerStore>();
            final id = state.pathParameters["id"];
            final server = store.getSync(IntKey(int.tryParse(id!)!));
            if (server == null) {
              return Text("SERVER with id $id does not exist");
            }
            final sessionaizer = GetIt.instance.get<Sessionaizer>();
            final manager = sessionaizer.sessions[int.parse(id)]!;

            return ServerDataView(manager: manager);
          },
        ),
      ],
    ),
  ],
);
