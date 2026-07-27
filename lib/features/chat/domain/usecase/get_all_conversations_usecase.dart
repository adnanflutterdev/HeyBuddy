import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';
import 'package:hey_buddy/features/chat/domain/repository/chat_repository.dart';

class GetAllConversationsUsecase extends StreamUsecase<List<Conversation?>, IdParam> {
  final ChatRepository repository;

  GetAllConversationsUsecase(this.repository);

  @override
  ResultStream<List<Conversation?>> call(IdParam param) {
    return repository.getAllConversations(param.id);
  }
}
