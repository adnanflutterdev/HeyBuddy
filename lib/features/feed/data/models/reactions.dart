import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/feed/domain/entity/reactions_entity.dart';

class Reactions extends ReactionsEntity {
  Reactions({required super.reactions});

  factory Reactions.fromJson(Map<String, dynamic>? json) {
    if (json == null || json['reactions'] == null) {
      return Reactions(reactions: []);
    }

    var list = (json['reactions'] as List)
        .map((e) => Reaction.fromJson(e as Map<String, dynamic>))
        .toList();

    return Reactions(reactions: list);
  }

  Map<String, dynamic> toJson() {
    return {
      'reactions': reactions
          .map((reaction) => (reaction as Reaction).toJson())
          .toList(),
    };
  }
}

class Reaction extends ReactionEntity {
  Reaction({
    required super.userRef,
    required super.type,
    required super.reactedAt,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      userRef: json['userRef'],
      type: json['type'] ?? '',
      reactedAt: json['reactedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'userRef': userRef, 'type': type, 'reactedAt': reactedAt};
  }
}
