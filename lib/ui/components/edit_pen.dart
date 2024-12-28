

import 'package:flutter/material.dart';

class EditPen extends StatelessWidget {
  const EditPen({
    super.key,
 //   required this.changeThemeMode,
  });

 // final Function changeThemeMode;

  @override
  Widget build(BuildContext context) {
  //  final isBright = Theme.of(context).brightness == Brightness.light;
    return IconButton(
      icon:  const Icon(Icons.edit_outlined),
      onPressed: () =>{}
      ,
    );
  }
}
