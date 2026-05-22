import 'package:hey_buddy/core/typedefs/typedefs.dart';

abstract class FutureUsecase<T, Params> {
  ResultFuture<T> call(Params params);
}

abstract class StreamUsecase<T, Params> {
  ResultStream<T> call(Params params);
}

class NoParams {}

class IdParam {
  final String id;

  IdParam(this.id);
}
