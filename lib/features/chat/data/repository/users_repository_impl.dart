import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/chat/data/data_sources/users_remote_data_source.dart';
import 'package:hey_buddy/features/chat/domain/repository/users_repository.dart';
import 'package:hey_buddy/features/profile/data/models/user_data_model.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class UsersRepositoryImpl extends UsersRepository {
  final UsersRemoteDataSource remote;
  UsersRepositoryImpl(this.remote);
  @override
  ResultFuture<UserData> getUserData(String id) async {
    final doc = await remote.getUserData(id);
    return Result.success('',data: UserDataModel.fromFirebase(doc ?? {}));
  }
}
