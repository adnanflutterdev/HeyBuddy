import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/feed/data/models/comment.dart';
import 'package:hey_buddy/features/feed/data/models/feed_item.dart';
import 'package:hey_buddy/features/feed/data/models/reactions.dart';
import 'package:hey_buddy/features/feed/domain/entity/comment_entity.dart';
import 'package:hey_buddy/features/feed/domain/entity/feed_item_entity.dart';
import 'package:hey_buddy/features/feed/domain/entity/reactions_entity.dart';

class FeedRemoteDataSource {
  final FirebaseFirestore firestore;

  FeedRemoteDataSource(this.firestore);

  Future<void> uploadFeedItem(FeedItemEntity feedItem) async {
    await firestore
        .collection(feedItem.content.type.name)
        .doc(feedItem.id)
        .set((feedItem as FeedItem).toFirebase());
  }

  Stream<List<FeedItemEntity>> getAllPosts() {
    final stream = firestore
        .collection('post')
        .orderBy('timestamps.createdAt', descending: true)
        .snapshots();
    return stream.map(
      (snapshots) => snapshots.docs
          .map((doc) => FeedItem.fromFirebase(doc.data()))
          .toList(),
    );
  }

  Future<FeedItemEntity> getPostData(String id) async {
    return await firestore
        .collection('post')
        .doc(id)
        .get()
        .then((data) => FeedItem.fromFirebase(data.data() ?? {}));
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

  Stream<List<CommentEntity>> getComments(String postId) {
    return firestore
        .collection('post')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamps.createdAt')
        .snapshots()
        .map(
          (snaphots) => snaphots.docs
              .map((doc) => Comment.fromFirebase(doc.data()))
              .toList(),
        );
  }

  Future<void> addComment(String postId, CommentEntity comment) async {
    firestore
        .collection('post')
        .doc(postId)
        .collection('comments')
        .doc(comment.id)
        .set((comment as Comment).toFirebase());
  }

  Future<void> addReaction({
    required String postId,
    required String commentId,
    required ReactionEntity reaction,
  }) async {
    firestore
        .collection('post')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('reactions')
        .doc(reaction.userId)
        .set((reaction as Reaction).toFirebase());
  }
}
