import 'dart:io';
import 'package:carejournal/services/database_helper.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class BackupService {
  Future<void> backupDatabase(BuildContext context) async {
    final password = await _getPasswordFromUser(context);
    if (password == null || password.isEmpty) return;

    final dbPath = await DatabaseHelper().getDbPath();
    final dbFile = File(dbPath);
    final dbBytes = await dbFile.readAsBytes();

    final key = encrypt.Key.fromUtf8(password.padRight(32, ' ').substring(0, 32));
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encryptBytes(dbBytes, iv: iv);

    final backupFile = XFile.fromData(
      encrypted.bytes,
      name: 'carejournal_backup.enc',
      mimeType: 'application/octet-stream',
    );

    await Share.shareXFiles([backupFile], text: 'CareJournal Backup');
  }

  Future<void> restoreDatabase(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    if (!context.mounted) return;
    final password = await _getPasswordFromUser(context);
    if (password == null || password.isEmpty) return;

    final file = File(result.files.single.path!);
    final encryptedBytes = await file.readAsBytes();

    try {
      final key = encrypt.Key.fromUtf8(password.padRight(32, ' ').substring(0, 32));
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final decrypted = encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);

      final dbPath = await DatabaseHelper().getDbPath();
      await DatabaseHelper().closeDatabase();
      await File(dbPath).writeAsBytes(decrypted);

      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Restore Complete'),
          content: const Text('Please restart the app for the changes to take effect.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to decrypt the backup file. Please check your password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<String?> _getPasswordFromUser(BuildContext context) async {
    final controller = TextEditingController();
    if (!context.mounted) return null;
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Backup Password'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Password'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
