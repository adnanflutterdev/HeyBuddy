import 'package:hey_buddy/features/profile/presentation/riverpod/my_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/app/presentation/widgets/build_home.dart';
import 'package:hey_buddy/app/presentation/widgets/build_set_username.dart';
import 'package:hey_buddy/core/utils/error_state.dart';
import 'package:hey_buddy/core/utils/loader.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myDataRef = ref.watch(myDataProvider);
    return myDataRef.when(
      data: (myData) {
        if (myData.details.username.isEmpty) {
          return BuildSetUsername(myData: myData);
        } else {
          return const BuildHome();
        }
      },
      error: error,
      loading: loader,
    );
  }
}
