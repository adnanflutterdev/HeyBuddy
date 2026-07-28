abstract class Conversation {
  final String id;
  final String fUid;
  final DateTime? updatedAt;

  Conversation({
    required this.id,
    required this.fUid,
    this.updatedAt,
  });
}
