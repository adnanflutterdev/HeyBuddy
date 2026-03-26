import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_validators.dart';
import 'package:hey_buddy/core/widgets/app_logo.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/core/widgets/custom_app_bar.dart';
import 'package:hey_buddy/core/widgets/primary_button.dart';
import 'package:hey_buddy/core/widgets/stroke_text.dart';
import 'package:hey_buddy/core/widgets/title_text.dart';
import 'package:hey_buddy/features/auth/presentation/riverpod/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> _isObscure = .new(true);
  final ValueNotifier<bool> _isLoginScreen = .new(true);

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

  void _authenticate(WidgetRef ref) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_isLoginScreen.value) {
        ref
            .read(authProvider.notifier)
            .login(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );
      } else {
        ref
            .read(authProvider.notifier)
            .signup(
              _nameController.text.trim(),
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );
      }
    }
  }

  @override
  void dispose() {
    _isObscure.dispose();

    _nameController.dispose();
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
                  _buildTitle(isLoginScreen),
                  _buildFormContainer(isLoginScreen),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(bool isLoginScreen) {
    return TitleText(
      text: isLoginScreen ? ('Log', 'in') : ('Sign', 'up'),
      fontSize: 30,
    );
  }

  Widget _buildFormContainer(bool isLoginScreen) {
    return AnimatedBuilder(
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
      child: _buildForm(isLoginScreen),
    );
  }

  Widget _buildForm(bool isLoginScreen) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 20,
        children: [
          if (!isLoginScreen)
            AppTextField(
              label: 'Name',
              controller: _nameController,
              hintText: 'your name',
              validator: AppValidators.name,
            ),
          AppTextField(
            label: 'Email',
            controller: _emailController,
            hintText: 'email@example.com',
            validator: AppValidators.email,
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
                    suffixIcon: isObscure ? Icons.lock : Icons.lock_open,
                    onSuffixIconTapped: () {
                      _isObscure.value = !isObscure;
                    },
                    validator: AppValidators.password,
                  );
                },
              ),
              const Text('Forget password?'),
            ],
          ),

          Column(
            children: [
              _buildAuthenticationButton(isLoginScreen),
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
    );
  }

  Widget _buildAuthenticationButton(bool isLoginScreen) {
    return Consumer(
      builder: (context, ref, child) {
        ref.listen(authProvider, (previous, next) {
          next.when(
            data: (response) {
              if (response == null) return;
              if (!response.success) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(response.message)));
              }
            },
            error: (error, stackTrace) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(error.toString())));
            },
            loading: () {},
          );
        });
        final authState = ref.watch(authProvider);
        return PrimaryButton(
          onPressed: () => _authenticate(ref),
          label: isLoginScreen ? 'Login' : 'Signup',
          isLoading: authState.isLoading,
        );
      },
    );
  }
}
