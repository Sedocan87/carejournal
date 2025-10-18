import 'dart:io';
import 'package:carejournal/models/log_entry.dart';
import 'package:carejournal/screens/dashboard_screen.dart';
import 'package:carejournal/screens/privacy_policy_screen.dart';
import 'package:carejournal/screens/settings_screen.dart';
import 'package:carejournal/services/backup_service.dart';
import 'package:carejournal/services/csv_export_service.dart';
import 'package:carejournal/services/database_service.dart';
import 'package:carejournal/screens/photo_detail_screen.dart';
import 'package:carejournal/services/pdf_export_service.dart';
import 'package:carejournal/widgets/add_entry_modal.dart';
import 'package:carejournal/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<LogEntry> _logEntries = [];
  final _searchController = TextEditingController();
  final _backupService = BackupService();
  List<String> _selectedTags = [];
  String? _selectedEntryTypeFilter;
  DateTime? _startDateFilter;
  DateTime? _endDateFilter;

  @override
  void initState() {
    super.initState();
    _loadLogEntries();
    _searchController.addListener(() {
      _loadLogEntries(
        searchQuery: _searchController.text,
        tags: _selectedTags,
        entryType: _selectedEntryTypeFilter,
        startDate: _startDateFilter,
        endDate: _endDateFilter,
      );
    });
  }

  Future<void> _loadLogEntries({
    String? searchQuery,
    List<String>? tags,
    String? entryType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final entries = await _getLogEntries(
      searchQuery: searchQuery,
      tags: tags,
      entryType: entryType,
      startDate: startDate,
      endDate: endDate,
    );
    setState(() {
      _logEntries = entries;
    });
  }

  Future<List<LogEntry>> _getLogEntries({
    String? searchQuery,
    List<String>? tags,
    String? entryType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final dbHelper = DatabaseService.instance;
    final maps = await dbHelper.getLogEntries(
      searchQuery: searchQuery,
      tags: tags,
      entryType: entryType,
      startDate: startDate,
      endDate: endDate,
    );
    final entries = List.generate(maps.length, (i) {
      return LogEntry.fromMap(maps[i]);
    });

    final entriesWithTags = <LogEntry>[];
    for (final entry in entries) {
      if (entry.id != null) {
        final tags = await dbHelper.getTagsForLogEntry(entry.id!);
        entriesWithTags.add(entry.copyWith(tags: tags));
      } else {
        entriesWithTags.add(entry);
      }
    }
    return entriesWithTags;
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
          Semantics(
            label: 'Settings',
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ),
          Semantics(
            label: 'Filter entries',
            child: IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showFilterDialog,
            ),
          ),
          Semantics(
            label: 'View dashboard',
            child: IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              },
            ),
          ),
          Semantics(
            label: 'More options',
            child: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'backup',
                  child: Text('Backup'),
                ),
                const PopupMenuItem(
                  value: 'restore',
                  child: Text('Restore'),
                ),
                const PopupMenuItem(
                  value: 'pdf',
                  child: Text('Export PDF'),
                ),
                const PopupMenuItem(
                  value: 'csv',
                  child: Text('Export CSV'),
                ),
                const PopupMenuItem(
                  value: 'privacy',
                  child: Text('Privacy Policy'),
                ),
              ],
              onSelected: (value) {
                if (value == 'backup') {
                  _backupService.backupDatabase(context);
                } else if (value == 'restore') {
                  _backupService.restoreDatabase(context).then((_) {
                    _loadLogEntries(tags: _selectedTags);
                  });
                } else if (value == 'pdf') {
                  if (_logEntries.isNotEmpty) {
                    PdfExportService().generateAndSharePdf(_logEntries);
                  }
                } else if (value == 'csv') {
                  if (_logEntries.isNotEmpty) {
                    CsvExportService().generateAndShareCsv(_logEntries);
                  }
                } else if (value == 'privacy') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Semantics(
              label: 'Search entries',
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search entries...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
              ),
            ),
          ),
          Expanded(
            child: _logEntries.isEmpty
                ? const EmptyState(
                    message: "Your journal is ready. Tap the '+' to log your first entry and start your health story.",
                    icon: Icons.book_outlined,
                  )
                : AnimatedList(
                    key: _listKey,
                    initialItemCount: _logEntries.length,
                    itemBuilder: (context, index, animation) {
                      return _buildItem(_logEntries[index], animation);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Semantics(
        label: 'Add new log entry',
        child: FloatingActionButton(
          onPressed: () async {
            final result = await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => const AddEntryModal(),
            );
            if (result == true) {
              await _loadLogEntries(tags: _selectedTags);
              if (_logEntries.isNotEmpty && _listKey.currentState != null) {
                _listKey.currentState!.insertItem(0, duration: const Duration(milliseconds: 500));
              }
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildItem(LogEntry entry, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Semantics(
          label:
              'Log entry: ${entry.title}, at ${entry.timestamp.toString()}',
          child: Card(
            child: ExpansionTile(
              title: Text(
                entry.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(
                entry.timestamp.toString(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (entry.notes != null &&
                          entry.notes!.isNotEmpty)
                        Text(entry.notes!),
                      if (entry.entryType == 'symptom')
                        Row(
                          children: [
                            Text(
                                'Severity: ${entry.data!['severity']}'),
                            const SizedBox(width: 10),
                            Text(
                                'Location: ${entry.data!['location']}'),
                          ],
                        ),
                      if (entry.entryType == 'photo' &&
                          entry.data != null &&
                          entry.data!['path'] != null)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoDetailScreen(
                                  imagePath: entry.data!['path']! as String,
                                  tag: 'photo-${entry.id}',
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'photo-${entry.id}',
                            child: Image.file(
                              File(entry.data!['path']! as String),
                              height: 150,
                            ),
                          ),
                        ),
                      if (entry.tags.isNotEmpty)
                        Wrap(
                          spacing: 8.0,
                          children: entry.tags
                              .map((tag) => Chip(label: Text(tag)))
                              .toList(),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() async {
    final allTags = await DatabaseService.instance.getAllTags();
    List<String> tempSelectedTags = List<String>.from(_selectedTags);
    String? tempSelectedEntryTypeFilter = _selectedEntryTypeFilter;
    DateTime? tempStartDateFilter = _startDateFilter;
    DateTime? tempEndDateFilter = _endDateFilter;

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Entries'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Entry Type', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButtonFormField<String>(
                      value: tempSelectedEntryTypeFilter,
                      items: ['All', 'Note', 'Symptom', 'Photo', 'Medication', 'Appointment']
                          .map(
                            (label) => DropdownMenuItem(
                              value: label == 'All' ? null : label.toLowerCase(),
                              child: Text(label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          tempSelectedEntryTypeFilter = value;
                        });
                      },
                      decoration: const InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Date Range', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: tempStartDateFilter ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (picked != null) {
                                setState(() {
                                  tempStartDateFilter = picked;
                                });
                              }
                            },
                            child: Text(tempStartDateFilter == null
                                ? 'Start Date'
                                : DateFormat.yMd().format(tempStartDateFilter!)),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: tempEndDateFilter ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (picked != null) {
                                setState(() {
                                  tempEndDateFilter = picked;
                                });
                              }
                            },
                            child: Text(tempEndDateFilter == null
                                ? 'End Date'
                                : DateFormat.yMd().format(tempEndDateFilter!)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8.0,
                      children: allTags.map((tag) {
                        final isSelected = tempSelectedTags.contains(tag);
                        return FilterChip(
                          label: Text(tag),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                tempSelectedTags.add(tag);
                              } else {
                                tempSelectedTags.remove(tag);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedTags = tempSelectedTags;
                  _selectedEntryTypeFilter = tempSelectedEntryTypeFilter;
                  _startDateFilter = tempStartDateFilter;
                  _endDateFilter = tempEndDateFilter;
                });
                _loadLogEntries(
                  searchQuery: _searchController.text,
                  tags: _selectedTags,
                  entryType: _selectedEntryTypeFilter,
                  startDate: _startDateFilter,
                  endDate: _endDateFilter,
                );
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}