import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast.dart';
import 'package:updater_client/models/base.dart';
import 'package:updater_client/models/server.dart';

class DataBase {
  final String filepath;
  late final Database _database;
  late Completer _completer;

  DataBase(this.filepath) {
    _completer = Completer();
    _completer.complete(open());
  }

  Future<void> open() async {
    _database = await databaseFactoryIo.openDatabase(filepath);
  }

  Future<Database> get db async {
    await _completer.future;
    return _database;
  }
}

sealed class Stores<V extends Base> {
  StoreRef<int, Object> store();
  V fromJson(Object json);
}

class ServerStores extends Stores<Server> {
  static final _instance = ServerStores._internal();
  ServerStores._internal();
  factory ServerStores() => _instance;

  static final _storeServer = StoreRef<int, Object>('server');

  @override
  StoreRef<int, Object> store() {
    return _storeServer;
  }

  @override
  Server fromJson(Object json) {
    return Server.fromJson(json as Map<String, Object?>);
  }
}

class Store<V extends Base, T extends Stores<V>> extends ChangeNotifier {
  final DataBase database;
  T store;
  Map<int, V>? _cached;
  Map<int, V> get items {
    if (_cached != null) {
      return _cached!;
    }
    all().then((_) => notifyListeners());
    return {};
  }

  Store({required this.database, required this.store});

  Future<int> write(V value) async {
    final db = await database.db;
    final resp = await store.store().add(db, value.toJson());
    if (_cached != null) {
      _cached![resp] = value;
    }
    notifyListeners();
    return resp;
  }

  Future<bool> delete(int key) async {
    final db = await database.db;
    return await store.store().record(key).delete(db) != null;
  }

  Future<Map<int, V>> all() async {
    if (_cached != null) {
      return _cached!;
    }

    final db = await database.db;
    final res = await store.store().find(db, finder: Finder());

    final map = <int, V>{};
    for (var e in res) {
      map[e.key] = store.fromJson(e.value);
    }
    _cached = map;
    return _cached!;
  }

  Future<V?> get(int key) async {
    final db = await database.db;
    return store.fromJson(store.store().record(key).get(db));
  }
}

class StoreProvider<V extends Base, T extends Stores<V>> extends InheritedWidget {
  final Store<V, T> store;

  const StoreProvider({
    Key? key,
    required this.store,
    required Widget child,
  }) : super(key: key, child: child);

  static Store<V, T> of<V extends Base, T extends Stores<V>>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<StoreProvider<V, T>>()!
        .store;
  }

  @override
  bool updateShouldNotify(StoreProvider<V, T> oldWidget) {
    return store != oldWidget.store;
  }
}
