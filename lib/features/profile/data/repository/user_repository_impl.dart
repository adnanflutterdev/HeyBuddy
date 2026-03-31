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
}
