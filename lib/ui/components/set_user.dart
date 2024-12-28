import 'package:flutter/material.dart';

class SetUser extends StatefulWidget {
  const SetUser({
    super.key,

  });
  @override
  State<SetUser> createState() =>_FavouriteState();



}


class _FavouriteState extends  State<SetUser> {

  bool fav = false;
  @override
  Widget build(BuildContext context) {

    return IconButton(
      icon: fav
          ?  const Icon(Icons.manage_accounts)

          :  const Icon(Icons.manage_accounts_outlined),
      onPressed: () {
        setState(() {
          fav=!fav;
        });


      },
    );
  }

}