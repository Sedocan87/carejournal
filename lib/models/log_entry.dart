import 'dart:convert';

class LogEntry {
  final int? id;
  final DateTime timestamp;
  final String entryType;
  final String title;
  final Map<String, dynamic>? data;
  final String? notes;
  final bool reportTag;
  final List<String> tags;

  LogEntry({
    this.id,
    required this.timestamp,
    required this.entryType,
    required this.title,
    this.data,
    this.notes,
    this.reportTag = false,
    this.tags = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'entry_type': entryType,
      'title': title,
      'data': data != null ? jsonEncode(data) : null,
      'notes': notes,
      'report_tag': reportTag ? 1 : 0,
    };
  }

  factory LogEntry.fromMap(Map<String, dynamic> map) {
    return LogEntry(
      id: map['id'],
      timestamp: DateTime.parse(map['timestamp']),
      entryType: map['entry_type'],
      title: map['title'],
      data: map['data'] != null ? jsonDecode(map['data']) : null,
      notes: map['notes'],
      reportTag: map['report_tag'] == 1,
    );
  }

  LogEntry copyWith({
    int? id,
    DateTime? timestamp,
    String? entryType,
    String? title,
    Map<String, dynamic>? data,
    String? notes,
    bool? reportTag,
    List<String>? tags,
  }) {
    return LogEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      entryType: entryType ?? this.entryType,
      title: title ?? this.title,
      data: data ?? this.data,
      notes: notes ?? this.notes,
      reportTag: reportTag ?? this.reportTag,
      tags: tags ?? this.tags,
    );
  }
}
