import 'package:call_log/call_log.dart';

Future<List<CallLogEntry>> fetchCallLogs() async {


  Iterable<CallLogEntry> callLogs = await CallLog.get();
  return callLogs.toList();
}

/*

// Extend Contact for custom serialization
extension ContactExtensions on Contact {
  Map<String, dynamic> toCustomMap() {
    return {
      'displayName': displayName,
      'phones': phones?.map((phone) => phone.value).toList(),
      'emails': emails?.map((email) => email.value).toList(),
      'avatar': avatar?.toList(), // Convert Uint8List to List<int>
    };
  }

  static Contact fromCustomMap(Map<String, dynamic> map) {
    return Contact(
      displayName: map['displayName'],
      phones: (map['phones'] as List<dynamic>?)
          ?.map((phone) => Item(value: phone as String))
          .toList(),
      emails: (map['emails'] as List<dynamic>?)
          ?.map((email) => Item(value: email as String))
          .toList(),
      avatar: map['avatar'] != null
          ? Uint8List.fromList(List<int>.from(map['avatar']))
          : null, // Convert List<int> back to Uint8List
    );
  }
}

// Save contacts to SharedPreferences
Future<void> saveContactsToPreferences(List<Contact> contacts) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<Map<String, dynamic>> contactsJson =
  contacts.map((contact) => contact.toCustomMap()).toList();
  await prefs.setString('contacts', json.encode(contactsJson));
}

// Load contacts from SharedPreferences
Future<List<Contact>> loadContactsFromPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedContactsJson = prefs.getString('contacts');

  if (storedContactsJson != null) {
    List<dynamic> jsonList = json.decode(storedContactsJson);

    // Convert each dynamic item to Contact
    List<Contact> storedContacts = jsonList
        .map((jsonItem) => ContactExtensions.fromCustomMap(
        jsonItem as Map<String, dynamic>))
        .toList();

    return storedContacts;
  }
  return []; // Return empty list if no data is stored
}

// Fetch contacts and update if necessary
Future<List<Contact>> fetchContacts() async {
  List<Contact> storedContacts = await loadContactsFromPreferences();

  if (storedContacts.isNotEmpty) {
    return storedContacts; // Use cached contacts if available
  }

  // If no cached contacts, fetch from device
  final deviceContacts = await _fetchAndUpdateContacts([]);
  return deviceContacts;
}

Future<List<Contact>> _fetchAndUpdateContacts(
    List<Contact> storedContacts) async {
  try {
    final permissionStatus = await Permission.contacts.request();
    if (!permissionStatus.isGranted) {
      Fluttertoast.showToast(
        msg: "Permission to access contacts denied!",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return storedContacts; // Use stored contacts if permission is denied
    }

    final result = await ContactsService.getContacts();
    List<Contact> newContacts = result.toList();

    if (_contactsChanged(storedContacts, newContacts)) {
      await saveContactsToPreferences(newContacts);

      int difference = (newContacts.length - storedContacts.length).abs();
      String changeType =
      newContacts.length > storedContacts.length ? 'added' : 'removed';

      Fluttertoast.showToast(
        msg: "$difference contact(s) $changeType.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return newContacts;
    }

    return storedContacts; // No changes, use stored contacts
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Error fetching contacts: $e",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    return storedContacts; // Use stored contacts on error
  }
}

// Check if contacts have changed
bool _contactsChanged(List<Contact> oldContacts, List<Contact> newContacts) {
  if (oldContacts.length != newContacts.length) return true;

  for (int i = 0; i < oldContacts.length; i++) {
    if (oldContacts[i].displayName != newContacts[i].displayName) {
      return true;
    }
  }
  return false;
}
 */