import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/clip/data/models/clip_model.dart';
import 'package:hey_buddy/features/clip/domain/entity/clip.dart';

class ClipRemoteDataSource {
  final FirebaseFirestore firestore;

  ClipRemoteDataSource(this.firestore);

  Future<void> uploadClip(ClipModel clip) async {
    await firestore.collection('clip').doc(clip.id).set(clip.toFirebase());
  }

  Stream<List<Clip>> getAllClips() {
    final stream = firestore
        .collection('clip')
        .orderBy('timestamps.createdAt', descending: true)
        .snapshots();
    return stream.map(
      (snapshots) => snapshots.docs
          .map((doc) => ClipModel.fromFirebase(doc.data()))
          .toList(),
    );
  }

  Future<Clip> getClipData(String id) async {
    return await firestore
        .collection('clip')
        .doc(id)
        .get()
        .then((data) => ClipModel.fromFirebase(data.data() ?? {}));
  }

  Stream<List<String>> getLikeStream(String id) {
    final stream = firestore
        .collection('clip')
        .doc(id)
        .collection('likes')
        .snapshots();
    return stream.map(
      (data) => data.docs.map((allDocs) => allDocs.id).toList(),
    );
  }

  Future<void> toggleClipLike({
    required String id,
    required String uid,
    required bool isLiked,
  }) async {
    final doc = firestore
        .collection('clip')
        .doc(id)
        .collection('likes')
        .doc(uid);
    if (isLiked) {
      await doc.delete();
    } else {
      await doc.set({});
    }
  }
}
