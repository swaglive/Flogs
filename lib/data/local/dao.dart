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

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get db;

  /// DB functions:--------------------------------------------------------------
  Future<int> insert(Log log) async {
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
    return deleted;
  }

  /// Deletes all Logs from Database
  Future deleteAll() async {
    await _flogsStore.delete(
      await db,
    );
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
    return recordSnapshots.map((snapshot) {
      final log = Log.fromJson(snapshot.value);
      // An ID is a key of a record from the database.
      log.id = snapshot.key;
      return log;
    }).toList();
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
    final finder = Finder(filter: Filter.byKey(key));
    return await _flogsStore.update(
      await db,
      logCursor.toJson(),
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
