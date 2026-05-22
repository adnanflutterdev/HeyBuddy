enum AllowMessagesFrom { none, everyone, friends }

abstract class Settings {
  final String language;
  final PrivacySettings privacySettings;
  final NotificationSettings notificationSettings;

  Settings({
    required this.language,
    required this.privacySettings,
    required this.notificationSettings,
  });
}

abstract class PrivacySettings {
  final bool showEmail;
  final bool showDOB;
  final bool allowFriendRequests;
  final AllowMessagesFrom allowMessagesFrom;

  PrivacySettings({
    required this.showEmail,
    required this.showDOB,
    required this.allowFriendRequests,
    required this.allowMessagesFrom,
  });
}

abstract class NotificationSettings {
  final bool comments;
  final bool friendRequests;
  final bool messages;
  
  NotificationSettings({
    required this.comments,
    required this.friendRequests,
    required this.messages,
  });
}
