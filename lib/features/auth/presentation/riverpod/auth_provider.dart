import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/features/auth/presentation/riverpod/providers.dart';
import 'package:hey_buddy/features/auth/presentation/riverpod/auth_notifier.dart';

final authProvider = StateNotifierProvider(
  (ref) => AuthNotifier(
    ref.read(loginProvider),
    ref.read(signupProvider),
    ref.read(logoutProvider),
  ),
);
