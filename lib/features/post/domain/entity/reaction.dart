abstract class Reaction {
  final String userId;
  final String reaction;
  final DateTime createAt;
  final DateTime? updatedAt;
  Reaction({
    required this.userId,
    required this.reaction,
    required this.createAt,
    required this.updatedAt,
  });
}
