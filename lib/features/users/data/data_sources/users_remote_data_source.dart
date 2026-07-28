import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/profile/data/models/user_data_model.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class UsersRemoteDataSource {
  final FirebaseFirestore firestore;

  UsersRemoteDataSource(this.firestore);

  Future<UserDataModel?> getUserData(String id) async {
    final doc = await firestore.collection('user').doc(id).get();
    return doc.data() != null ? UserDataModel.fromFirebase(doc.data()!) : null;
  }

  Stream<UserDataModel?> getUserDataStream(String id) {
    final snapshots = firestore.collection('user').doc(id).snapshots();
    return snapshots.map((data) {
      if (data.data() == null) {
        return null;
      }
      return UserDataModel.fromFirebase(data.data()!);
    });
  }

  Future<List<UserData>> searchUsers(String searchQuery) async {
    final query = searchQuery.toLowerCase();
    final snapshots = await firestore
        .collection('user')
        .where('searchQueries', arrayContains: query)
        .get();

    return snapshots.docs
        .map((userData) => UserDataModel.fromFirebase(userData.data()))
        .toList();
  }
}
