import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_validators.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/utils/get_user_name_queries.dart';
import 'package:hey_buddy/core/utils/messenger.dart';
import 'package:hey_buddy/core/widgets/app_logo.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/core/widgets/custom_app_bar.dart';
import 'package:hey_buddy/core/widgets/primary_button.dart';
import 'package:hey_buddy/core/widgets/title_text.dart';
import 'package:hey_buddy/features/auth/presentation/riverpod/username_providers.dart';
import 'package:hey_buddy/features/profile/data/models/user_name_model.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/my_data_provider.dart';

class BuildSetUsername extends ConsumerStatefulWidget {
  const BuildSetUsername({super.key, required this.myData});
  final UserData myData;

  @override
  ConsumerState<BuildSetUsername> createState() => _BuildSetUsernameState();
}

class _BuildSetUsernameState extends ConsumerState<BuildSetUsername> {
  Timer? searchTimer;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = .new();
  String? forceError;

  void autoValidate(String username) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      searchTimer?.cancel();
      searchTimer = Timer(const Duration(milliseconds: 500), () async {
        Result<bool> result = await ref
            .read(usernameProvider.notifier)
            .doesUserExists(username.trim());
        if (result.data != null && result.data!) {
          setState(() {
            forceError = 'User already exists';
          });
        } else {
          setState(() {
            forceError = null;
          });
        }
      });
    }
  }

  void setUsername() async {
    UsernameModel username = UsernameModel(
      uid: widget.myData.uid,
      email: widget.myData.details.email,
      username: _usernameController.text.trim(),
    );
    final result = await ref
        .read(usernameProvider.notifier)
        .setUserName(username, getUserNameQueries(username.username));
    if (!result.success && mounted) {
      showMessenger(context, result: result);
    } else {
      final _ = ref.refresh(myDataProvider);
    }
  }

  @override
  void dispose() {
    searchTimer?.cancel();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(leading: AppLogo(), title: ('Hey ', 'Buddy')),
      body: Center(
        child: SingleChildScrollView(
          padding: AppPadding.symmetric(15, 20),
          child: Column(
            spacing: 30,
            children: [_buildTitle(), _buildFormContainer()],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const TitleText(text: ('Set', ' username'), fontSize: 30);
  }

  Widget _buildFormContainer() {
    return Container(
      padding: AppPadding.p12,
      decoration: BoxDecoration(
        color: context.colors.container,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 3, color: context.colors.shadow)],
      ),
      child: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 20,
        children: [
          Column(
            crossAxisAlignment: .start,
            children: [
              AppTextField(
                label: 'Username',
                hintText: 'user123',
                controller: _usernameController,
                prefixIcon: Icons.alternate_email,
                validator: AppValidators.username,
                onChanged: autoValidate,
              ),
              if (forceError != null)
                Padding(
                  padding: AppPadding.symmetric(10, 4),
                  child: Text(
                    forceError!,
                    style: context.style.bs2.copyWith(
                      color: context.colors.error,
                    ),
                  ),
                ),
            ],
          ),

          Consumer(
            builder: (context, ref, _) {
              final usernameState = ref.watch(usernameProvider);
              return PrimaryButton(
                onPressed: forceError == null ? setUsername : null,
                label: 'Confirm',
                isLoading: usernameState.isLoading,
              );
            },
          ),
        ],
      ),
    );
  }
}
