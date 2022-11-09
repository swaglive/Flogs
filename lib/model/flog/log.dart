import 'dart:convert';

import '../../f_logs.dart';

class Log {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Log.
  int? id;

  String? tag;
  String? className;
  String? methodName;
  String? text;
  String? timestamp;
  String? exception;
  String? dataLogType;
  int? timeInMillis;
  LogLevel? logLevel;
  String? stacktrace;

  /// Any data you want to log.
  Map<String, dynamic>? context;

  /// Any labels like Github issue labels
  List<String>? labels;

  Log({
    this.tag,
    this.className,
    this.methodName,
    this.text,
    this.timestamp,
    this.timeInMillis,
    this.exception,
    this.logLevel,
    this.dataLogType,
    this.stacktrace,
    this.context,
    this.labels,
  });

  /// Converts class to json
  Map<String, dynamic> toJson() {
    return {
      'tag': tag,
      'className': className,
      'methodName': methodName,
      'text': text,
      'timestamp': timestamp,
      'timeInMillis': timeInMillis,
      'exception': exception,
      'dataLogType': dataLogType,
      'logLevel': LogLevelConverter.fromEnumToString(logLevel),
      'stacktrace': stacktrace,
      'context': context,
      'labels': labels,
    };
  }

  /// create `Log` from json
  static Log fromJson(Map<String, dynamic> json) {
    return Log(
      tag: json['tag'],
      className: json['className'],
      methodName: json['methodName'],
      text: json['text'],
      timestamp: json['timestamp'],
      timeInMillis: json['timeInMillis'],
      exception: json['exception'],
      dataLogType: json['dataLogType'],
      logLevel: LogLevelConverter.fromStringToEnum(json['logLevel']),
      stacktrace: json['stacktrace'],
      context: json['context'],
      labels: json['labels'],
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}
