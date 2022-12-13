import 'dart:convert';

import '../../f_logs.dart';

class Log {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Log.
  int? id;

  String? tag;
  String? className;
  String? methodName;
  String? message;
  String? timestamp;
  String? exception;
  String? dataLogType;
  int? timeInMillis;
  LogLevel? logLevel;
  String? stacktrace;

  /// Any data you want to log.
  Map<String, dynamic>? context;

  /// Global context of the application
  Map<String, dynamic>? globalContext;

  /// Any labels like Github issue labels
  List<String>? labels;

  List<String>? dispatcheredTags;

  Log({
    this.tag,
    this.className,
    this.methodName,
    this.message,
    this.timestamp,
    this.timeInMillis,
    this.exception,
    this.logLevel,
    this.dataLogType,
    this.stacktrace,
    this.context,
    this.globalContext,
    this.labels,
    this.dispatcheredTags,
  });

  /// Converts class to json
  Map<String, dynamic> toJson() {
    return {
      'tag': tag,
      'message': message,
      'timestamp': timestamp,
      'timeInMillis': timeInMillis,
      'exception': exception,
      'dataLogType': dataLogType,
      'logLevel': LogLevelConverter.fromEnumToString(logLevel),
      'stacktrace': stacktrace,
      'context': context,
      'globalContext': globalContext,
      'labels': labels,
      'dispatcheredTags': dispatcheredTags,
    };
  }

  /// create `Log` from json
  static Log fromJson(Map<String, dynamic> json) {
    return Log(
      tag: json['tag'],
      className: json['className'],
      methodName: json['methodName'],
      message: json['message'],
      timestamp: json['timestamp'],
      timeInMillis: json['timeInMillis'],
      exception: json['exception'],
      dataLogType: json['dataLogType'],
      logLevel: LogLevelConverter.fromStringToEnum(json['logLevel']),
      stacktrace: json['stacktrace'],
      context: json['context'],
      globalContext: json['globalContext'],
      labels: json['labels'],
      dispatcheredTags: json['dispatcheredTags'],
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}
