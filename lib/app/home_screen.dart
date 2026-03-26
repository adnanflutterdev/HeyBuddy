import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/widgets/primary_button.dart';
import 'package:hey_buddy/features/auth/presentation/riverpod/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Consumer(
              builder: (context, ref, _) {
                return PrimaryButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                  },
                  label: 'Logout',
                  icon: Icons.logout,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
