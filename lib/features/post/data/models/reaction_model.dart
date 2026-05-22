import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/post/domain/entity/reaction.dart';

class ReactionModel extends Reaction {
  ReactionModel({
    required super.userId,
    required super.reaction,
    required super.createAt,
    super.updatedAt,
  });

  factory ReactionModel.fromEntity(Reaction reaction) {
    return ReactionModel(
      userId: reaction.userId,
      reaction: reaction.reaction,
      createAt: reaction.createAt,
      updatedAt: reaction.updatedAt,
    );
  }

  factory ReactionModel.fromFirebase(Map<String, dynamic> json) {
    return ReactionModel(
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
