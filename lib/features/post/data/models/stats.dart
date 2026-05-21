import 'package:hey_buddy/features/post/domain/entity/stats.dart';

class StatsModel extends Stats {
  StatsModel({
    required super.views,
    required super.likesCount,
    required super.commentsCount,
    required super.sharesCount,
    required super.dislikesCount,
  });

  factory StatsModel.fromJson(Map<String, dynamic>? json) {
    return StatsModel(
      views: json?['views'] ?? 0,
      likesCount: json?['likesCount'] ?? 0,
      commentsCount: json?['commentsCount'] ?? 0,
      sharesCount: json?['sharesCount'] ?? 0,
      dislikesCount: json?['dislikesCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'dislikesCount': dislikesCount,
    };
  }
}
