import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';
import 'package:hey_buddy/features/chat/domain/repository/chat_repository.dart';

class GetChatsUsecase extends StreamUsecase<List<Chat>, DualIdParam> {
  final ChatRepository repository;

  GetChatsUsecase(this.repository);

  @override
  ResultStream<List<Chat>> call(DualIdParam params) {
    return repository.getChats(params.first, params.second);
  }
}
