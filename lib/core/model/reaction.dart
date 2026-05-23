import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Reaction {
  final String userId;
  final DateTime createAt;
  final DateTime? updatedAt;
  final String reactionName;
  final String reactionEmoji;
  Reaction({
    required this.userId,
    required this.createAt,
    required this.updatedAt,
    required this.reactionName,
    required this.reactionEmoji,
  });
}

class ReactionModel extends Reaction {
  ReactionModel({
    super.updatedAt,
    required super.userId,
    required super.createAt,
    required super.reactionName,
    required super.reactionEmoji,
  });

  factory ReactionModel.fromEntity(Reaction reaction) {
    return ReactionModel(
      userId: reaction.userId,
      createAt: reaction.createAt,
      updatedAt: reaction.updatedAt,
      reactionName: reaction.reactionName,
      reactionEmoji: reaction.reactionEmoji,
    );
  }

  factory ReactionModel.fromFirebase(Map<String, dynamic> json) {
    return ReactionModel(
      userId: json['userId'],
      reactionEmoji: json['reactionEmoji'],
      reactionName: json['reactionName'],
      createAt: (json['createAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'userId': userId,
      'reactionEmoji': reactionEmoji,
      'reactionName': reactionName,
      'createAt': Timestamp.fromDate(createAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
