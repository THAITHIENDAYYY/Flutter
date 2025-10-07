import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class Contacts {
  static List<String> _contacts = [];
  static bool hasRequestedThisSession = false;

  static Future<bool> requestPermission() async {
    final status = await Permission.contacts.request();
    return status.isGranted;
  }

  static Future<bool> checkPermission() async {
    final status = await Permission.contacts.status;
    return status.isGranted;
  }

  static Future<void> _getContacts() async {
    try {
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
      );
      _contacts = contacts
          .map((contact) => contact.displayName)
          .where((name) => name.isNotEmpty)
          .toList();
    } catch (e) {
      _contacts = [];
    }
  }

  static Future<List<String>> queryContacts(String pattern) async {
    if (_contacts.isEmpty && await checkPermission()) {
      await _getContacts();
    }
    if (_contacts.isNotEmpty && pattern.isNotEmpty) {
      return _contacts
          .where((contact) =>
              contact.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    return [];
  }
}
