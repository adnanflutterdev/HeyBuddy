import 'package:flutter_riverpod/legacy.dart';

class TabNotifier extends StateNotifier<int> {
  TabNotifier() : super(0);

  void changeTab(int i) {
    state = i;
  }
}

final tabProvider = StateNotifierProvider<TabNotifier, int>(
  (ref) => TabNotifier(),
);
