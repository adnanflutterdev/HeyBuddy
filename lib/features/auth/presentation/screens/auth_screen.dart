import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/const/app_validators.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/utils/messenger.dart';
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

  @override
  void initState() {
    super.initState();
  }

  void _authenticate(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      Result result;
      _formKey.currentState!.save();
      final authNotifier = ref.read(authProvider.notifier);

      if (_isLoginScreen.value) {
        result = await authNotifier.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        result = await authNotifier.signup(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      }
      if (!result.success && mounted) {
        showMessenger(context, result: result);
      }
    }
  }

  void _authenticateWithGoogle(WidgetRef ref) async {
    final result = await ref.read(authProvider.notifier).googleSignin();

    if (!result.success && mounted) {
      showMessenger(context, result: result);
    }
  }

  @override
  void dispose() {
    _isObscure.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

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
                  _buildGoogleSignin(),
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
    return Container(
      padding: AppPadding.p16,
      decoration: BoxDecoration(
        color: context.colors.container,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 3, color: context.colors.shadow)],
      ),
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
                    suffixIcon: isObscure
                        ? Icons.visibility_off
                        : Icons.visibility,
                    onSuffixIconTapped: () {
                      _isObscure.value = !isObscure;
                    },
                    validator: AppValidators.password,
                  );
                },
              ),
              AppSpacing.h4,
              Text('Forget password?', style: context.style.bs2),
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
                    style: context.style.bs2,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLoginScreen.value = !isLoginScreen;
                      });
                    },
                    child: StrokeText(
                      strokeWidth: 0.5,
                      text: isLoginScreen ? 'Signup' : 'Login',
                      style: context.style.bs1.copyWith(
                        color: context.colors.neonGreen,
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

  Widget _buildGoogleSignin() {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider()),
            Text(' OR '),
            Expanded(child: Divider()),
          ],
        ),
        AppSpacing.h20,
        Consumer(
          builder: (context, ref, _) {
            final authRef = ref.watch(authProvider);

            return GestureDetector(
              onTap: authRef.isLoading
                  ? null
                  : () => _authenticateWithGoogle(ref),
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.container,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(blurRadius: 3, color: context.colors.shadow),
                  ],
                ),

                padding: AppPadding.v8,
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Image.asset('assets/images/google.png', height: 30),
                    AppSpacing.w12,
                    if (authRef.isLoading)
                      const SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(),
                      )
                    else
                      const Text('Continue with Google'),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAuthenticationButton(bool isLoginScreen) {
    return Consumer(
      builder: (context, ref, child) {
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
