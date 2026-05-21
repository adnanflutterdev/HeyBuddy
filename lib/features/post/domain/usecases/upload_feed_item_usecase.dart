import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/post/domain/entity/post.dart';
import 'package:hey_buddy/features/post/domain/repository/post_repository.dart';

class UploadFeedItemUsecase {
  final PostRepository repository;

  UploadFeedItemUsecase(this.repository);

  Future<Result> call(Post feedItem) {
    return repository.uploadPost(feedItem);
  }
}
