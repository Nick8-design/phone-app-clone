
import 'package:clonephone/common/generate_random_color.dart';
import 'package:clonephone/common/sizebox.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class ContactItem extends StatelessWidget {
  final Contact contact;

  const ContactItem({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    /* return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20.0,
          child: contactpic(),
        ),
        sizedW16,
        Text(
          contact.displayName ?? 'Unknown Name',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
              fontSize: 16.0
          ),
        ),


      ],
    );
  }*/

    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        //  color: Colors.grey[850],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child:   ListTile(
          leading: (contact.avatar != null && contact.avatar!.isNotEmpty)
              ? CircleAvatar(
            backgroundImage: MemoryImage(contact.avatar!),
          )
              : CircleAvatar(
            backgroundColor: getRandomColor(),
            // backgroundColor: Colors.yellow,
            child: Text(contact.displayName?.substring(0, 1) ?? '?',
              style: const TextStyle(
                fontSize: 19.0,
                color: Colors.white,
              ),

            ),
          ),
          title: Text(
            contact.displayName ?? 'Unknown Name',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
                fontSize: 16.0
            ),
          ),
        ),



    );


  }

}

SliverToBoxAdapter contactadd() {

  return const SliverToBoxAdapter(
    child: Padding(
        padding: EdgeInsets.only(left: 64),
      child:
      ListTile(
        leading: Icon(
            Icons.person_add_alt
        ),
        title: Text(
          'Create new account',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style:  TextStyle(
              fontSize: 16.0
          ),
        ),
      ),
    ),
  );

}


/*
Widget contactsitem(Contact contact ){

  return ListTile(
    title: Text(contact.displayName?? 'Unknown Name'),
    subtitle: Text(contact.phones?.first.value??'No Phone Number'),
    trailing: IconButton(
      icon:const Icon(Icons.star_border),
      onPressed: (){
        onFavorite(contact);
      },
    ),
  );
}

 */