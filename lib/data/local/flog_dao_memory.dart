import 'dart:async';

import 'package:sembast/sembast.dart';

import 'app_database.dart';
import 'dao.dart';

class FlogDaoMemory extends Dao {
  // Singleton instance
  static final FlogDaoMemory _singleton = FlogDaoMemory._();

  /// Singleton accessor
  static FlogDaoMemory get instance => _singleton;

  // A private constructor. Allows us to create instances of FlogDao
  // only from within the FlogDao class itself.
  FlogDaoMemory._();

  @override
  Future<Database> get db => AppDatabase.instance.memoryDatabase;
}
