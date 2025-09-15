import 'dart:io';
import 'package:carejournal/models/log_entry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class PdfExportService {
  Future<void> generateAndSharePdf(List<LogEntry> logEntries) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 0, child: pw.Text('CareJournal Report')),
              pw.TableHelper.fromTextArray(
                headers: ['Timestamp', 'Type', 'Title', 'Notes'],
                data: logEntries
                    .map((entry) => [
                          entry.timestamp.toString(),
                          entry.entryType,
                          entry.title,
                          entry.notes ?? '',
                        ])
                    .toList(),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/care_journal_report.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)], text: 'CareJournal Report');
  }
}
