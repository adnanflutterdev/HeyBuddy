import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/app/model/tab_model.dart';
import 'package:hey_buddy/app/riverpod/tab_provider.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/utils/loader.dart';
import 'package:hey_buddy/core/widgets/app_logo.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';
import 'package:hey_buddy/core/widgets/custom_app_bar.dart';
import 'package:hey_buddy/core/widgets/labeled_icon_button.dart';
import 'package:hey_buddy/core/widgets/logo_image.dart';
import 'package:hey_buddy/features/chat/presentation/pages/chat_tab.dart';
import 'package:hey_buddy/features/clip/presentation/pages/clip_tab.dart';
import 'package:hey_buddy/features/clip/presentation/pages/clip_upload_screen.dart';
import 'package:hey_buddy/features/post/presentation/pages/post_tab.dart';
import 'package:hey_buddy/features/post/presentation/pages/post_upload_screeen.dart';
import 'package:hey_buddy/features/profile/presentation/pages/my_profile.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/my_data_provider.dart';
import 'package:hey_buddy/features/users/presentation/pages/users_tab.dart';

class BuildHome extends ConsumerStatefulWidget {
  const BuildHome({super.key});

  @override
  ConsumerState<BuildHome> createState() => _BuildHomeState();
}

class _BuildHomeState extends ConsumerState<BuildHome> {
  final PageController _pageController = PageController(initialPage: 2);
  late List<Widget> pages = [
    const PostTab(),
    ClipTab(pageController: _pageController),
    const ChatTab(),
    const UsersTab(),
  ];

  List<TabModel> tabs = [
    TabModel(label: 'Home', icon: Icons.home_filled),
    TabModel(label: 'Clip', icon: Icons.video_collection_rounded),
    TabModel(label: 'Chat', icon: Icons.chat_rounded),
    TabModel(label: 'Users', icon: Icons.group),
  ];
  late double width = context.width / 4;

  void createNew() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            color: context.colors.appbar,
            padding: AppPadding.p16,
            child: Row(
              spacing: 15,
              children: [
                LabeledIconButton(
                  onPressed: () {
                    AppNavigator.pop();
                    AppNavigator.push(const PostUploadScreeen());
                  },
                  icon: Icons.photo,
                  label: 'Upload Post',
                ),
                LabeledIconButton(
                  onPressed: () {
                    AppNavigator.pop();
                    AppNavigator.push(const ClipUploadScreen());
                  },
                  icon: Icons.movie_sharp,
                  label: 'Upload Clip',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void exitApp() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit Hey Buddy'),
          content: const Text('Are you sure to exit'),
          actions: [
            AppMaterialButton(
              text: 'Cancel',
              onPressed: () {
                AppNavigator.pop();
              },
            ),
            AppMaterialButton(
              text: 'Exit',
              borderColor: context.colors.error,
              bgColor: context.colors.onError,
              style: context.style.b2.copyWith(color: context.colors.error),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabIndex = ref.watch(tabProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        } else {
          if (tabIndex == 0) {
            exitApp();
          } else {
            _pageController.jumpToPage(0);
          }
        }
      },
      child: Scaffold(
        appBar: _buildAppbar(tabIndex) as PreferredSizeWidget?,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: pages.length,
                  controller: _pageController,
                  onPageChanged: (value) {
                    ref.read(tabProvider.notifier).changeTab(value);
                  },
                  itemBuilder: (context, index) {
                    return pages[index];
                  },
                ),
              ),
              _buildNavbar(tabIndex),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildAppbar(int tabIndex) {
    (String, String) title = ('Hey ', 'Buddy');

    if (tabIndex == 1) {
      return null;
    }
    return CustomAppBar(
      leading: _buildUserProfile(),
      title: title,
      actions: [
        IconButton(onPressed: createNew, icon: const Icon(Icons.add)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
      ],
    );
  }

  Widget _buildUserProfile() {
    final userRef = ref.watch(myDataProvider);
    return userRef.when(
      data: (user) {
        return LogoImage(
          image: user.profile.profileImage,
          size: 40,
          onPressed: () {
            AppNavigator.push(const MyProfile());
          },
        );
      },
      error: (_, _) => const AppLogo(),
      loading: loader,
    );
  }

  Widget _buildNavbar(int tabIndex) {
    if (tabIndex == 1) {
      return const SizedBox.shrink();
    }
    return Container(
      color: context.colors.appbar,
      child: Row(
        children: List.generate(tabs.length, (index) {
          TabModel tab = tabs[index];
          double size = tabIndex == index ? 30 : 25;
          Color? color = tabIndex == index ? context.colors.neonBlue : null;

          return GestureDetector(
            onTap: () {
              int diff = (tabIndex - index).abs();
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: (diff * 250).clamp(250, 600)),
                curve: Curves.easeIn,
              );
            },
            child: Container(
              color: Colors.transparent,
              width: width,
              height: 60,
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Icon(tab.icon, color: color, size: size),
                  Text(
                    tab.label,
                    style: context.style.bs1.copyWith(color: color),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
