import 'package:clonephone/common/sizebox.dart';
import 'package:clonephone/ui/components/edit_pen.dart';
import 'package:clonephone/ui/components/favourite.dart';
import 'package:clonephone/ui/components/set_user.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:flutter/material.dart';


import '../../common/generate_random_color.dart';

class ContactInfo extends StatefulWidget{
  const ContactInfo({super.key, required this.contact});
final Contact contact;


  @override
  State<ContactInfo> createState() =>_ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(

      actions: const [
        EditPen(),
        Favourite(),
        SetUser()
      ],
      pinned: true,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 64.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                sizedH16,
                icon_img(), //
                sizedH16,
                Text(
                  widget.contact.displayName ?? 'Unknown Name',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 24.0
                  ),
                ),
                sizedH16,
                action_title(),
                sizedH8,

              ],

            ),
          ),
        ),
      ),
    );
  }


  Widget action_title() {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {

                },
                icon: const Icon(Icons.call_outlined),
                color: Colors.blueAccent,
              ),
              const Text('Call',
                  style: TextStyle(
                      fontSize: 15
                  )),
            ],
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {

                },
                icon: const Icon(Icons.message_outlined),
                color: Colors.blueAccent,
              ),
              const Text('Text',
                  style: TextStyle(
                      fontSize: 15
                  )),
            ],
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {

                },
                icon: const Icon(Icons.video_camera_front_outlined),
                color: Colors.blueAccent,
              ),
              const Text('Video',
                  style: TextStyle(
                      fontSize: 15
                  )),
            ],
          ),
        ],
      ),
    );
  }


  Widget icon_img() {
    return (widget.contact.avatar != null && widget.contact.avatar!.isNotEmpty)
        ? CircleAvatar(
      radius: 50,
      backgroundImage: MemoryImage(widget.contact.avatar!),
    )
        : CircleAvatar(
      backgroundColor: getRandomColor(),
      radius: 50,
      // backgroundColor: Colors.yellow,
      child: Text(widget.contact.displayName?.substring(0, 1) ?? '?',
        style: const TextStyle(
          fontSize: 33.0,
          color: Colors.white,
        ),

      ),
    );
  }


  Sliver _buildInfoSection() {
    return SliverToBoxAdapter(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contact info', style: Theme
                  .of(context)
                  .textTheme
                  .titleSmall),
              sizedH16,
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.phone_outlined),
                  onPressed: () {},
                ),
                title: Text(
                  widget.contact.androidAccountName ?? '07',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium,
                ),
                subtitle: Text(
                  widget.contact.givenName ?? 'Mobile',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.video_camera_front_outlined),
                    ),
                    sizedW8,
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.message_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Sliver _buildContactSettings() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact settings'),
            sizedH8,
            ListTile(
              leading: Icon(Icons.sim_card_outlined),
              title: Text('Set calling SIM'),
            ),
            sizedH8,
            ListTile(
              leading: Icon(Icons.queue_music),
              title: Text('Contact ringtone'),
              subtitle: Text('Default ringtone'),
            ),
            sizedH8,
            ListTile(
              leading: Icon(Icons.table_view_sharp),
              title: Text('Reminder'),
            ),
          ],
        ),
      ),
    );
  }

  Sliver contactsett() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            const ListTile(
              leading: Icon(Icons.share_outlined),
              title: Text('Share contact'),
            ),
            sizedH8,
            const ListTile(
              leading: Icon(Icons.apps),
              title: Text('Add to home screen'),
            ),
            sizedH8,
            const ListTile(
              leading: Icon(Icons.read_more),
              title: Text('Move to another account'),
            ),

            sizedH8,
            ListTile(
              leading: const Icon(Icons.voicemail),
              title: const Text('Send to voicemail'),
              trailing: buildVoicemail(),
            ),
            sizedH8,
            const ListTile(
              leading: Icon(Icons.block_flipped),
              title: Text('Block numbers'),
              textColor: Colors.redAccent,
              iconColor: Colors.redAccent,
            ),


            const ListTile(
              leading: Icon(Icons.delete_forever_outlined),
              title: Text('Delete'),
              textColor: Colors.redAccent,
              iconColor: Colors.redAccent,
            ),


          ],
        ),
      ),
    );
  }


  bool isVoicemailEnabled = false;


  Widget buildVoicemail() {
    return Switch(
      value: isVoicemailEnabled,
      onChanged: (value) {
        setState(() {
          isVoicemailEnabled = value;
        });
      },
      activeColor: Colors.pink,

    );
  }

  Sliver infofrom(BuildContext context, Contact contact) {
    return SliverToBoxAdapter(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Contact info from',
                style: Theme
                    .of(context)
                    .textTheme
                    .titleSmall,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  // Account photo, SIM icon, or Phone icon
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    radius: 24,
                    child: _getAccountIcon(contact),
                  ),
                  const SizedBox(width: 8),
                  // Account source (e.g., SIM, Phone, or Email source)
                  Text(
                    _getAccountSource(contact),
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Determines the icon or profile photo to display
  Widget _getAccountIcon(Contact contact) {
    if (contact.avatar != null && contact.avatar!.isNotEmpty) {
      // Use avatar image if available
      return CircleAvatar(
        radius: 24,
        backgroundImage: MemoryImage(contact.avatar!),
      );
    } else if (contact.androidAccountType == 'com.android.localphone') {
      // Show phone icon for local contacts
      return const Icon(
        Icons.phone_android,
        size: 24,
        color: Colors.grey,
      );
    } else if (contact.androidAccountType == 'com.android.sim') {
      // Show SIM icon for SIM contacts
      return const Icon(
        Icons.sim_card,
        size: 24,
        color: Colors.blue,
      );
    } else {
      // Default account icon (e.g., Google or others)
      return const Icon(
        Icons.account_circle,
        size: 24,
        color: Colors.grey,
      );
    }
  }

  /// Determines the source text to display (e.g., Phone, SIM, or Email)
  String _getAccountSource(Contact contact) {
    if (contact.androidAccountType == 'com.android.localphone') {
      return 'From Phone';
    } else if (contact.androidAccountType == 'com.android.sim') {
      return 'From SIM';
    } else {
      return contact.androidAccountName ?? 'Unknown Account';
    }
  }


  Sliver line() => const SliverToBoxAdapter(child: Divider(),);

  Sliver help() {
    return const SliverToBoxAdapter(
      child: Center( // Centers the entire content
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 64),

          // Centers items within the Column
          child:
            ListTile(
              title: Text('Help & feedback'),
            ),

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          _buildInfoSection(),
          line(),
          _buildContactSettings(),
          line(),
          contactsett(),
          line(),
          infofrom(context, widget.contact),
          help(),

        ],
      ),
    );
  }
}
