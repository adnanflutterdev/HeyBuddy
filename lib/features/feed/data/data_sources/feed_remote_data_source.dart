import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/feed/data/models/feed_item.dart';
import 'package:hey_buddy/features/feed/domain/entity/feed_item_entity.dart';

class FeedRemoteDataSource {
  final FirebaseFirestore firestore;

  FeedRemoteDataSource(this.firestore);

  Future<void> uploadFeedItem(FeedItemEntity feedItem) async {
    await firestore
        .collection(feedItem.content.type.name)
        .doc(feedItem.id)
        .set((feedItem as FeedItem).toJson());
  }

  Stream<List<FeedItemEntity>> getAllPosts() {
    final stream = firestore
        .collection('post')
        .orderBy('timestamps.createdAt', descending: true)
        .snapshots();
    return stream.map(
      (snapshots) =>
          snapshots.docs.map((doc) => FeedItem.fromJson(doc.data())).toList(),
    );
  }

  Future<FeedItemEntity> getPostData(String id) async {
    return await firestore
        .collection('post')
        .doc(id)
        .get()
        .then((data) => FeedItem.fromJson(data.data() ?? {}));
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
    if (isLiked) {
      await firestore
          .collection('post')
          .doc(id)
          .collection('likes')
          .doc(uid)
          .delete();
    } else {
      await firestore
          .collection('post')
          .doc(id)
          .collection('likes')
          .doc(uid)
          .set({});
    }
  }
}
