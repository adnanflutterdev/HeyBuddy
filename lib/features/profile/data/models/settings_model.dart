import 'package:hey_buddy/features/profile/domain/entity/settings.dart';

extension AllowMessagesFromX on AllowMessagesFrom {
  static AllowMessagesFrom fromFirebase(String allowMessagesFrom) {
    return AllowMessagesFrom.values.firstWhere(
      (messageFrom) => messageFrom.name == allowMessagesFrom,
    );
  }
}

class SettingsModel extends Settings {
  SettingsModel({
    required super.language,
    required super.privacySettings,
    required super.notificationSettings,
  });

  factory SettingsModel.setNewUser() {
    return SettingsModel(
      language: 'English',
      privacySettings: PrivacySettingsModel.setNewUser(),
      notificationSettings: NotificationSettingsModel.setNewUser(),
    );
  }

  factory SettingsModel.fromFirebase(Map<String, dynamic> settings) {
    return SettingsModel(
      language: settings['language'],
      privacySettings: PrivacySettingsModel.fromFirebase(
        settings['privacySettings'],
      ),
      notificationSettings: NotificationSettingsModel.fromFirebase(
        settings['notificationSettings'],
      ),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "language": language,
      "privacySettings": (privacySettings as PrivacySettingsModel).toFirebase(),
      "notificationSettings":
          (notificationSettings as NotificationSettingsModel).toFirebase(),
    };
  }
}

class PrivacySettingsModel extends PrivacySettings {
  PrivacySettingsModel({
    required super.showEmail,
    required super.showDOB,
    required super.allowFriendRequests,
    required super.allowMessagesFrom,
  });

  factory PrivacySettingsModel.setNewUser() {
    return PrivacySettingsModel(
      showEmail: true,
      showDOB: true,
      allowFriendRequests: true,
      allowMessagesFrom: .everyone,
    );
  }

  factory PrivacySettingsModel.fromFirebase(
    Map<String, dynamic> privacySettings,
  ) {
    return PrivacySettingsModel(
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

class NotificationSettingsModel extends NotificationSettings {
  NotificationSettingsModel({
    required super.comments,
    required super.friendRequests,
    required super.messages,
  });

  factory NotificationSettingsModel.setNewUser() {
    return NotificationSettingsModel(
      comments: true,
      friendRequests: true,
      messages: true,
    );
  }

  factory NotificationSettingsModel.fromFirebase(
    Map<String, dynamic> notificationSettings,
  ) {
    return NotificationSettingsModel(
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
