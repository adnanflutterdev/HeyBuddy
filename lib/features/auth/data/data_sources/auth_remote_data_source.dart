import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/auth/data/models/analytics.dart';
import 'package:hey_buddy/features/auth/data/models/security.dart';
import 'package:hey_buddy/features/auth/data/models/settings.dart';
import 'package:hey_buddy/features/auth/data/models/user.dart';

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
    UserModel userDto = UserModel.setNewUser(
      uid: uid,
      name: name,
      email: email,
    );

    SettingsModel settings = SettingsModel.setNewUser();
    Security security = Security.setNewUser();
    Analytics analytics = Analytics.setNewUser();

    try {
      await firestore.collection('user').doc(uid).set(userDto.toFirebase());
      await firestore
          .collection('settings')
          .doc(uid)
          .set(settings.toFirebase());
      await firestore
          .collection('security')
          .doc(uid)
          .set(security.toFirebase());
      await firestore
          .collection('analytics')
          .doc(uid)
          .set(analytics.toFirebase());
    } catch (_) {}
  }
}
