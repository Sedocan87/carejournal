import 'dart:io';
import 'package:carejournal/models/log_entry.dart';
import 'package:carejournal/services/database_helper.dart';
import 'package:carejournal/services/notification_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _locationController = TextEditingController();
  final _tagController = TextEditingController();
  final List<String> _tags = [];
  XFile? _imageFile;
  String _selectedEntryType = 'Note';
  double _severity = 5.0;
  DateTime? _reminderDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Entry'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedEntryType,
                        items: ['Note', 'Symptom', 'Photo', 'Medication', 'Appointment']
                            .map(
                              (label) => DropdownMenuItem(
                                value: label,
                                child: Text(label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedEntryType = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Entry Type',
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Title', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      if (_selectedEntryType == 'Symptom') ...[
                        Text('Severity', style: theme.textTheme.titleLarge),
                        Slider(
                          value: _severity,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: _severity.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              _severity = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Text('Location', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      if (_selectedEntryType == 'Medication' ||
                          _selectedEntryType == 'Appointment') ...[
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
                        const SizedBox(height: 20),
                      ],
                      Text('Notes', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        maxLines: 5,
                      ),
                      const SizedBox(height: 20),
                      Text('Tags', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: _tags
                            .map((tag) => Chip(
                                  label: Text(tag),
                                  onDeleted: () {
                                    setState(() {
                                      _tags.remove(tag);
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                      TextFormField(
                        controller: _tagController,
                        decoration: InputDecoration(
                          hintText: 'Add a tag',
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        onFieldSubmitted: (value) {
                          if (value.isNotEmpty && !_tags.contains(value)) {
                            setState(() {
                              _tags.add(value);
                            });
                            _tagController.clear();
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      if (_selectedEntryType == 'Photo')
                        if (_imageFile == null)
                          GestureDetector(
                            onTap: _pickImage,
                            child: DottedBorder(
                              color: theme.colorScheme.onSurface,
                              strokeWidth: 1,
                              dashPattern: const [6, 6],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Add Photo',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.file(
                                File(_imageFile!.path),
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _imageFile = null;
                                  });
                                },
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveEntry();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Save Entry', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
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

  void _saveEntry() async {
    Map<String, dynamic> data = {};
    if (_selectedEntryType == 'Symptom') {
      data['severity'] = _severity;
      data['location'] = _locationController.text;
    } else if (_selectedEntryType == 'Photo') {
      data['path'] = _imageFile?.path;
    }

    final newEntry = LogEntry(
      timestamp: DateTime.now(),
      entryType: _selectedEntryType.toLowerCase(),
      title: _titleController.text,
      notes: _notesController.text,
      data: data,
    );
    final logEntryId = await DatabaseHelper().insertLogEntry(newEntry.toMap(), _tags);

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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }
}
