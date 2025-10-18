import 'package:carejournal/models/log_entry.dart';
import 'package:carejournal/services/database_service.dart';
import 'package:carejournal/widgets/severity_selector.dart';
import 'package:flutter/material.dart';

class LogSymptomScreen extends StatefulWidget {
  const LogSymptomScreen({super.key});

  @override
  State<LogSymptomScreen> createState() => _LogSymptomScreenState();
}

class _LogSymptomScreenState extends State<LogSymptomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagController = TextEditingController();
  final List<String> _selectedTags = [];
  List<String> _allTags = [];
  int _severity = 5;

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    final tags = await DatabaseService.instance.getAllTags();
    setState(() {
      _allTags = tags;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Symptom'),
        actions: [
          TextButton(
            onPressed: _saveSymptom,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Symptom Name', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Headache, Nausea',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a symptom name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text('Severity (0-10)', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              SeveritySelector(
                severity: _severity,
                onSeverityChanged: (newSeverity) {
                  setState(() {
                    _severity = newSeverity;
                  });
                },
              ),
              const SizedBox(height: 24),
              Text('Notes', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Any additional details...',
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              Text('Tags', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _allTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return ChoiceChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              TextFormField(
                controller: _tagController,
                decoration: const InputDecoration(
                  hintText: 'Add a new tag and press enter',
                ),
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty && !_selectedTags.contains(value)) {
                    setState(() {
                      _allTags.add(value);
                      _selectedTags.add(value);
                    });
                    _tagController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveSymptom() async {
    if (_formKey.currentState!.validate()) {
      final newEntry = LogEntry(
        timestamp: DateTime.now(),
        entryType: 'symptom',
        title: _titleController.text,
        notes: _notesController.text,
        data: {'severity': _severity},
      );
      await DatabaseService.instance.insertLogEntry(newEntry.toMap(), _selectedTags);
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }
}