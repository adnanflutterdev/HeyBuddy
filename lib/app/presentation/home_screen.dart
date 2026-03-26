import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/app/model/tab_model.dart';
import 'package:hey_buddy/app/riverpod/tab_provider.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabIndex = ref.watch(tabProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: 4,
                controller: _pageController,
                onPageChanged: (value) {
                  ref.read(tabProvider.notifier).changeTab(value);
                },
                itemBuilder: (context, index) {
                  return const Placeholder();
                },
              ),
            ),
            _buildNavbar(tabIndex),
          ],
        ),
      ),
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
          final tab = tabs[index];
          final color = tabIndex == index ? context.colors.neonBlue : null;

          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInCubic,
              );
            },
            child: SizedBox(
              width: width,
              height: 60,
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Icon(tab.icon, color: color),
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

/*
Consumer(
              builder: (context, ref, _) {
                return PrimaryButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                  },
                  label: 'Logout',
                  icon: Icons.logout,
                );
              },
            ),
*/
