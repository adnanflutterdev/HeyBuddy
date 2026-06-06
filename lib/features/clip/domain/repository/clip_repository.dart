import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/clip/domain/entity/clip.dart';

abstract class ClipRepository {
  ResultFuture<void> uploadClip(Clip clip);
  ResultStream<List<Clip>> getAllClips();
  ResultFuture<Clip> getClipData(String id);
  ResultStream<List<String>> getLikeStream(String id);
  ResultFuture<void> toggleClipLike({
    required String id,
    required String uid,
    required bool isLiked,
  });
  
}
