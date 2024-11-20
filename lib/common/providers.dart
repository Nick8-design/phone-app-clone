import 'package:clonephone/ui/main_screem/homestate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefProvider = Provider<SharedPreferences>((ref){
  throw UnimplementedError();
});

final bottomNavigationProvider =
    StateNotifierProvider<HomestateProvider,Homestate>((ref){
      return HomestateProvider();
    });