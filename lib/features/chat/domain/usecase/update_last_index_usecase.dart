import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/chat/domain/repository/chat_repository.dart';

class UpdateLastIndexUsecase
    extends FutureUsecase<void, UpdateLastIndexUsecaseParams> {
  final ChatRepository repository;
  UpdateLastIndexUsecase(this.repository);

  @override
  ResultFuture<void> call(UpdateLastIndexUsecaseParams params) {
    return repository.updateLastIndex(
      uid: params.uid,
      chatDocId: params.chatDocId,
      newIndex: params.newIndex,
    );
  }
}

class UpdateLastIndexUsecaseParams {
  final String uid;
  final String chatDocId;
  final int newIndex;

  UpdateLastIndexUsecaseParams({
    required this.uid,
    required this.chatDocId,
    required this.newIndex,
  });
}
