import 'package:cloud_firestore/cloud_firestore.dart';

class MyPosts {
  final List<String> myPosts;
  final List<String> likedPosts;
  final List<String> dislikedPosts;
  MyPosts({
    this.myPosts = const [],
    this.likedPosts = const [],
    this.dislikedPosts = const [],
  });

  factory MyPosts.fromJson(Map<String, dynamic> posts) {
    return MyPosts(
      myPosts: posts['myPosts'].cast<String>(),
      likedPosts: posts['likedPosts'].cast<String>(),
      dislikedPosts: posts['dislikedPosts'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "myPosts": myPosts,
      "likedPosts": likedPosts,
      "dislikedPosts": dislikedPosts,
    };
  }
}

// Videos
//
class MyVideos {
  final List<String> myVideos;
  final List<String> likedVideos;
  final List<String> dislikedVideos;
  MyVideos({
    this.myVideos = const [],
    this.likedVideos = const [],
    this.dislikedVideos = const [],
  });

  factory MyVideos.fromJson(Map<String, dynamic> posts) {
    return MyVideos(
      myVideos: posts['myVideos'].cast<String>(),
      likedVideos: posts['likedVideos'].cast<String>(),
      dislikedVideos: posts['dislikedVideos'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "myVideos": myVideos,
      "likedVideos": likedVideos,
      "dislikedVideos": dislikedVideos,
    };
  }
}

// Notifications
//
class Notifications {
  final List<String> chatNotifications;
  final List<AppNotification> appNotification;
  Notifications({
    this.chatNotifications = const [],
    this.appNotification = const [],
  });

  factory Notifications.fromJson(Map<String, dynamic> notificatons) {
    return Notifications(
      chatNotifications: notificatons['chatNotifications'].cast<String>(),
      appNotification:
          (notificatons['appNotifications'] as List<dynamic>? ?? [])
              .map(
                (notificaton) => AppNotification.fromJson(
                  Map<String, dynamic>.from(notificaton),
                ),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "chatNotifications": chatNotifications,
      "appNotifications": appNotification
          .map(
            (AppNotification appNotification) => appNotification.toJson(),
          )
          .toList(),
    };
  }
}

class AppNotification {
  final String type;
  final String message;
  final String requestId;
  final bool seen;
  final Timestamp date;
  AppNotification({
    required this.type,
    required this.message,
    required this.requestId,
    required this.seen,
    required this.date,
  });

  factory AppNotification.fromJson(Map<String, dynamic> appNotification) {
    return AppNotification(
      type: appNotification['type'],
      message: appNotification['message'],
      requestId: appNotification['requestId'],
      seen: appNotification['seen'],
      date: appNotification['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "message": message,
      "requestId": requestId,
      "seen": seen,
      "date": date,
    };
  }
}

