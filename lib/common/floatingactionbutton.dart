
import 'package:clonephone/common/phndial.dart';
import 'package:flutter/material.dart';

Widget  buildFloatingActionButton(BuildContext context) {
  return SizedBox(
    width: 58,
    height: 58,
    child:   FloatingActionButton.small(
      onPressed:(){
        showBottomSheet(context);
      },
        elevation: 16.0,
      child:  const Padding(
          padding: EdgeInsets.all(0),
      child: Icon(
        Icons.dialpad,
      ),
      )



    ),
  );




}

Future<void> showBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    isDismissible: true,
    enableDrag: true,
    isScrollControlled: false,
    context: context,
    constraints: const BoxConstraints(maxWidth: 480),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // Sharp corners
    ),
    builder: (context) => const DialPadScreen(),
  );
}


