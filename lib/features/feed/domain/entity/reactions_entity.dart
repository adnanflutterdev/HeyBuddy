import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ReactionsEntity {
  final List<ReactionEntity> reactions;

  ReactionsEntity({required this.reactions});
}

abstract class ReactionEntity {
  final String userRef;
  final String type;
  final Timestamp reactedAt;
  ReactionEntity({
    required this.userRef,
    required this.type,
    required this.reactedAt,
  });
}
