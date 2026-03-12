import 'package:flutter/material.dart';
import 'package:hey_buddy/app/app.dart';
import 'package:hey_buddy/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}