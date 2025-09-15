class LogEntry {
  final int? id;
  final DateTime timestamp;
  final String entryType;
  final String title;
  final String? data;
  final String? notes;
  final bool reportTag;

  LogEntry({
    this.id,
    required this.timestamp,
    required this.entryType,
    required this.title,
    this.data,
    this.notes,
    this.reportTag = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'entry_type': entryType,
      'title': title,
      'data': data,
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
      data: map['data'],
      notes: map['notes'],
      reportTag: map['report_tag'] == 1,
    );
  }
}
