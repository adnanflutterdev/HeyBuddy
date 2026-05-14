import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/feed/domain/entity/reactions_entity.dart';

class Reaction extends ReactionEntity {
  Reaction({
    required super.userId,
    required super.reaction,
    required super.createAt,
    required super.updatedAt,
  });

  factory Reaction.fromFirebase(Map<String, dynamic> json) {
    return Reaction(
      userId: json['userId'],
      reaction: json['reaction'],
      createAt: (json['createAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'userId': userId,
      'reaction': reaction,
      'createAt': Timestamp.fromDate(createAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
