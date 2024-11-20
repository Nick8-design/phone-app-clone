import 'dart:io';

import 'package:flutter/foundation.dart';

bool isDesktop(){
  if(kIsWeb){
    return false;
  }
  return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}
bool isWeb() {
  return kIsWeb;
}
