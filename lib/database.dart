import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast.dart';
import 'package:updater_client/models/base.dart';
import 'package:updater_client/models/server.dart';
import 'package:updater_client/models/updater_models.dart';

sealed class DatabaseKey<T extends Object> with EquatableMixin {
  const DatabaseKey();
  T toKey();
}

class StringKey extends DatabaseKey<String> {
  final String key;
  const StringKey(this.key);

  @override
  String toKey() {
    return key;
  }

  @override
  List<Object?> get props => [key];
}

class IntKey extends DatabaseKey<int> {
  final int key;
  const IntKey(this.key);

  @override
  int toKey() {
    return key;
  }

  @override
  List<Object?> get props => [key];
}

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

sealed class Stores<K extends DatabaseKey, V extends Base> {
  final K Function(Object) from;
  const Stores(this.from);

  StoreRef<Object, Object> storeRef();
  V fromJson(Object json);
}

sealed class _Store<K extends DatabaseKey, V extends Base, T extends Stores<K, V>> extends ChangeNotifier {
  final DataBase database;
  T store;
  Map<K, V>? _cached;
  Map<K, V> get items {
    if (_cached != null) {
      return _cached!;
    }
    all().then((_) => notifyListeners());
    return {};
  }

  _Store({required this.database, required this.store});

  Future<K> write(V value) async {
    final db = await database.db;
    final resp = store.from(await store.storeRef().add(db, value.toJson()));
    if (_cached != null) {
      _cached![resp] = value;
    }
    notifyListeners();
    return resp;
  }

  Future<bool> delete(K key) async {
    final db = await database.db;
    return await store.storeRef().record(key.toKey()).delete(db) != null;
  }

  Future<Map<K, V>> all() async {
    if (_cached != null) {
      return _cached!;
    }

    final db = await database.db;
    final res = await store.storeRef().find(db, finder: Finder());

    final map = <K, V>{};
    for (var e in res) {
      map[store.from(e.key)] = store.fromJson(e.value);
    }
    _cached = map;
    return _cached!;
  }

  Future<V?> get(K key) async {
    final db = await database.db;
    return store.fromJson(store.storeRef().record(key.toKey()).get(db));
  }
}

class ServerStore extends _Store<IntKey, Server, ServerStores> {
  ServerStore({required super.database, required super.store});
}

class ServerStores extends Stores<IntKey, Server> {
  static final _instance = ServerStores._internal(_toDatabaseKey);
  ServerStores._internal(super.from);
  factory ServerStores() => _instance;

  static IntKey _toDatabaseKey(Object key) {
    return IntKey(key as int);
  }

  static final _storeServer = StoreRef<IntKey, Object>('server');

  @override
  StoreRef<IntKey, Object> storeRef() {
    return _storeServer;
  }

  @override
  Server fromJson(Object json) {
    return Server.fromJson(json as Map<String, Object?>);
  }
}

class ServerDataStore extends _Store<StringKey, ServerDataBase, ServerDataStores> {
  ServerDataStore({required super.database, required super.store});
}

class ServerDataStores extends Stores<StringKey, ServerDataBase> {
  static final _instance = ServerDataStores._internal(_toDatabaseKey);
  ServerDataStores._internal(super.from);
  factory ServerDataStores() => _instance;

  static StringKey _toDatabaseKey(Object key) {
    return StringKey(key as String);
  }

  static final _storeServerData = StoreRef<int, Object>('server_data');

  @override
  ServerDataBase fromJson(Object json) {
    return ServerDataBase.fromJson(json as Map<String, Object?>);
  }

  @override
  StoreRef<int, Object> storeRef() {
    return _storeServerData;
  }
}
