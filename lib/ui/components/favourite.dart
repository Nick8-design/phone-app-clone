import 'package:flutter/material.dart';

class Favourite extends StatefulWidget {
  const Favourite({
    super.key,

  });
  @override
  State<Favourite> createState() =>_FavouriteState();



}


class _FavouriteState extends  State<Favourite> {

  bool fav = false;
  @override
  Widget build(BuildContext context) {

    return IconButton(
      icon: fav
          ? const Icon(Icons.star_outlined)
          :     const Icon(Icons.star_border_outlined),
      onPressed: () {
        setState(() {
          fav=!fav;
        });


      },
    );
  }

}