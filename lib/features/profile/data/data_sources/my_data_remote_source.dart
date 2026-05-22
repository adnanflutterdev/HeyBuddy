import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/profile/data/models/user_data_model.dart';

class MyDataRemoteSource {
  final FirebaseFirestore firestore;

  MyDataRemoteSource(this.firestore);

  Future<Map<String, dynamic>?> getMyData(String uid) async {
    final doc = await firestore.collection('user').doc(uid).get();

    return doc.data();
  }

  Future<void> updateMyData(
    String uid,
    DetailsModel details,
    ProfileModel profile,
  ) async {
    await firestore.collection('user').doc(uid).update({
      'details': details.toFirebase(),
      'profile': profile.toFirebase(),
    });
  }
}
