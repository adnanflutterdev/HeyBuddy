import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/app/presentation/app.dart';
import 'package:hey_buddy/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final applicationDirectory = await getApplicationDocumentsDirectory();
  Hive.init(applicationDirectory.path);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: App()));
}
