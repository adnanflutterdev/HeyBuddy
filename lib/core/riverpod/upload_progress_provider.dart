import 'package:flutter_riverpod/legacy.dart';

class UploadProgressNotifier extends StateNotifier<double> {
  UploadProgressNotifier() : super(0);

  void updateProgress(double progress) {
    state = double.tryParse(progress.toStringAsFixed(1)) ?? 0.0;
  }
}

final uploadProgressProvider =
    StateNotifierProvider<UploadProgressNotifier, double>(
      (ref) => UploadProgressNotifier(),
    );
