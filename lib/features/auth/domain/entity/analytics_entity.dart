abstract class AnalyticsEntity {
  final int postCount;
  final int videoCount;
  final int friendsCount;
  final int followerCount;
  final int engagementScore;
  AnalyticsEntity({
    required this.postCount,
    required this.videoCount,
    required this.friendsCount,
    required this.followerCount,
    required this.engagementScore,
  });
}
