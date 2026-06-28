import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

extension AccountTypeX on AccountType {
  static AccountType fromFirebase(String accountType) {
    return AccountType.values.firstWhere((type) => type.name == accountType);
  }
}

extension GenderX on Gender {
  static Gender fromFirebase(String gender) {
    return Gender.values.firstWhere((type) => type.name == gender);
  }
}

extension InterestX on Interest {
  static Interest fromFirebase(String interest) {
    return Interest.values.firstWhere((type) => type.name == interest);
  }
}

class UserDataModel extends UserData {
  UserDataModel({
    required super.uid,
    required super.profile,
    required super.account,
    required super.details,
  });

  factory UserDataModel.fromEntity(UserData user) {
    return UserDataModel(
      uid: user.uid,
      profile: ProfileModel.fromEntity(user.profile),
      account: AccountModel.fromEntity(user.account),
      details: DetailsModel.fromEntity(user.details),
    );
  }

  factory UserDataModel.setNewUser({
    required String uid,
    required String name,
    required String email,
  }) {
    return UserDataModel(
      uid: uid,
      profile: ProfileModel.setNewUser(),
      account: AccountModel.setNewUser(),
      details: DetailsModel.setNewUser(name, email),
    );
  }

  factory UserDataModel.fromFirebase(Map<String, dynamic> user) {
    return UserDataModel(
      uid: user['uid'] ?? '',
      profile: ProfileModel.fromFirebase(user['profile']),
      account: AccountModel.fromFirebase(user['account']),
      details: DetailsModel.fromFirebase(user['details']),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'uid': uid,
      'searchName': details.name.toLowerCase(),
      'profile': (profile as ProfileModel).toFirebase(),
      'account': (account as AccountModel).toFirebase(),
      'details': (details as DetailsModel).toFirebase(),
    };
  }
}

class DetailsModel extends Details {
  DetailsModel({
    required super.name,
    required super.username,
    required super.email,
    required super.dob,
    required super.gender,
  });

  factory DetailsModel.fromEntity(Details details) {
    return DetailsModel(
      name: details.name,
      username: details.username,
      email: details.email,
      dob: details.dob,
      gender: details.gender,
    );
  }

  factory DetailsModel.setNewUser(String name, String email) {
    return DetailsModel(
      name: name,
      username: '',
      email: email,
      dob: null,
      gender: null,
    );
  }

  factory DetailsModel.fromFirebase(Map<String, dynamic> details) {
    return DetailsModel(
      name: details['name'] ?? '',
      username: details['username'] ?? '',
      email: details['email'] ?? '',
      dob: (details['dob'] as Timestamp?)?.toDate(),
      gender: details['gender'] != null
          ? GenderX.fromFirebase(details['gender'])
          : null,
    );
  }

  DetailsModel copyWith({String? name, DateTime? dob, Gender? gender}) {
    return DetailsModel(
      name: name ?? this.name,
      username: username,
      email: email,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "name": name,
      "username": username,
      "email": email,
      "dob": dob != null ? Timestamp.fromDate(dob!) : null,
      "gender": gender?.name,
    };
  }
}

class AccountModel extends Account {
  AccountModel({
    required super.isOnline,
    required super.isVerified,
    required super.accountType,
    required super.createdAt,
    required super.lastActive,
  });

  factory AccountModel.fromEntity(Account account) {
    return AccountModel(
      isOnline: account.isOnline,
      isVerified: account.isVerified,
      accountType: account.accountType,
      createdAt: account.createdAt,
      lastActive: account.lastActive,
    );
  }

  factory AccountModel.setNewUser() {
    return AccountModel(
      isOnline: true,
      isVerified: false,
      accountType: .public,
      createdAt: .now(),
      lastActive: .now(),
    );
  }

  factory AccountModel.fromFirebase(Map<String, dynamic> account) {
    return AccountModel(
      isOnline: account['isOnline'] ?? false,
      isVerified: account['isVerified'] ?? false,
      accountType: account['accountType'] == null
          ? AccountType.public
          : AccountTypeX.fromFirebase(account['accountType']),
      createdAt: (account['createdAt'] as Timestamp).toDate(),
      lastActive: (account['lastActive'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "isOnline": isOnline,
      "isVerified": isVerified,
      "accountType": accountType.name,
      "createdAt": Timestamp.fromDate(createdAt),
      "lastActive": Timestamp.fromDate(lastActive),
    };
  }
}

class ProfileModel extends Profile {
  ProfileModel({
    required super.profileImage,
    required super.coverImage,
    required super.bio,
    required super.location,
    required super.website,
    required super.interests,
  });

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      profileImage: profile.profileImage,
      coverImage: profile.coverImage,
      bio: profile.bio,
      location: profile.location,
      website: profile.website,
      interests: profile.interests,
    );
  }

  factory ProfileModel.setNewUser() {
    return ProfileModel(
      profileImage: null,
      coverImage: null,
      bio: null,
      location: null,
      website: null,
      interests: null,
    );
  }

  factory ProfileModel.fromFirebase(Map<String, dynamic> profile) {
    return ProfileModel(
      profileImage: profile['profileImage'],
      coverImage: profile['coverImage'],
      bio: profile['bio'],
      location: profile['location'],
      website: profile['website'],
      interests: profile['interests'] != null
          ? (profile['interests'] as List<dynamic>)
                .map((interest) => InterestX.fromFirebase(interest))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "profileImage": profileImage,
      "coverImage": coverImage,
      "bio": bio,
      "location": location,
      "website": website,
      "interests": interests?.map((interest) => interest.name).toList() ?? [],
    };
  }
}
