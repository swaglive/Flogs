import 'dart:async';

import 'package:f_logs/f_logs.dart';
import 'package:sembast/sembast.dart';

class FlogDaoMock extends Dao {
  // Singleton instance
  static final FlogDaoMock _singleton = FlogDaoMock._();

  /// Singleton accessor
  static FlogDaoMock get instance => _singleton;

  // A private constructor. Allows us to create instances of FlogDao
  // only from within the FlogDao class itself.
  FlogDaoMock._();

  @override
  Future<Database> get db => AppDatabase.instance.mockDatabase;
}
