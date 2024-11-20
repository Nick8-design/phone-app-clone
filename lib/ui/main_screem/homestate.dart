import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'homestate.freezed.dart';

@freezed
class Homestate with _$Homestate{
  const factory Homestate({
    @Default(1) int selectedIndex,
})=_Homestate;
}

class HomestateProvider extends StateNotifier<Homestate> {
  HomestateProvider() :super(const Homestate());

  void updateSelectedIndex(int index) {
    state = Homestate(selectedIndex: index);
  }
}