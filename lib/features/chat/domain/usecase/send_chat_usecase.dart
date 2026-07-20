import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';
import 'package:hey_buddy/features/chat/domain/repository/chat_repository.dart';

class SendChatUsecase extends FutureUsecase<void, SendChatParams> {
  final ChatRepository repository;

  SendChatUsecase(this.repository);

  @override
  ResultFuture<void> call(SendChatParams param) async {
    return await repository.sendChat(
      myUid: param.myUid,
      fUid: param.fUid,
      chatsDocId: param.chatsDocId,
      chat: param.chat,
    );
  }
}

class SendChatParams {
  final String myUid;
  final String fUid;
  final String chatsDocId;
  final Chat chat;

  SendChatParams({
    required this.myUid,
    required this.fUid,
    required this.chatsDocId,
    required this.chat,
  });
}
