import 'dart:io';
import 'package:carejournal/models/log_entry.dart';
import 'package:carejournal/screens/privacy_policy_screen.dart';
import 'package:carejournal/services/csv_export_service.dart';
import 'package:carejournal/services/database_helper.dart';
import 'package:carejournal/services/pdf_export_service.dart';
import 'package:flutter/material.dart';
import 'package:carejournal/screens/add_entry_screen.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late Future<List<LogEntry>> _logEntriesFuture;

  @override
  void initState() {
    super.initState();
    _loadLogEntries();
  }

  void _loadLogEntries() {
    setState(() {
      _logEntriesFuture = _getLogEntries();
    });
  }

  Future<List<LogEntry>> _getLogEntries() async {
    final maps = await DatabaseHelper().getLogEntries();
    return List.generate(maps.length, (i) {
      return LogEntry.fromMap(maps[i]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CareJournal',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final logEntries = await _logEntriesFuture;
              if (logEntries.isNotEmpty) {
                await PdfExportService().generateAndSharePdf(logEntries);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.privacy_tip),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.description),
            onPressed: () async {
              final logEntries = await _logEntriesFuture;
              if (logEntries.isNotEmpty) {
                await CsvExportService().generateAndShareCsv(logEntries);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<LogEntry>>(
        future: _logEntriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No entries yet.'));
          }

          final logEntries = snapshot.data!;
          return ListView.builder(
            itemCount: logEntries.length,
            itemBuilder: (context, index) {
              final entry = logEntries[index];
              return Card(
                child: ListTile(
                  title: Text(
                    entry.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.notes ?? ''),
                      if (entry.entryType == 'photo' && entry.data != null)
                        Image.file(File(entry.data!), height: 150),
                    ],
                  ),
                  trailing: Text(
                    entry.timestamp.toString(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEntryScreen()),
          );
          if (result == true) {
            _loadLogEntries();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
