import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/providers.dart';

final myDataProvider = FutureProvider((ref) async {
  final getMyDatausecase = ref.read(getMyDataUsecaseProvider);
  return await getMyDatausecase();
});
