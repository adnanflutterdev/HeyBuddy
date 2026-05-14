abstract class ReactionEntity {
  final String userId;
  final String reaction;
  final DateTime createAt;
  final DateTime? updatedAt;
  ReactionEntity({
    required this.userId,
    required this.reaction,
    required this.createAt,
    required this.updatedAt,
  });
}
