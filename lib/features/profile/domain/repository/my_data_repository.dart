import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

abstract class MyDataRepository {
  ResultFuture<UserData> getMyData(String uid);
  ResultFuture updateMyData(String uid, Details details, Profile profile);
}
