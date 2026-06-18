import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

abstract class UsersRepository {
  ResultFuture<UserData> getUserData(String id);
  ResultStream<List<UserData>> getAllUsers();
}
