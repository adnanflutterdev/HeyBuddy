enum AccountType { public, private, friendsOnly }

enum Gender { male, female, others }

enum Interest {
  tech,
  creativity,
  arts,
  entertainment,
  lifestyle,
  sports,
  gaming,
  food,
  business,
  science,
  travel,
}

abstract class UserData {
  final String uid;
  final Profile profile;
  final Account account;
  final Details details;

  UserData({
    required this.uid,
    required this.profile,
    required this.account,
    required this.details,
  });
}

abstract class Details {
  final String name;
  final String username;
  final String email;
  final DateTime? dob;
  final Gender? gender;
  Details({required this.name,required this.username, required this.email, this.dob, this.gender});
}

abstract class Account {
  final bool isOnline;
  final bool isVerified;
  final AccountType accountType;
  final DateTime createdAt;
  final DateTime lastActive;
  Account({
    required this.isOnline,
    required this.isVerified,
    required this.accountType,
    required this.createdAt,
    required this.lastActive,
  });
}

abstract class Profile {
  final String? profileImage;
  final String? coverImage;
  final String? bio;
  final String? location;
  final String? website;
  final List<Interest>? interests;
  Profile({
    this.profileImage,
    this.coverImage,
    this.bio,
    this.location,
    this.website,
    this.interests,
  });
}
