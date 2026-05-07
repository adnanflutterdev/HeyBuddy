import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/features/chat/presentation/riverpod/providers.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

final usersDataProvider = FutureProvider.family<UserEntity, String>((ref, id) {
  final getUserDataUsecase = ref.read(getUserDataUsecaseProvider);
  return getUserDataUsecase(id);
});
