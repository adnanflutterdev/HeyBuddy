import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/app/splash_screen.dart';
import 'package:hey_buddy/config/provider/theme_provider.dart';
import 'package:hey_buddy/config/theme/app_theme.dart';
import 'package:hey_buddy/core/const/app_colors.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    if (themeMode == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return MaterialApp(
      title: 'Hey Buddy',
      themeMode: themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      navigatorKey: AppNavigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      builder: (context, child) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            // Android
            statusBarIconBrightness: isDarkMode
                ? Brightness.light
                : Brightness.dark,
            // IOS
            statusBarBrightness: isDarkMode
                ? Brightness.dark
                : Brightness.light,

            systemNavigationBarColor: isDarkMode
                ? AppDarkColors.bg
                : AppLightColors.bg,
            systemNavigationBarIconBrightness: isDarkMode
                ? Brightness.light
                : Brightness.dark,
          ),
          child: child!,
        );
      },
    );
  }
}
