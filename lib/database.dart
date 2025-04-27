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

sealed class Stores<DBKey extends Object, K extends DatabaseKey<DBKey>, V extends Base> {
  final K Function(DBKey) from;
  const Stores(this.from);

  StoreRef<DBKey, Object> storeRef();
  V fromJson(Object json);
}

sealed class _Store<DBKey extends Object, K extends DatabaseKey<DBKey>, V extends Base, T extends Stores<DBKey, K, V>>
    extends ChangeNotifier {
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

  Future<K> add(V value) async {
    final db = await database.db;
    final key = await store.storeRef().add(db, value.toJson());
    final resp = store.from(key);
    if (_cached != null) {
      _cached![resp] = value;
    }
    notifyListeners();
    return resp;
  }

  Future<void> put(K key, V value) async {
    final db = await database.db;
    await store.storeRef().record(key.toKey()).put(db, value.toJson());
    if (_cached != null) {
      _cached![key] = value;
    }
    notifyListeners();
  }

  Future<bool> delete(K key) async {
    final db = await database.db;
    final result = await store.storeRef().record(key.toKey()).delete(db) != null;
    if (result && _cached != null) {
      _cached!.remove(key);
    }
    notifyListeners();
    return result;
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
    if (_cached != null) {
      return _cached![key];
    }
    final db = await database.db;
    final obj = await store.storeRef().record(key.toKey()).get(db);
    if (obj == null) {
      return null;
    } else {
      return store.fromJson(obj);
    }
  }

  V? getSync(K key) {
    if (_cached != null) {
      return _cached![key];
    }
    return null;
  }
}

class ServerStore extends _Store<int, IntKey, Server, ServerStores> {
  ServerStore({required super.database, required super.store});
}

class ServerStores extends Stores<int, IntKey, Server> {
  static final _instance = ServerStores._internal(_toDatabaseKey);
  ServerStores._internal(super.from);
  factory ServerStores() => _instance;

  static IntKey _toDatabaseKey(Object key) {
    return IntKey(key as int);
  }

  static final _storeServer = intMapStoreFactory.store('server');

  @override
  StoreRef<int, Object> storeRef() {
    return _storeServer;
  }

  @override
  Server fromJson(Object json) {
    return Server.fromJson(json as Map<String, Object?>);
  }
}

class ServerDataStore extends _Store<String, StringKey, ServerDataBase, ServerDataStores> {
  ServerDataStore({required super.database, required super.store});

  @override
  @Deprecated("use insert mehtod")
  Future<void> put(StringKey key, ServerDataBase value) async {
    throw UnimplementedError("do not use this method, use insert instead");
  }

  @override
  @Deprecated("invalid method")
  Future<StringKey> add(ServerDataBase value) async {
    throw UnimplementedError(
        "invalid method, cannot insert server data without an associated server");
  }

  @override
  @Deprecated("use remove method")
  Future<bool> delete(StringKey key) async {
    throw UnimplementedError("do not use this method, use remove instead");
  }

  @override
  @Deprecated("invalid method")
  Future<ServerDataBase?> get(StringKey key) async {
    throw UnimplementedError("do not use this method, use giveme instead");
  }

  Future<void> insert(Server key, ServerDataBase value) {
    return super.put(StringKey(key.name.value), value);
  }

  Future<bool> remove(Server key) {
    return super.delete(StringKey(key.name.value));
  }

  Future<ServerDataBase?> giveme(Server key) {
    return super.get(StringKey(key.name.value));
  }

  ServerDataBase? givemeSync(Server key) {
    return super.getSync(StringKey(key.name.value));
  }
}

class ServerDataStores extends Stores<String, StringKey, ServerDataBase> {
  static final _instance = ServerDataStores._internal(_toDatabaseKey);
  ServerDataStores._internal(super.from);
  factory ServerDataStores() => _instance;

  static StringKey _toDatabaseKey(Object key) {
    return StringKey(key as String);
  }

  static final _storeServerData = stringMapStoreFactory.store('server_data');

  @override
  ServerDataBase fromJson(Object json) {
    return ServerDataBase.fromJson(json as Map<String, Object?>);
  }

  @override
  StoreRef<String, Object> storeRef() {
    return _storeServerData;
  }
}
