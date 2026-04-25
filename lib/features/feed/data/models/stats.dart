import 'package:hey_buddy/features/feed/domain/entity/stats_entity.dart';

class Stats extends StatsEntity {
  Stats({
    required super.views,
    required super.likesCount,
    required super.commentsCount,
    required super.sharesCount,
    required super.dislikesCount,
  });

  factory Stats.fromJson(Map<String, dynamic>? json) {
    return Stats(
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
