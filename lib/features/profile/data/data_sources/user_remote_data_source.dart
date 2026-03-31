import 'package:cloud_firestore/cloud_firestore.dart';

class UserRemoteDataSource {
  final String uid;
  final FirebaseFirestore firestore;

  UserRemoteDataSource(this.uid, this.firestore);

  Future<Map<String, dynamic>?> getUserData() async {
    final doc = await firestore.collection('user').doc(uid).get();

    return doc.data();
  }
}
