import 'package:hey_buddy/features/profile/domain/entity/analytics.dart';

class AnalyticsModel extends Analytics {
  AnalyticsModel({
    required super.postCount,
    required super.videoCount,
    required super.friendsCount,
    required super.followerCount,
    required super.engagementScore,
  });

  factory AnalyticsModel.setNewUser() {
    return AnalyticsModel(
      postCount: 0,
      videoCount: 0,
      friendsCount: 0,
      followerCount: 0,
      engagementScore: 0,
    );
  }

  factory AnalyticsModel.fromFirebase(Map<String, dynamic> analytics) {
    return AnalyticsModel(
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
