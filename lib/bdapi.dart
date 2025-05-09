import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:updater_client/api.dart';
import 'package:updater_client/database.dart';
import 'package:updater_client/models/base.dart';
import 'package:updater_client/models/server.dart';
import 'package:updater_client/models/updater_models.dart';
import 'package:updater_client/utils/utils.dart';

class SessionManager {
  final Session _session;
  final ServerDataRepository serverDataRepo;
  final ServerConfigurationRepository serverConfigRepo;

  Server get server => _session.server;
  ValueNotifier<SessionConnectionState> get state => _session.state;

  SessionManager(this._session, this.serverDataRepo, this.serverConfigRepo);

  DateTime? _listCacheStartTime;
  Stream<Result<ServerData, ApiError>> list({bool noCache = false}) async* {
    bool cache = true;
    if (noCache) {
      cache = false;
    } else if (_listCacheStartTime == null) {
      cache = false;
    } else if (DateTime.now().difference(_listCacheStartTime!) > const Duration(minutes: 120)) {
      cache = false;
    }

    var data = await serverDataRepo.giveme(_session.server);
    if (data != null) {
      yield Result.success(data.toServerData());
      if (cache) {
        return;
      }
    }

    final resultFuture = _session.list();
    final result = await resultFuture;

    if (result.isSuccess()) {
      _listCacheStartTime = DateTime.now();
      yield result;
      await serverDataRepo.insert(_session.server, ServerDataBase(result.unsafeGetSuccess()));
    } else {
      yield result;
    }
  }

  Future<Result<UpgradeResponse, ApiError>> upgrade() async {
    final result = await _session.upgrade();
    result.match(
      onSuccess: (v) {
        switch (v) {
          case Upgrade():
            list(noCache: true);
          case UpToDate():
        }
      },
      onError: (e) {},
    );
    return result;
  }

  Future<Result<Void, ApiError>> reload() {
    final response = _session.reload();
    response.then((value) => null);
    return response;
  }

  Future<Result<ServerConfiguration, ApiError>> config() async {
    return await _session.config();
  }
}

class Sessionaizer extends ChangeNotifier {
  late final Map<int, SessionManager> sessions;
  late final ServerRepository serverRepo;
  late final ServerDataRepository serverDataRepo;
  late final ServerConfigurationRepository serverConfigRepo;

  Sessionaizer() {
    serverRepo = GetIt.instance.get<ServerRepository>();
    serverDataRepo = GetIt.instance.get<ServerDataRepository>();
    serverConfigRepo = GetIt.instance.get<ServerConfigurationRepository>();

    sessions = {};
    serverRepo.addListener(_updateSessions);

    for (final dbKey in serverRepo.items.keys) {
      final key = dbKey.toKey();
      final server = serverRepo.items[dbKey]!;
      final session = Session(server);
      _openSession(session);
      session.state.addListener(() => notifyListeners());
      sessions[key] = SessionManager(session, serverDataRepo, serverConfigRepo);
    }
  }

  void _openSession(Session session) {
    session.open().then(
      (_) => notifyListeners(),
      onError: (error) {
        // TODO improve error handling
        print("Server ${session.server.name.value} failed to login with $error");
      },
    );
  }

  void _updateSessions() {
    for (final dbKey in serverRepo.items.keys) {
      final key = dbKey.toKey();
      final item = serverRepo.items[dbKey]!;
      final sessionServer = sessions[key]?.server;

      if (sessionServer == null || sessions[key]!.server != item) {
        sessions[key] = SessionManager(Session(item), serverDataRepo, serverConfigRepo);
        _openSession(sessions[key]!._session);
      }
    }

    final toRemove = <int>[];
    for (final key in sessions.keys) {
      if (serverRepo.items[IntKey(key)] == null) {
        toRemove.add(key);
      }
    }
    sessions.removeWhere((e, _) => toRemove.contains(e));
    notifyListeners();
  }
}
