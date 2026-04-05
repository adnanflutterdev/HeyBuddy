import 'package:flutter_riverpod/legacy.dart';

class ToggleEditNotifier extends StateNotifier<bool> {
  ToggleEditNotifier() : super(false);

  void toggleEdit() {
    state = !state;
  }
}

final toggleEditProvider = StateNotifierProvider<ToggleEditNotifier, bool>(
  (ref) => ToggleEditNotifier(),
);
