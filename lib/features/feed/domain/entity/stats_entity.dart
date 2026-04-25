abstract class StatsEntity {
  final int views;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int dislikesCount;
  StatsEntity({
    required this.views,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.dislikesCount,
  });
}
