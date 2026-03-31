import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/providers.dart';

final userProvider = FutureProvider((ref) async {
  final userDatausecase = ref.read(userDataUsecaseProvider);

  return await userDatausecase();
});
