import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget{
  const FavoritesPage({super.key, required this.favoriteContacts});
  final List<Contact> favoriteContacts;
  @override
  State<FavoritesPage> createState() => _FavoritesPageState();

}

class _FavoritesPageState extends State<FavoritesPage> {

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: widget.favoriteContacts.length,
        itemBuilder: (context,index){
        Contact contact=widget.favoriteContacts[index];
        return ListTile(
          title: Text(contact.displayName ?? 'No Name'),
          subtitle: Text(contact.phones?.first.value ?? 'No Phone Number'),
        );
        });
  }

}