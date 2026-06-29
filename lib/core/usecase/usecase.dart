import 'package:cloud_firestore/cloud_firestore.dart';
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

class DualIdParam {
  final String first;
  final String second;

  DualIdParam({required this.first, required this.second});
}

class DocumentReferenceParam {
  final DocumentReference ref;

  DocumentReferenceParam(this.ref);
}

class CollectionReferenceParam {
  final CollectionReference ref;

  CollectionReferenceParam(this.ref);
}
