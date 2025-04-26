import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:updater_client/api.dart';
import 'package:updater_client/database.dart';
import 'package:updater_client/models/server.dart';
import 'package:updater_client/models/updater_models.dart';
import 'package:updater_client/utils/utils.dart';

class SessionManager {
  final Session session;
  final ServerDataStore store;

  Server get server => session.server;
  ValueNotifier<SessionConnectionState> get state => session.state;

  SessionManager(this.session, this.store);

  DateTime? _listCacheStartTime;
  Stream<Result<ServerData, ApiError>> list() async* {
    bool cache = true;
    if (_listCacheStartTime == null) {
      cache = false;
    } else if (DateTime.now().difference(_listCacheStartTime!) > const Duration(minutes: 120)) {
      cache = false;
    }

    var data = await store.giveme(session.server);
    if (data != null) {
      yield Result.success(data.toServerData());
      if (cache) {
        return;
      }
    }

    final resultFuture = session.list();
    final result = await resultFuture;

    if (result.isSuccess()) {
      _listCacheStartTime = DateTime.now();
      yield result;
      await store.insert(session.server, ServerDataBase(result.unsafeGetSuccess()));
    } else {
      yield result;
    }
  }

  Future<Result<Void, ApiError>> upgrade() {
    return session.upgrade();
  }

  Future<Result<Void, ApiError>> reload() {
    return session.reload();
  }

  Stream<Result<String, ApiError>> config() async* {
    throw UnimplementedError("i need a config store first");
  }
}

class Sessionaizer extends ChangeNotifier {
  late final Map<int, SessionManager> sessions;
  late final ServerStore serverStore;
  late final ServerDataStore serverDataStore;

  Sessionaizer() {
    serverStore = GetIt.instance.get<ServerStore>();
    serverDataStore = GetIt.instance.get<ServerDataStore>();

    sessions = {};
    serverStore.addListener(_updateSessions);

    for (final dbKey in serverStore.items.keys) {
      final key = dbKey.toKey();
      final server = serverStore.items[dbKey]!;
      final session = Session(server);
      _openSession(session);
      session.state.addListener(() => notifyListeners());
      sessions[key] = SessionManager(session, serverDataStore);
    }
  }

  void _openSession(Session session) {
    session.open().then((_) => notifyListeners());
  }

  void _updateSessions() {
    for (final dbKey in serverStore.items.keys) {
      final key = dbKey.toKey();
      final item = serverStore.items[dbKey]!;
      final sessionServer = sessions[key]?.server;

      if (sessionServer == null || sessions[key]!.server != item) {
        sessions[key] = SessionManager(Session(item), serverDataStore);
        _openSession(sessions[key]!.session);
      }
    }

    final toRemove = <int>[];
    for (final key in sessions.keys) {
      if (serverStore.items[IntKey(key)] == null) {
        toRemove.add(key);
      }
    }
    sessions.removeWhere((e, _) => toRemove.contains(e));
    notifyListeners();
  }
}
