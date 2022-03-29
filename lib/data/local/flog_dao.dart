import 'dart:async';

import 'package:f_logs/f_logs.dart';
import 'package:sembast/sembast.dart';

class FlogDao extends Dao {
  // Singleton instance
  static final FlogDao _singleton = FlogDao._();

  /// Singleton accessor
  static FlogDao get instance => _singleton;

  // A private constructor. Allows us to create instances of FlogDao
  // only from within the FlogDao class itself.
  FlogDao._();

  @override
  Future<Database> get db => AppDatabase.instance.database;
}
