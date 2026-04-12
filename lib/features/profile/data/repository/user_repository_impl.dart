import 'package:firebase_core/firebase_core.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/profile/data/data_sources/user_remote_data_source.dart';
import 'package:hey_buddy/features/profile/data/models/user.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/profile/domain/repository/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource remote;

  UserRepositoryImpl(this.remote);
  @override
  Future<UserEntity> getUserData() async {
    Map<String, dynamic>? doc = await remote.getUserData();

    UserModel user = UserModel.fromFirebase(doc ?? {});

    return user;
  }

  @override
  Future<Result> updateUserData(
    DetailsEntity details,
    ProfileEnity profile,
  ) async {
    try {
      await remote.updateUserData(details, profile);
      return Result.success('Changes saved successfully');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to update changes');
    } catch (e) {
      return Result.failure('Something went wrong!!!');
    }
  }
}
