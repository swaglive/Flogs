import 'dart:convert';

class LogCursor {
  int? id;
  String? tag;
  int? cursor;

  LogCursor({
    this.tag,
    this.cursor,
  });

  /// Converts class to json
  Map<String, dynamic> toJson() {
    return {
      'tag': tag,
      'cursor': cursor,
    };
  }

  /// create `Log` from json
  static LogCursor fromJson(Map<String, dynamic> json) {
    return LogCursor(
      tag: json['tag'],
      cursor: json['cursor'],
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}
