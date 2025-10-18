import 'dart:io';
import 'package:carejournal/models/log_entry.dart';
import 'package:carejournal/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotoScreen extends StatefulWidget {
  const AddPhotoScreen({super.key});

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagController = TextEditingController();
  final List<String> _selectedTags = [];
  List<String> _allTags = [];
  XFile? _imageFile;

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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Photo'),
        actions: [
          TextButton(
            onPressed: _savePhoto,
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
              if (_imageFile == null)
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined, size: 48, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(height: 8),
                          Text('Tap to select a photo', style: theme.textTheme.bodyLarge),
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
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _imageFile = null;
                        });
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              Text('Title', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Skin Rash, Swollen Ankle',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
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

  void _savePhoto() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      final newEntry = LogEntry(
        timestamp: DateTime.now(),
        entryType: 'photo',
        title: _titleController.text,
        notes: _notesController.text,
        data: {'path': _imageFile!.path},
      );
      await DatabaseService.instance.insertLogEntry(newEntry.toMap(), _selectedTags);
      if (!mounted) return;
      Navigator.pop(context, true);
    } else if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a photo.')),
      );
    }
  }
}