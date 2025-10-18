import 'package:carejournal/screens/add_appointment_screen.dart';
import 'package:carejournal/screens/add_medication_screen.dart';
import 'package:carejournal/screens/add_note_screen.dart';
import 'package:carejournal/screens/add_photo_screen.dart';
import 'package:carejournal/screens/log_symptom_screen.dart';
import 'package:flutter/material.dart';

class AddEntryModal extends StatelessWidget {
  const AddEntryModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 24.0,
        right: 24.0,
        bottom: 32.0,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withAlpha(25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'What would you like to log?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          _buildModalButton(
            context,
            icon: Icons.waves,
            text: 'Log Symptom',
            onTap: () async {
              Navigator.pop(context); // Close the modal
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LogSymptomScreen()),
              );
              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
          const SizedBox(height: 16),
          _buildModalButton(
            context,
            icon: Icons.note_add_outlined,
            text: 'Add Note',
            onTap: () async {
              Navigator.pop(context); // Close the modal
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddNoteScreen()),
              );
              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
          const SizedBox(height: 16),
          _buildModalButton(
            context,
            icon: Icons.photo_camera_outlined,
            text: 'Attach Photo',
            onTap: () async {
              Navigator.pop(context); // Close the modal
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPhotoScreen()),
              );
              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
          const SizedBox(height: 16),
          _buildModalButton(
            context,
            icon: Icons.medical_services_outlined,
            text: 'Add Medication',
            onTap: () async {
              Navigator.pop(context); // Close the modal
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddMedicationScreen()),
              );
              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
          const SizedBox(height: 16),
          _buildModalButton(
            context,
            icon: Icons.calendar_today_outlined,
            text: 'Add Appointment',
            onTap: () async {
              Navigator.pop(context); // Close the modal
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddAppointmentScreen()),
              );
              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModalButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Ink(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(
                color: theme.colorScheme.outline.withAlpha(51),
              ),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    text,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: theme.colorScheme.onSurface.withAlpha(77),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}