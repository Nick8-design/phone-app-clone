import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
Future<void> per_phone() async{
 await Permission.phone.request();

}

Future<void> per_contact() async {
 await Permission.contacts.request();
}
/*
var phonestatus =  await Permission.phone.request();
 var status = await Permission.contacts.request();

 if (phonestatus.isPermanentlyDenied) {
  Fluttertoast.showToast(msg: 'Turn on Phone permission in order to use the app',toastLength: Toast.LENGTH_LONG);
 openAppSettings();
 }
 if (status.isPermanentlyDenied) {
  Fluttertoast.showToast(msg: 'Turn on Phone permission in order to use the app',toastLength: Toast.LENGTH_LONG);
  openAppSettings();
 }
*/


/*
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactPermissionExample extends StatefulWidget {
  @override
  _ContactPermissionExampleState createState() => _ContactPermissionExampleState();
}

class _ContactPermissionExampleState extends State<ContactPermissionExample> {
  bool _hasPermission = false;
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
    // Check permission status
    var status = await Permission.contacts.status;

    if (status.isGranted) {
      // Permission is already granted
      setState(() {
        _hasPermission = true;
      });
      _loadContacts();
    } else if (status.isDenied) {
      // Request permission
      if (await Permission.contacts.request().isGranted) {
        setState(() {
          _hasPermission = true;
        });
        _loadContacts();
      } else {
        // Handle permission denied
        setState(() {
          _hasPermission = false;
        });
      }
    } else if (status.isPermanentlyDenied) {
      // Open app settings to manually enable permissions
      openAppSettings();
    }
  }

  Future<void> _loadContacts() async {
    try {
      List<Contact> contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts;
      });
    } catch (e) {
      print("Error loading contacts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contacts Permission Example")),
      body: _hasPermission
          ? ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                Contact contact = _contacts[index];
                return ListTile(
                  title: Text(contact.displayName ?? 'No Name'),
                );
              },
            )
          : Center(
              child: ElevatedButton(
                onPressed: _checkAndRequestPermission,
                child: const Text("Grant Contacts Permission"),
              ),
            ),
    );
  }
}

 */