import 'package:hey_buddy/features/profile/domain/entity/analytics_entity.dart';

class Analytics extends AnalyticsEntity {
  Analytics({
    required super.postCount,
    required super.videoCount,
    required super.friendsCount,
    required super.followerCount,
    required super.engagementScore,
  });

  factory Analytics.setNewUser() {
    return Analytics(
      postCount: 0,
      videoCount: 0,
      friendsCount: 0,
      followerCount: 0,
      engagementScore: 0,
    );
  }

  factory Analytics.fromFirebase(Map<String, dynamic> analytics) {
    return Analytics(
      postCount: analytics['postCount'],
      videoCount: analytics['videoCount'],
      friendsCount: analytics['friendsCount'],
      followerCount: analytics['followerCount'],
      engagementScore: analytics['engagementScore'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "postCount": postCount,
      "videoCount": videoCount,
      "friendsCount": friendsCount,
      "followerCount": followerCount,
      "engagementScore": engagementScore,
    };
  }
}
