import 'package:firebase_core/firebase_core.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/profile/data/data_sources/my_data_source.dart';
import 'package:hey_buddy/features/profile/data/models/user.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/profile/domain/repository/my_data_repository.dart';

class MyDataRepositoryImpl extends MyDataRepository {
  final MyDataSource remote;

  MyDataRepositoryImpl(this.remote);
  @override
  Future<UserEntity> getMyData() async {
    Map<String, dynamic>? doc = await remote.getMyData();

    UserModel user = UserModel.fromFirebase(doc ?? {});

    return user;
  }

  @override
  Future<Result> updateMyData(
    DetailsEntity details,
    ProfileEnity profile,
  ) async {
    try {
      await remote.updateMyData(details, profile);
      return Result.success('Changes saved successfully');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to update changes');
    } catch (e) {
      return Result.failure('Something went wrong!!!');
    }
  }
}
