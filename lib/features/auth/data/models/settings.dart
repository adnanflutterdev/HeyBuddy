import 'package:hey_buddy/features/auth/domain/entity/settings_entity.dart';

extension AllowMessagesFromX on AllowMessagesFrom {
  static AllowMessagesFrom fromFirebase(String allowMessagesFrom) {
    return AllowMessagesFrom.values.firstWhere(
      (messageFrom) => messageFrom.name == allowMessagesFrom,
    );
  }
}

class SettingsModel extends SettingsEntity {
  SettingsModel({
    required super.language,
    required super.privacySettings,
    required super.notificationSettings,
  });

  factory SettingsModel.setNewUser() {
    return SettingsModel(
      language: 'English',
      privacySettings: PrivacySettings.setNewUser(),
      notificationSettings: NotificationSettings.setNewUser(),
    );
  }

  factory SettingsModel.fromFirebase(Map<String, dynamic> settings) {
    return SettingsModel(
      language: settings['language'],
      privacySettings: PrivacySettings.fromFirebase(settings['privacySettings']),
      notificationSettings: NotificationSettings.fromFirebase(
        settings['notificationSettings'],
      ),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "language": language,
      "privacySettings": (privacySettings as PrivacySettings).toFirebase(),
      "notificationSettings": (notificationSettings as NotificationSettings)
          .toFirebase(),
    };
  }
}

class PrivacySettings extends PrivacySettingsEntity {
  PrivacySettings({
    required super.showEmail,
    required super.showDOB,
    required super.allowFriendRequests,
    required super.allowMessagesFrom,
  });

  factory PrivacySettings.setNewUser() {
    return PrivacySettings(
      showEmail: true,
      showDOB: true,
      allowFriendRequests: true,
      allowMessagesFrom: .everyone,
    );
  }

  factory PrivacySettings.fromFirebase(Map<String, dynamic> privacySettings) {
    return PrivacySettings(
      showEmail: privacySettings['showEmail'],
      showDOB: privacySettings['showDOB'],
      allowFriendRequests: privacySettings['allowFriendRequests'],
      allowMessagesFrom: privacySettings['allowMessagesFrom'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "showEmail": showEmail,
      "showDOB": showDOB,
      "allowFriendRequests": allowFriendRequests,
      "allowMessagesFrom": allowMessagesFrom.name,
    };
  }
}

class NotificationSettings extends NotificationSettingsEntity {
  NotificationSettings({
    required super.comments,
    required super.friendRequests,
    required super.messages,
  });

  factory NotificationSettings.setNewUser() {
    return NotificationSettings(
      comments: true,
      friendRequests: true,
      messages: true,
    );
  }

  factory NotificationSettings.fromFirebase(
    Map<String, dynamic> notificationSettings,
  ) {
    return NotificationSettings(
      comments: notificationSettings['comments'],
      friendRequests: notificationSettings['friendRequests'],
      messages: notificationSettings['messages'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "comments": comments,
      "friendRequests": friendRequests,
      "messages": messages,
    };
  }
}
