import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/debug_print.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/colored_text.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/Functions/time_and_date.dart';
import 'package:heybuddy/Notification/notification_service.dart';
import 'package:heybuddy/Screens/Chat/chat.dart';
import 'package:heybuddy/Screens/Notifications.dart/notification_icon.dart';
import 'package:heybuddy/Screens/Users/users_screen.dart';
import 'package:heybuddy/Screens/Videos/video_upload_screen.dart';
import 'package:heybuddy/widgets/my_details.dart';
import 'package:heybuddy/Screens/Posts/all_posts.dart';
import 'package:heybuddy/Screens/Posts/post_upload_screen.dart';
import 'package:heybuddy/Screens/Videos/all_videos.dart';
import 'package:stroke_text/stroke_text.dart';

class Heybuddy extends StatefulWidget {
  const Heybuddy({super.key, required this.i});
  final int i;

  @override
  State<Heybuddy> createState() => _HeybuddyState();
}

class _HeybuddyState extends State<Heybuddy> with WidgetsBindingObserver {
  // AppLifecycleState? lastLifecycleState;
  late int pageIndex;
  String myUid = FirebaseAuth.instance.currentUser!.uid;
  late PageController pageController;
  NotificationService notificationService = NotificationService();
  List pages = [
    const AllPosts(),
    const Chat(),
    const UsersScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pageIndex = widget.i;
    pageController = PageController(initialPage: 1);
    updateToken();
    notificationService.requestNotificationPermission();
    notificationService.firebaseInit();
  }

  void updateToken() async {
    String token = await notificationService.getToken();
    DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
        .instance
        .collection('userData')
        .doc(myUid)
        .get();

    if (userData.get('token') != token) {
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(myUid)
          .update({'token': token});
    }
  }

  void changePage(i) {
    setState(() {
      pageIndex = i;
    });
    pageController.animateToPage(i,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void addPosts() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: 100,
          color: appBarColor,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PostUploadScreen(),
                    ));
                  },
                  child: Container(
                    width: 250,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: white),
                      color: neonBlue,
                    ),
                    child: Center(
                      child: StrokeText(
                        text: 'Upload new Post 📷',
                        textStyle: jotiOne(color: white, fontSize: 17),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const VideoUploadScreen(),
                    ));
                  },
                  child: Container(
                    width: 250,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: white),
                      color: neonBlue,
                    ),
                    child: Center(
                      child: StrokeText(
                        text: 'Upload new video 📽️',
                        textStyle: jotiOne(color: white, fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    handleAppLifeCycle(state);
  }

  void handleAppLifeCycle(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(myUid)
          .update({'isActive': 'Online'});
    } else {
      List dt = dateTime();
      String lastActive = '${dt[1]} ${dt[2]}';
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(myUid)
          .update({'isActive': lastActive});
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // App bar
              Container(
                width: double.infinity,
                height: 60,
                color: appBarColor,
                child: Row(
                  children: [
                    w10,
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('userData')
                            .doc(myUid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: neonGreen)),
                              child: Center(
                                child: Image.asset(
                                  'assets/icons/heyBuddy.png',
                                  width: 45,
                                  height: 45,
                                ),
                              ),
                            );
                          }
                          final userData = snapshot.data!.data();
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyDetails(
                                  myDetails: userData,
                                ),
                              ));
                            },
                            child: Container(
                              width: 46,
                              height: 46,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: neonGreen)),
                              child: Center(
                                child: CachedNetworkImage(
                                  imageUrl: userData!['image'],
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    radius: 23,
                                    backgroundImage: imageProvider,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    w10,
                    coloredText(text1: 'Hey ', text2: 'Buddy', fontSize: 22),
                    const Spacer(),
                    NotificationIcon(),
                    w5
                  ],
                ),
              ),

              // Body
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 156,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (value) {
                    setState(() {
                      pageIndex = value;
                    });
                  },
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return pages[index];
                  },
                  itemCount: 3,
                ),
              ),

              // Bottom Navigation bar
              SafeArea(
                child: Container(
                  width: double.infinity,
                  height: 60,
                  color: appBarColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            changePage(0);
                          },
                          icon: ImageIcon(
                              const AssetImage('assets/icons/home.png'),
                              color: pageIndex == 0 ? neonBlue : white)),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AllVideos(),
                            ));
                          },
                          icon: ImageIcon(
                              const AssetImage('assets/icons/video.png'),
                              color: white)),
                      IconButton(
                          onPressed: addPosts,
                          icon: const Icon(
                            Icons.add_circle_outline_rounded,
                            color: white,
                            size: 40,
                          )),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('userData')
                              .doc(myUid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Image.asset(
                                'assets/icons/chat.png',
                                color: pageIndex == 1 ? neonBlue : white,
                                width: 30,
                              );
                            }
                            final data =
                                snapshot.data!.data()!['chatNotification'];

                            return Badge(
                              label:
                                  Text(data.keys.length > 0 ? '${data.keys.length}' : ''),
                              backgroundColor: data.keys.length < 1
                                  ? Colors.transparent
                                  : Colors.red,
                              child: IconButton(
                                  onPressed: () {
                                    changePage(1);
                                  },
                                  icon: ImageIcon(
                                      const AssetImage('assets/icons/chat.png'),
                                      color:
                                          pageIndex == 1 ? neonBlue : white)),
                            );
                          }),
                      IconButton(
                          onPressed: () {
                            changePage(2);
                          },
                          icon: ImageIcon(
                              const AssetImage('assets/icons/friend.png'),
                              color: pageIndex == 2 ? neonBlue : white)),
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
