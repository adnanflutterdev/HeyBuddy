import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/app/model/tab_model.dart';
import 'package:hey_buddy/app/riverpod/tab_provider.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/name_split_extention.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/widgets/app_logo.dart';
import 'package:hey_buddy/core/widgets/custom_app_bar.dart';
import 'package:hey_buddy/features/chat/presentation/pages/chat_screen.dart';
import 'package:hey_buddy/features/post/presentation/pages/post_screen.dart';
import 'package:hey_buddy/features/profile/data/models/user.dart';
import 'package:hey_buddy/features/profile/presentation/pages/profile_screen.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/user_data_provider.dart';
import 'package:hey_buddy/features/video/presentation/pages/video_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();
  final List<Widget> pages = [
    const PostScreen(),
    const VideoScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabIndex = ref.watch(tabProvider);
    return Scaffold(
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
    );
  }

  Widget? _buildAppbar(int tabIndex) {
    final userRef = ref.watch(userProvider);

    UserModel? user = userRef.value as UserModel?;
    (String, String) title = ('Hey ', 'Buddy');
    if (tabIndex == 3) {
      if (user != null) {
        title = user.details.name.splitName;
      }
    }
    if (tabIndex == 1) {
      return null;
    }
    return CustomAppBar(
      leading: const AppLogo(),
      title: title,
      fontSize: (tabIndex == 3 && user != null) ? 20 : null,
      actions: [
        if (tabIndex == 3)
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
        else
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
      ],
    );
  }

  Widget _buildNavbar(int tabIndex) {
    List<TabModel> tabs = [
      TabModel(label: 'Home', icon: Icons.home_filled),
      TabModel(label: 'Video', icon: Icons.video_collection_rounded),
      TabModel(label: 'Chat', icon: Icons.chat_rounded),
      TabModel(label: 'Account', icon: Icons.person),
    ];
    final width = context.width / 4;
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
