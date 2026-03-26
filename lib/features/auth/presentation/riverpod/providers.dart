import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/features/auth/domain/usecases/login_usecase.dart';
import 'package:hey_buddy/features/auth/domain/usecases/logout_usecase.dart';
import 'package:hey_buddy/features/auth/domain/usecases/signup_usecase.dart';
import 'package:hey_buddy/features/auth/data/repository/auth_repository_impl.dart';
import 'package:hey_buddy/features/auth/data/data_sources/auth_remote_data_source.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final authRemoteDataSourceProvider = Provider(
  (ref) => AuthRemoteDataSource(
    ref.read(firebaseAuthProvider),
    ref.read(firebaseFirestoreProvider),
  ),
);

final authRepositoryProvider = Provider(
  (ref) => AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider)),
);

final loginProvider = Provider(
  (ref) => LoginUsecase(ref.watch(authRepositoryProvider)),
);
final signupProvider = Provider(
  (ref) => SignupUsecase(ref.watch(authRepositoryProvider)),
);
final logoutProvider = Provider(
  (ref) => LogoutUsecase(ref.watch(authRepositoryProvider)),
);
