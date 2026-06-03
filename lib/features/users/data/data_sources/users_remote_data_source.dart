import 'package:cloud_firestore/cloud_firestore.dart';

class UsersRemoteDataSource {
  final FirebaseFirestore firestore;

  UsersRemoteDataSource(this.firestore);

  Future<Map<String, dynamic>?> getUserData(String id) async {
    final doc = await firestore.collection('user').doc(id).get();
    return doc.data();
  }
}
