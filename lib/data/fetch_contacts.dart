import 'package:contacts_service/contacts_service.dart';

Future<List<Contact>> fetchContacts() async {
  Iterable<Contact> contacts = await ContactsService.getContacts();
  return contacts.toList();
}