import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/Screens/Users/suggested_friends.dart';
import 'package:heybuddy/Screens/Users/users.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  int i = 0;

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: i,
    );
  }

  void changePage(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width / 2;

    return Column(
      children: [
        const Divider(
          height: 1,
          color: bgColor,
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  i = 0;
                  changePage(i);
                });
              },
              child: Container(
                width: width,
                height: 40,
                color:
                    i == 0 ? appBarColor.withValues(alpha: 0.5) : appBarColor,
                child: Center(
                    child: Text(
                  'Users',
                  style: roboto(fontSize: 15, color: white),
                )),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  i = 1;
                  changePage(i);
                });
              },
              child: Container(
                width: width,
                height: 40,
                color:
                    i == 1 ? appBarColor.withValues(alpha: 0.5) : appBarColor,
                child: Center(
                    child: Text(
                  'Suggested',
                  style: roboto(fontSize: 15, color: white),
                )),
              ),
            ),
          ],
        ),
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: 3,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              List pages = [
                const Users(),
                const SuggestedFriends(),
              ];
              return pages[index];
            },
          ),
        )
      ],
    );
  }
}
