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

  Future<List<String>> getAllPostIds() async {
    final querySnapshot = await firestore.collection('post').get();
    return querySnapshot.docs.map((e) => e.id).toList();
  }

  Future<FeedItemEntity> getPostData(String id) async {
    return await firestore
        .collection('post')
        .doc(id)
        .get()
        .then((data) => FeedItem.fromJson(data.data() ?? {}));
  }
}
