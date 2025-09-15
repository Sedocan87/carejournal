import 'dart:io';
import 'package:carejournal/models/log_entry.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class CsvExportService {
  Future<void> generateAndShareCsv(List<LogEntry> logEntries) async {
    List<List<dynamic>> rows = [];
    rows.add(['id', 'timestamp', 'entry_type', 'title', 'data', 'notes', 'report_tag']);
    for (var entry in logEntries) {
      rows.add([
        entry.id,
        entry.timestamp.toIso8601String(),
        entry.entryType,
        entry.title,
        entry.data,
        entry.notes,
        entry.reportTag,
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/care_journal_export.csv');
    await file.writeAsString(csv);

    await Share.shareXFiles([XFile(file.path)], text: 'CareJournal Data Export');
  }
}
