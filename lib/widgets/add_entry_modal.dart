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
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What would you like to log?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: theme.colorScheme.primary),
            const SizedBox(width: 16),
            Text(
              text,
              style: theme.textTheme.titleLarge,
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}