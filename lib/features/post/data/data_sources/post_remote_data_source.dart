import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/post/data/models/post_model.dart';
import 'package:hey_buddy/features/post/domain/entity/post.dart';

class PostRemoteDataSource {
  final FirebaseFirestore firestore;

  PostRemoteDataSource(this.firestore);

  Future<void> uploadPost(PostModel post) async {
    await firestore.collection('post').doc(post.id).set(post.toFirebase());
  }

  Stream<List<Post>> getAllPosts() {
    final stream = firestore
        .collection('post')
        .orderBy('timestamps.createdAt', descending: true)
        .snapshots();
    return stream.map(
      (snapshots) => snapshots.docs
          .map((doc) => PostModel.fromFirebase(doc.data()))
          .toList(),
    );
  }

  Future<Post> getPostData(String id) async {
    return await firestore
        .collection('post')
        .doc(id)
        .get()
        .then((data) => PostModel.fromFirebase(data.data() ?? {}));
  }

  Stream<List<String>> getLikeStream(String id) {
    final stream = firestore
        .collection('post')
        .doc(id)
        .collection('likes')
        .snapshots();
    return stream.map(
      (data) => data.docs.map((allDocs) => allDocs.id).toList(),
    );
  }

  Future<void> togglePostLike({
    required String id,
    required String uid,
    required bool isLiked,
  }) async {
    final doc = firestore
        .collection('post')
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
