enum AllowMessagesFrom{
  none,everyone,friends
}

abstract class SettingsEntity {
  final String language;
  final PrivacySettingsEntity privacySettings;
  final NotificationSettingsEntity notificationSettings;
  SettingsEntity({
    required this.language,
    required this.privacySettings,
    required this.notificationSettings,
  });
}

abstract class PrivacySettingsEntity {
  final bool showEmail;
  final bool showDOB;
  final bool allowFriendRequests;
  final AllowMessagesFrom allowMessagesFrom;
  PrivacySettingsEntity({
    required this.showEmail,
    required this.showDOB,
    required this.allowFriendRequests,
    required this.allowMessagesFrom,
  });
}

abstract class NotificationSettingsEntity {
  final bool comments;
  final bool friendRequests;
  final bool messages;
  NotificationSettingsEntity({
    required this.comments,
    required this.friendRequests,
    required this.messages,
  });
}
