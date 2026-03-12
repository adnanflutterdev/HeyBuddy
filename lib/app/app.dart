import 'package:flutter/material.dart';
import 'package:hey_buddy/app/hey_buddy.dart';
import 'package:hey_buddy/core/const/app_colors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hey Buddy',
      theme: ThemeData(
        cardColor: AppColors.containerColor,
        scaffoldBackgroundColor: AppColors.bgColor,
        colorScheme: .fromSeed(seedColor: AppColors.neonBlueColor),
        appBarTheme: AppBarThemeData(backgroundColor: AppColors.appbarColor),
      ),
      home: HeyBuddy(),
    );
  }
}
