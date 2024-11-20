import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

import '../../data/fetch_contacts.dart';
import '../../permissions.dart';

class ContactPage extends StatefulWidget{
   const ContactPage({super.key,
     required this.contacts,
     required this.onFavorite});

   final List<Contact> contacts;
   final Function(Contact) onFavorite;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>{


@override
  Widget build(BuildContext context){
return ListView.builder(
  itemCount: widget.contacts.length,
    itemBuilder: (context,index){
    Contact contact = widget.contacts[index];
    return ListTile(
      title: Text(contact.displayName?? 'Unknown Name'),
      subtitle: Text(contact.phones?.first.value??'No Phone Number'),
      trailing: IconButton(
        icon:const Icon(Icons.star_border),
        onPressed: (){
          widget.onFavorite(contact);
        },
      ),
    );
    }
);
}


}