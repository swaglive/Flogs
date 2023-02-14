import 'package:f_logs/model/flog/log_cursor.dart';
import 'package:sembast/sembast.dart';

import '../../constants/db_constants.dart';
import '../../model/flog/log.dart';

abstract class Dao {
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Flogs objects
  // converted to Map
  final _flogsStore = intMapStoreFactory.store(DBConstants.FLOG_STORE_NAME);
  final _fcursorsStore =
      intMapStoreFactory.store(DBConstants.FCURSOR_STORE_NAME);
  int _JsonStringLength = -1;

  int get jsonStringLength => _JsonStringLength;

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get db;

  Future<void> _initDBStringSizeIfRequired({bool force = false}) async {
    if (force || _JsonStringLength <= 0) {
      await getAllLogs().then((logs) {
        _calculateListLog(logs);
      });
    } else {
      return;
    }
  }

  void _calculateListLog(List<Log> list) {
    int s = 0;
    list.forEach((e) {
      s += e.toJson().toString().length;
    });
    _JsonStringLength = s;
  }

  /// DB functions:--------------------------------------------------------------
  Future<int> insert(Log log) async {
    await _initDBStringSizeIfRequired();
    _JsonStringLength += log.toJson().toString().length;
    return await _flogsStore.add(await db, log.toJson());
  }

  /// Updates the `log` in Database
  Future update(Log log) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(log.id));
    await _flogsStore.update(
      await db,
      log.toJson(),
      finder: finder,
    );
  }

  /// Deletes the `log` from Database
  Future delete(Log log) async {
    final finder = Finder(filter: Filter.byKey(log.id));
    await _flogsStore.delete(
      await db,
      finder: finder,
    );
  }

  /// Deletes all Logs from Database which match the given `filters`.
  Future<int> deleteAllLogsByFilter({required List<Filter> filters}) async {
    final finder = Finder(
      filter: Filter.and(filters),
    );

    var deleted = await _flogsStore.delete(
      await db,
      finder: finder,
    );
    await _initDBStringSizeIfRequired(force: true);
    return deleted;
  }

  /// Deletes all Logs from Database
  Future deleteAll() async {
    await _flogsStore.delete(
      await db,
    );
    _JsonStringLength = 0;
  }

  /// Fetch all Logs which match the given `filters` and sorts them by `dataLogType`
  Future<List<Log>> getAllSortedByFilter(
      {required List<Filter> filters}) async {
    //creating finder
    final finder = Finder(
        filter: Filter.and(filters),
        sortOrders: [SortOrder(DBConstants.FIELD_DATA_LOG_TYPE)]);

    final recordSnapshots = await (_flogsStore.find(
      await db,
      finder: finder,
    ));

    // Making a List<Log> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final log = Log.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      log.id = snapshot.key;
      return log;
    }).toList();
  }

  /// fetch all Logs from Database
  Future<List<Log>> getAllLogs() async {
    final recordSnapshots = await (_flogsStore.find(
      await db,
    ));

    // Making a List<Log> out of List<RecordSnapshot>
    List<Log> list = recordSnapshots.map((snapshot) {
      final log = Log.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      log.id = snapshot.key;
      return log;
    }).toList();
    _calculateListLog(list);
    return list;
  }

  Future<List<Log>> query({Finder? finder}) async {
    final recordSnapshots = await (_flogsStore.find(await db, finder: finder));
    return recordSnapshots
        .map<Log>((snapshot) => Log.fromJson(snapshot.value)..id = snapshot.key)
        .toList();
  }

  Future<int> count({Filter? filter}) async =>
      _flogsStore.count(await db, filter: filter);

  Future<int> saveCursor(LogCursor logCursor) async {
    int? key = await (_fcursorsStore.findKey(await db,
        finder: Finder(filter: Filter.equals('tag', logCursor.tag))));
    if (key == null) {
      return await _fcursorsStore.add(await db, logCursor.toJson());
    }
    LogCursor _logCursor = logCursor;
    _logCursor.id = key;
    final finder = Finder(filter: Filter.byKey(key));
    return await _fcursorsStore.update(
      await db,
      _logCursor.toJson(),
      finder: finder,
    );
  }

  Future<List<LogCursor>> queryCursors() async {
    final recordSnapshots = await (_fcursorsStore.find(
      await db,
    ));
    return recordSnapshots
        .map<LogCursor>(
            (snapshot) => LogCursor.fromJson(snapshot.value)..id = snapshot.key)
        .toList();
  }
}
