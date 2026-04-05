import 'package:cloud_firestore/cloud_firestore.dart';

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

abstract class UserEntity {
  final String uid;
  final ProfileEnity profile;
  final AccountEntity account;
  final DetailsEntity details;

  UserEntity({
    required this.uid,
    required this.profile,
    required this.account,
    required this.details,
  });
}

abstract class DetailsEntity {
  final String name;
  final String email;
  final Timestamp? dob;
  final Gender? gender;
  DetailsEntity({
    required this.name,
    required this.email,
    this.dob,
    this.gender,
  });
}

abstract class AccountEntity {
  final bool isOnline;
  final bool isVerified;
  final AccountType accountType;
  final Timestamp createdAt;
  final Timestamp lastActive;
  AccountEntity({
    required this.isOnline,
    required this.isVerified,
    required this.accountType,
    required this.createdAt,
    required this.lastActive,
  });
}

abstract class ProfileEnity {
  final String? profileImage;
  final String? coverImage;
  final String? bio;
  final String? location;
  final String? website;
  final List<Interest>? interests;
  ProfileEnity({
    this.profileImage,
    this.coverImage,
    this.bio,
    this.location,
    this.website,
    this.interests,
  });
}
