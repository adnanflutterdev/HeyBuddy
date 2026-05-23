import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/profile/domain/usecases/get_my_data_usecase.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/providers.dart';

final myDataProvider = FutureProvider<UserData>((ref) async {
  final getMyDatausecase = ref.read(getMyDataUsecaseProvider);
  final authState = ref.watch(authStateProvider);
  final uid = authState.value?.uid ?? '';
  final result = await getMyDatausecase(GetMyDataParams(uid));
  return result.data ?? Future.error(result.message);
});
