import 'dart:math';

import 'package:flutter/material.dart';

Color getRandomColor(){
  final Random random =Random();
  //final Random random =Random(identifier.hashCode);
  return Color.fromARGB(
    238,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}