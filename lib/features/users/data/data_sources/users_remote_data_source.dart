import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/profile/data/models/user_data_model.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class UsersRemoteDataSource {
  final FirebaseFirestore firestore;

  UsersRemoteDataSource(this.firestore);

  Future<Map<String, dynamic>?> getUserData(String id) async {
    final doc = await firestore.collection('user').doc(id).get();
    return doc.data();
  }

  Stream<List<UserData>> getAllUsers() {
    final snapshots = firestore.collection('user').orderBy('details.name').snapshots();

    return snapshots.map(
      (data) => data.docs
          .map((userData) => UserDataModel.fromFirebase(userData.data()))
          .toList(),
    );
  }
}
