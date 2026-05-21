import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/profile/data/models/user__data_model.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class MyDataSource {
  final String uid;
  final FirebaseFirestore firestore;

  MyDataSource(this.uid, this.firestore);

  Future<Map<String, dynamic>?> getMyData() async {
    final doc = await firestore.collection('user').doc(uid).get();

    return doc.data();
  }

  Future<void> updateMyData(DetailsEntity details, ProfileEnity profile) async {
    await firestore.collection('user').doc(uid).update({
      'details': (details as DetailsModel).toFirebase(),
      'profile': (profile as ProfileModel).toFirebase(),
    });
  }
}
