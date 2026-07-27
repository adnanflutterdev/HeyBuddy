import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/chat/domain/entity/online_status.dart';
import 'package:hey_buddy/features/chat/domain/repository/chat_repository.dart';

class UpdateOnlineStatusUsecase
    extends FutureUsecase<void, UpdateOnlineStatusUsecaseParams> {
  final ChatRepository repository;
  UpdateOnlineStatusUsecase(this.repository);

  @override
  ResultFuture<void> call(UpdateOnlineStatusUsecaseParams params) {
    return repository.updateOnlineStatus(
      fUid: params.fUid,
      chatDocId: params.chatDocId,
      onlineStatus: params.onlineStatus,
    );
  }
}

class UpdateOnlineStatusUsecaseParams {
  final String fUid;
  final String chatDocId;
  final OnlineStatus onlineStatus;

  UpdateOnlineStatusUsecaseParams({
    required this.fUid,
    required this.chatDocId,
    required this.onlineStatus,
  });
}
