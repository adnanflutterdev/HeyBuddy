import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';
import 'package:hey_buddy/features/chat/domain/repository/chat_repository.dart';

class GetConversationsUsecase extends StreamUsecase<List<Conversation?>, IdParam> {
  final ChatRepository repository;

  GetConversationsUsecase(this.repository);

  @override
  ResultStream<List<Conversation?>> call(IdParam param) {
    return repository.getConversation(param.id);
  }
}
