import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';
import 'package:hey_buddy/features/chat/domain/repository/chat_repository.dart';

class GetConversationUsecase extends StreamUsecase<Conversation?, DualIdParam> {
  final ChatRepository repository;

  GetConversationUsecase(this.repository);

  @override
  ResultStream<Conversation?> call(DualIdParam param) {
    return repository.getConversation(param.first, param.second);
  }
}
