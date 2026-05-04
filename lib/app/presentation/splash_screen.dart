import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_colors.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/features/auth/presentation/screens/auth_state_screen.dart';
import 'package:hey_buddy/features/feed/riverpod/feed_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> _scaleAnimation;
  late AnimationController _scaleController;

  late Animation<double> _gradientStopAnimation;
  late AnimationController _gradientStopController;

  @override
  void initState() {
    super.initState();
    initScaleAnimation();
    initGradientStopAnimation();
    initPostFeed();
  }

  void initScaleAnimation() {
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInCubic),
    );

    _scaleController.addStatusListener(animationListener);

    _scaleController.forward();
  }

  void animationListener(AnimationStatus status) {
    if (status == .completed) {
      AppNavigator.pushReplaceMent(const AuthStateScreen());
    }
  }

  void initGradientStopAnimation() {
    _gradientStopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _gradientStopAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _gradientStopController, curve: Curves.ease),
    );

    _gradientStopController.addStatusListener(animationListener);

    _gradientStopController.repeat();
  }

  void initPostFeed() async {
    ref.read(postsProvider);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _gradientStopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            const Spacer(),
            AnimatedBuilder(
              animation: _gradientStopAnimation,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppDarkColors.neonBlue,
                      AppDarkColors.neonGreen,
                      AppDarkColors.neonBlue,
                    ],
                    stops: [0, _gradientStopAnimation.value, 1],
                  ).createShader(bounds),
                  child: const Text(
                    'Hey Buddy',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            Text('Connect with your buddies', style: context.style.b1),
          ],
        ),
      ),
    );
  }
}
