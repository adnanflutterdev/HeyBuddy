import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/widgets/app_logo.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/core/widgets/custom_app_bar.dart';
import 'package:hey_buddy/core/widgets/primary_button.dart';
import 'package:hey_buddy/core/widgets/stroke_text.dart';
import 'package:hey_buddy/core/widgets/title_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> _isLoginScreen = .new(true);

  final ValueNotifier<bool> _isObscure = .new(true);
  final ValueNotifier<bool> _isSigning = .new(false);

  final TextEditingController _nameController = .new();
  final TextEditingController _emailController = .new();
  final TextEditingController _passwordController = .new();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const double _begin = 5;
  static const double _end = 18;

  late AnimationController _animationController;
  late Animation<double> _blurRadius;

  @override
  void initState() {
    super.initState();

    _initAnimation();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _blurRadius = Tween<double>(begin: _begin, end: _end).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInCubic),
    );

    _animationController.repeat(
      reverse: true,
      period: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _isObscure.dispose();
    _isSigning.dispose();

    _emailController.dispose();
    _passwordController.dispose();

    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(leading: AppLogo(), title: ('Hey ', 'Buddy')),
      body: Center(
        child: SingleChildScrollView(
          padding: AppPadding.symmetric(30, 20),
          child: ValueListenableBuilder(
            valueListenable: _isLoginScreen,
            builder: (context, isLoginScreen, child) {
              return Column(
                spacing: 30,
                children: [
                  TitleText(
                    text: isLoginScreen ? ('Log', 'in') : ('Sign', 'up'),
                    fontSize: 30,
                  ),
                  AnimatedBuilder(
                    animation: _blurRadius,
                    builder: (context, child) {
                      return Container(
                        padding: AppPadding.p16,
                        decoration: BoxDecoration(
                          color: context.colors.container,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: context.colors.neonGreen,
                              blurRadius: _blurRadius.value,
                            ),
                            BoxShadow(
                              color: context.colors.neonBlue,
                              blurRadius: (_end - _blurRadius.value).abs(),
                            ),
                          ],
                        ),
                        child: child,
                      );
                    },
                    child: Form(
                      key: _formKey,
                      child: Column(
                        spacing: 20,
                        children: [
                          if (!isLoginScreen)
                            AppTextField(
                              label: 'Name',
                              controller: _nameController,
                              hintText: 'your name',
                            ),
                          AppTextField(
                            label: 'Email',
                            controller: _emailController,
                            hintText: 'email@example.com',
                          ),
                          Column(
                            mainAxisSize: .min,
                            crossAxisAlignment: .end,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: _isObscure,
                                builder: (context, isObscure, child) {
                                  return AppTextField(
                                    label: 'Password',
                                    isObscure: isObscure,
                                    hintText: '●●●●●●●●',
                                    controller: _passwordController,
                                    suffixIcon: isObscure
                                        ? Icons.lock
                                        : Icons.lock_open,
                                    onSuffixIconTapped: () {
                                      _isObscure.value = !isObscure;
                                    },
                                  );
                                },
                              ),
                              const Text('Forget password?'),
                            ],
                          ),

                          Column(
                            children: [
                              ValueListenableBuilder(
                                valueListenable: _isSigning,
                                builder: (context, isSigning, child) {
                                  return PrimaryButton(
                                    onPressed: () {},
                                    label: isLoginScreen ? 'Login' : 'Signup',
                                    isLoading: isSigning,
                                  );
                                },
                              ),
                              Wrap(
                                crossAxisAlignment: .center,
                                alignment: .center,
                                children: [
                                  Text(
                                    '${isLoginScreen ? 'Don\'t' : 'Already'} have an account? ',
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isLoginScreen.value = !isLoginScreen;
                                      });
                                    },
                                    child: StrokeText(
                                      strokeWidth: 1,
                                      text: isLoginScreen ? 'Signup' : 'Login',
                                      style: context.style.b1.copyWith(
                                        color: context.colors.neonGreen,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
