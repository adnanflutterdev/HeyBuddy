import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/users/data/data_sources/users_remote_data_source.dart';
import 'package:hey_buddy/features/users/domain/repository/users_repository.dart';

class UsersRepositoryImpl extends UsersRepository {
  final UsersRemoteDataSource remote;
  UsersRepositoryImpl(this.remote);

  @override
  ResultFuture<UserData?> getUserData(String id) async {
    try {
      UserData? data = await remote.getUserData(id);
      return Result.success('', data: data);
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to fetch user data');
    } catch (e) {
      return Result.failure('Failed to fetch user data');
    }
  }

  @override
  ResultStream<UserData?> getUserDataStream(String id) {
    try {
      return remote.getUserDataStream(id);
    } on FirebaseException catch (e) {
      return Stream.error(e.message ?? 'Failed to fetch user data');
    } catch (e) {
      return Stream.error('Failed to fetch user data');
    }
  }

  @override
  ResultFuture<List<UserData>> searchUsers(String searchQuery) async {
    try {
      return Result.success('', data: await remote.searchUsers(searchQuery));
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to fetch users');
    } catch (e) {
      return Result.failure('Failed to fetch user data');
    }
  }
}
