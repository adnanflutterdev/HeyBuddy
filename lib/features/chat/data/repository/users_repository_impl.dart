import 'package:hey_buddy/features/chat/data/data_sources/users_remote_data_source.dart';
import 'package:hey_buddy/features/chat/domain/repository/users_repository.dart';
import 'package:hey_buddy/features/profile/data/models/user.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class UsersRepositoryImpl extends UsersRepository {
  final UsersRemoteDataSource remote;
  UsersRepositoryImpl(this.remote);
  @override
  Future<UserEntity> getUserData(String id) async {
    final doc = await remote.getUserData(id);
    return UserModel.fromFirebase(doc ?? {});
  }
}
