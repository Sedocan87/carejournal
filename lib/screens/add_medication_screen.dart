import 'package:carejournal/models/log_entry.dart';
import 'package:carejournal/services/database_service.dart';
import 'package:carejournal/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagController = TextEditingController();
  final List<String> _selectedTags = [];
  List<String> _allTags = [];
  DateTime? _reminderDate;

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

  Future<void> _pickReminderDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _reminderDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_reminderDate ?? DateTime.now()),
    );
    if (time == null) return;

    setState(() {
      _reminderDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medication'),
        actions: [
          TextButton(
            onPressed: _saveMedication,
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
              Text('Medication Name', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Ibuprofen, Paracetamol',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a medication name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text('Notes', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Dosage, frequency, etc.',
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              Text('Reminder', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _reminderDate == null
                          ? 'No reminder set'
                          : DateFormat.yMd().add_jm().format(_reminderDate!),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickReminderDate,
                  ),
                ],
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

  void _saveMedication() async {
    if (_formKey.currentState!.validate()) {
      final newEntry = LogEntry(
        timestamp: DateTime.now(),
        entryType: 'medication',
        title: _titleController.text,
        notes: _notesController.text,
      );
      final logEntryId = await DatabaseService.instance.insertLogEntry(newEntry.toMap(), _selectedTags);

      if (_reminderDate != null) {
        await NotificationService().scheduleNotification(
          id: logEntryId,
          title: 'Reminder: ${_titleController.text}',
          body: _notesController.text,
          scheduledDate: _reminderDate!,
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }
}