import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';
import 'package:hey_buddy/features/chat/domain/repository/chat_repository.dart';

class GetLastChatUsecase extends StreamUsecase<Chat?, DualIdParam> {
  final ChatRepository repository;

  GetLastChatUsecase(this.repository);

  @override
  ResultStream<Chat?> call(DualIdParam params) {
    return repository.getLastChat(params.first, params.second);
  }
}
