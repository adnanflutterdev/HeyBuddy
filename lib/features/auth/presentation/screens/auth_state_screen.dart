import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hey_buddy/app/presentation/home_screen.dart';
import 'package:hey_buddy/features/auth/presentation/screens/login_screen.dart';

class AuthStateScreen extends StatelessWidget {
  const AuthStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == null || !snapshot.hasData || snapshot.hasError) {
          return const LoginScreen();
        }

        return const HomeScreen();
      },
    );
  }
}
