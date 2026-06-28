import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hey_buddy/features/profile/data/models/analytics_model.dart';
import 'package:hey_buddy/features/profile/data/models/security_model.dart';
import 'package:hey_buddy/features/profile/data/models/settings_model.dart';
import 'package:hey_buddy/features/profile/data/models/user_data_model.dart';
import 'package:hey_buddy/features/profile/data/models/user_name_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSource(this.auth, this.firestore);

  Future<({UserCredential credential, bool isNewUser})> googleSignin() async {
    await GoogleSignIn.instance.initialize();
    GoogleSignInAccount? googleUser = await GoogleSignIn.instance
        .authenticate();
    OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
      idToken: googleUser.authentication.idToken,
    );

    UserCredential credential = await auth.signInWithCredential(
      oAuthCredential,
    );

    return (
      credential: credential,
      isNewUser: await firestore
          .collection('user')
          .doc(credential.user?.uid)
          .get()
          .then((doc) => !doc.exists),
    );
  }

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
    UserDataModel userDto = UserDataModel.setNewUser(
      uid: uid,
      name: name,
      email: email,
    );

    SettingsModel settings = SettingsModel.setNewUser();
    SecurityModel security = SecurityModel.setNewUser();
    AnalyticsModel analytics = AnalyticsModel.setNewUser();

    DocumentReference ref = firestore.collection('user').doc(uid);
    await ref.set(userDto.toFirebase());

    CollectionReference metaData = ref.collection('config');
    await metaData.doc('settings').set(settings.toFirebase());
    await metaData.doc('security').set(security.toFirebase());
    await metaData.doc('analytics').set(analytics.toFirebase());
  }

  Future<bool> doesUserExists(String username) async {
    final doc = await firestore.collection('username').doc(username).get();
    return doc.exists;
  }

  Future<void> setUsername({
    required UsernameModel user,
    required List<String> searchQueries,
  }) async {
    firestore.collection('username').doc(user.username).set(user.toFirebase());
    DocumentReference ref = firestore.collection('user').doc(user.uid);
    await ref.update({
      'details.username': user.username,
      'searchQueries': searchQueries,
    });
  }
}
