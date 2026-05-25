import 'package:hey_buddy/core/feature/comment/domain/repository/comment_repository.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/core/model/reaction.dart';

class GetReactionUsecase
    extends StreamUsecase<List<Reaction>, CollectionReferenceParam> {
  final CommentRepository repository;

  GetReactionUsecase(this.repository);
  @override
  ResultStream<List<Reaction>> call(CollectionReferenceParam params) {
    return repository.getReactions(params.ref);
  }
}
