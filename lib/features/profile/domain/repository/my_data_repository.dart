import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

abstract class MyDataRepository {
  Future<UserEntity> getMyData();
  Future<Result> updateMyData(DetailsEntity details, ProfileEnity profile);
}
