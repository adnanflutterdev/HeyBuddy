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

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.profile,
    required super.account,
    required super.details,
  });

  factory UserModel.setNewUser({
    required String uid,
    required String name,
    required String email,
  }) {
    return UserModel(
      uid: uid,
      profile: Profile.setNewUser(),
      account: Account.setNewUser(),
      details: Details.setNewUser(name, email),
    );
  }

  factory UserModel.fromFirebase(Map<String, dynamic> user) {
    return UserModel(
      uid: user['uid'] ?? '',
      profile: Profile.fromFirebase(user['profile']),
      account: Account.fromFirebase(user['account']),
      details: Details.fromFirebase(user['details']),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'uid': uid,
      'profile': (profile as Profile).toFirebase(),
      'account': (account as Account).toFirebase(),
      'details': (details as Details).toFirebase(),
    };
  }
}

class Details extends DetailsEntity {
  Details({
    required super.name,
    required super.email,
    required super.dob,
    required super.gender,
  });

  factory Details.setNewUser(String name, String email) {
    return Details(name: name, email: email, dob: null, gender: null);
  }

  factory Details.fromFirebase(Map<String, dynamic> details) {
    return Details(
      name: details['name'] ?? '',
      email: details['email'] ?? '',
      dob: details['dob'],
      gender: details['gender'] != null
          ? GenderX.fromFirebase(details['gender'])
          : null,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {"name": name, "email": email, "dob": dob, "gender": gender};
  }
}

class Account extends AccountEntity {
  Account({
    required super.isOnline,
    required super.isVerified,
    required super.accountType,
    required super.createdAt,
    required super.lastActive,
  });

  factory Account.setNewUser() {
    return Account(
      isOnline: true,
      isVerified: false,
      accountType: .public,
      createdAt: .now(),
      lastActive: .now(),
    );
  }

  factory Account.fromFirebase(Map<String, dynamic> account) {
    return Account(
      isOnline: account['isOnline'] ?? false,
      isVerified: account['isVerified'] ?? false,
      accountType: account['accountType'] == null
          ? AccountType.public
          : AccountTypeX.fromFirebase(account['accountType']),
      createdAt: account['createdAt'] ?? .now(),
      lastActive: account['lastActive'] ?? .now(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "isOnline": isOnline,
      "isVerified": isVerified,
      "createdAt": createdAt,
      "accountType": accountType.name,
      "lastActive": lastActive,
    };
  }
}

class Profile extends ProfileEnity {
  Profile({
    required super.profileImage,
    required super.coverImage,
    required super.bio,
    required super.location,
    required super.website,
    required super.interests,
  });

  factory Profile.setNewUser() {
    return Profile(
      profileImage: null,
      coverImage: null,
      bio: null,
      location: null,
      website: null,
      interests: null,
    );
  }

  factory Profile.fromFirebase(Map<String, dynamic> profile) {
    return Profile(
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
