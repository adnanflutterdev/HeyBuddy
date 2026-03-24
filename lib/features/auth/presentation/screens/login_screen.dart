import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/widgets/app_logo.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/core/widgets/custom_app_bar.dart';
import 'package:hey_buddy/core/widgets/primary_button.dart';
import 'package:hey_buddy/core/widgets/title_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoginScreen = true;

  final ValueNotifier<bool> _isObscure = .new(true);
  final ValueNotifier<bool> _isSigning = .new(false);

  final TextEditingController _nameController = .new();
  final TextEditingController _emailController = .new();
  final TextEditingController _passwordController = .new();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _isObscure.dispose();
    _isSigning.dispose();

    _emailController.dispose();
    _passwordController.dispose();

    _formKey.currentState?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(leading: AppLogo(), title: ('Hey ', 'Buddy')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 20,
            children: [
              TitleText(
                text: _isLoginScreen ? ('Log', 'in') : ('Sign', 'up'),
                fontSize: 30,
              ),
              Container(
                padding: AppPadding.p16,
                decoration: BoxDecoration(
                  color: context.colors.container,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 16,
                    children: [
                      if (!_isLoginScreen)
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
                                label: _isLoginScreen ? 'Login' : 'Signup',
                                isLoading: isSigning,
                              );
                            },
                          ),
                          Wrap(
                            crossAxisAlignment: .center,
                            alignment: .center,
                            children: [
                              Text(
                                '${_isLoginScreen ? 'Don\'t' : 'Already'} have an account? ',
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isLoginScreen = !_isLoginScreen;
                                  });
                                },
                                child: Text(
                                  _isLoginScreen ? 'Signup' : 'Login',
                                  style: context.style.b1.copyWith(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
