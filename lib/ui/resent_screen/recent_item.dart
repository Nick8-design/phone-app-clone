/*
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/generate_random_color.dart';

class RecentItem extends StatefulWidget {
  const RecentItem({super.key, required this.resent, required this.onTap});

  final CallLogEntry resent;
  final bool onTap;

  @override
  State<RecentItem> createState() => _RecentItemState();
}

class _RecentItemState extends State<RecentItem> {
  bool isExpanded = false; // State variable for expansion

  @override
  Widget build(BuildContext context) {
    String name = widget.resent.name ??
        widget.resent.number ??
        widget.resent.formattedNumber ??
        widget.resent.cachedMatchedNumber ??
        "Unknown Number";
    name = name == '' ? 'Unknown' : name;

    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded; // Toggle expansion
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Smooth animation
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: iconlog(),
              title: Text(
                name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontSize: 16.0),
              ),
              subtitle: subtitle(),
              trailing: IconButton(
                icon: const Icon(Icons.phone_outlined),
                onPressed: () {
                  // Add your onPressed logic here
                },
              ),
            ),
            if (isExpanded)
              Column(
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: longpre(),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget longpre() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.video_camera_front_outlined,
                semanticLabel: 'Video call',
              ),
              onPressed: () {},
            ),
            const Text(
              'Video call',
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.message_outlined,
                semanticLabel: 'Message',
              ),
              onPressed: () {},
            ),
            const Text(
              'Message',
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.history,
                semanticLabel: 'History',
              ),
              onPressed: () {},
            ),
            const Text(
              'History',
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
      ],
    );
  }

  String formatTimestamp(int? timestamp) {
    if (timestamp == null) return "Unknown";
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final formatter = DateFormat('EEE HH:mm'); // Format: Sun 15:23
    return formatter.format(dateTime);
  }

  Widget subtitle() {
    String name = widget.resent.name ??
        widget.resent.number ??
        widget.resent.formattedNumber ??
        widget.resent.cachedMatchedNumber ??
        "Unknown Number";
    name = name == '' ? 'Unknown' : name;

    IconData iconData;
    Color iconColor = Colors.grey;

    switch (widget.resent.callType) {
      case CallType.incoming:
        iconData = Icons.call_received;
        iconColor = Colors.blue;
        break;
      case CallType.outgoing:
        iconData = Icons.call_made;
        iconColor = Colors.green;
        break;
      case CallType.missed:
        iconData = Icons.call_missed;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.call;
        iconColor = Colors.grey;
    }
    String nolabel = widget.resent.cachedNumberLabel ?? 'mobile';
    String calltime = formatTimestamp(widget.resent.timestamp);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              iconData,
              color: iconColor,
              size: 20,
            ),
            Text(
              "$nolabel • $calltime",
              style: TextStyle(
                fontSize: 13,
                color: iconColor,
              ),
            ),
          ],
        ),
        Text(
          widget.resent.simDisplayName ?? "",
        ),
      ],
    );
  }

  Widget iconlog() {
    String name = widget.resent.name ??
        widget.resent.number ??
        widget.resent.formattedNumber ??
        widget.resent.cachedMatchedNumber ??
        "Unknown Number";
    name = name == '' ? 'Unknown' : name;

    if (widget.resent.name == '') {
      return Icon(
        Icons.account_circle_rounded,
        color: getRandomColor(),
        size: 45,
      );
    } else {
      return CircleAvatar(
        backgroundColor: getRandomColor(),
        child: Text(
          widget.resent.name!.substring(0, 1),
          style: const TextStyle(
            fontSize: 19.0,
            color: Colors.white,
          ),
        ),
      );
    }
  }
}


*/
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/generate_random_color.dart';

class RecentItem extends StatefulWidget {
  const RecentItem({super.key, required this.resent, required this.onTap});

  final CallLogEntry resent;
  final bool onTap;


  @override
  State<RecentItem> createState() => _RecentItemstate();

}
class _RecentItemstate extends State<RecentItem>{
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {



    String name = widget.resent.name ??  widget.resent.number ??  widget.resent.formattedNumber ??
        widget.resent.cachedMatchedNumber ?? "Unknown Number";
    name = name == '' ? 'Unknown' : name;


    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final Color? backgroundColor = widget.onTap
        ? Colors.brown[200]
      //  : (isDarkTheme ? Colors.grey[850] : Theme.of(context).colorScheme.surface);
    : Theme.of(context).colorScheme.surface;

    double elevation=0;
     elevation=widget.onTap?4:0;

return Card(
      color: backgroundColor,
      margin: widget.onTap?const EdgeInsets.all(8): const EdgeInsets.all(2)   ,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(

            leading: iconlog(),
            title: Text(
              name
              ,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                  fontSize: 16.0
              ),
            ),
            subtitle: subtitle(),
            trailing: IconButton(
              icon: const Icon(Icons.phone_outlined,),
              onPressed: () {

              },
            ),
          ),

    if (widget.onTap)
       Column(
        children: [
          const Divider(),
          Padding(
          padding: const EdgeInsets.all( 16.0),
          child: longpre(),  ),
        ],
      ),
    ]
      )
        );

  }


  Widget longpre() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
          IconButton(
            icon: const Icon(Icons.video_camera_front_outlined ,
              semanticLabel: 'Video call',
            ),
            onPressed: () {  },

          ),
          const Text('Video call',
            style: TextStyle(
                fontSize: 15
            ),)

        ] ),

    Column(
    mainAxisAlignment:MainAxisAlignment.center,
    children: [
          IconButton(
            icon: const Icon(Icons.message_outlined,
            semanticLabel: 'Message',
            ),
            onPressed: () {  },

          ),
          const Text('Message',
            style: TextStyle(
                fontSize: 15
            ),)

        ] ),
          Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
          IconButton(
            icon: const Icon(Icons.history,
            semanticLabel: 'History',
            ),
            onPressed: () {  },

          ),
           const Text('History',
             style: TextStyle(
               fontSize: 15
             ),)

         ] ),

        ]
    );
  }

  String formatTimestamp(int? timestamp) {
    if (timestamp == null) return "Unknown";
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final formatter = DateFormat('EEE HH:mm'); // Format: Sun 15:23
    return formatter.format(dateTime);
  }

  Widget subtitle() {
    String name = widget.resent.name ?? widget.resent.number ?? widget.resent.formattedNumber ??
        widget.resent.cachedMatchedNumber ?? "Unknown Number";
    name = name == '' ? 'Unknown' : name;

    IconData iconData;
    Color iconColor = Colors.grey;

    switch (widget.resent.callType) {
      case CallType.incoming:
        iconData = Icons.call_received;
        iconColor = Colors.blue;
        break;
      case CallType.outgoing:
        iconData = Icons.call_made;
        iconColor = Colors.green;
        break;
      case CallType.missed:
        iconData = Icons.call_missed;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.call;
        iconColor = Colors.grey;
    }
    String nolabel = widget.resent.cachedNumberLabel ?? 'mobile';
    String calltime = formatTimestamp(widget.resent.timestamp);

    return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
        Row(

          children: [
            Icon(
              iconData,
              color: iconColor,
              size: 20,
            ),
            Text(
              "$nolabel • $calltime",
              style: TextStyle(
                fontSize: 10,
                color: iconColor,

              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),

          ],),
          Text(
              widget.resent.simDisplayName ?? ""
          ),



]
    );

  }


  Widget iconlog() {
    String name = widget.resent.name ?? widget.resent.number ?? widget.resent.formattedNumber ??
        widget.resent.cachedMatchedNumber ?? "Unknown Number";
    name = name == '' ? 'Unknown' : name;


    if (widget.resent.name == '') {
      return Icon(
        Icons.account_circle_rounded,
        color: getRandomColor(),
        size: 45,
      );
    } else {
      return CircleAvatar(
        backgroundColor: getRandomColor(),
        child: Text(widget.resent.name!.substring(0, 1),
          style: const TextStyle(
            fontSize: 19.0,
            color: Colors.white,
          ),

        ),
      );
    }
  }


}



