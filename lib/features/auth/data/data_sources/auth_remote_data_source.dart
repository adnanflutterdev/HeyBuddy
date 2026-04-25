import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/profile/data/models/analytics.dart';
import 'package:hey_buddy/features/profile/data/models/security.dart';
import 'package:hey_buddy/features/profile/data/models/settings.dart';
import 'package:hey_buddy/features/profile/data/models/user.dart';

class AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSource(this.auth, this.firestore);

  Future<UserCredential> login(String email, String password) async {
    return await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signup(
    String name,
    String email,
    String password,
  ) async {
    return await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  Future<void> saveUser(String uid, String name, String email) async {
    try {
      UserModel userDto = UserModel.setNewUser(
        uid: uid,
        name: name,
        email: email,
      );

      SettingsModel settings = SettingsModel.setNewUser();
      Security security = Security.setNewUser();
      Analytics analytics = Analytics.setNewUser();

      DocumentReference ref = firestore.collection('user').doc(uid);
      await ref.set(userDto.toFirebase());

      CollectionReference metaData = ref.collection('config');
      await metaData.doc('settings').set(settings.toFirebase());
      await metaData.doc('security').set(security.toFirebase());
      await metaData.doc('analytics').set(analytics.toFirebase());
    } catch (_) {}
  }
}
