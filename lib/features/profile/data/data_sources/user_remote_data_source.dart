import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/profile/data/models/user.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class UserRemoteDataSource {
  final String uid;
  final FirebaseFirestore firestore;

  UserRemoteDataSource(this.uid, this.firestore);

  Future<Map<String, dynamic>?> getUserData() async {
    final doc = await firestore.collection('user').doc(uid).get();

    return doc.data();
  }

  Future<void> updateUserData(
    DetailsEntity details,
    ProfileEnity profile,
  ) async {
    await firestore.collection('user').doc(uid).update({
      'details': (details as Details).toFirebase(),
      'profile': (profile as Profile).toFirebase(),
    });
  }
}
