import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/features/profile/data/models/user.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/user_data_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(userProvider);

    if (userRef.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    UserModel? user = userRef.value as UserModel?;

    if (user == null) {
      return const Center(child: Text('No Data Found'));
    }
    return Column(
      children: [
        Text(user.uid),
        Text(user.details.name),
        Text(user.details.email),
      ],
    );
  }
}
