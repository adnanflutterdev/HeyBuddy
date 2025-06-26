import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colored_text.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/debug_print.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/Root/home_page.dart';
import 'package:heybuddy/Screens/Posts/my_posts.dart';
import 'package:heybuddy/Screens/Videos/videos.dart';
import 'package:heybuddy/widgets/image_viewer.dart';
import 'package:stroke_text/stroke_text.dart';

class MyDetails extends StatelessWidget {
  const MyDetails({super.key, required this.myDetails});
  final Map myDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // app bar
          Container(
            width: double.infinity,
            height: 60,
            color: appBarColor,
            child: Row(
              children: [
                w10,
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const ImageIcon(
                      AssetImage('assets/icons/back_arrow.png'),
                      color: neonGreen,
                    )),
                coloredText(text1: 'My ', text2: 'Details', fontSize: 22),
                const Spacer(),
                w10,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: SizedBox(
              width: double.infinity,
              height: 235,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => myDetails['coverImg'] != ''
                          ? Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ImageViewer(
                                images: [myDetails['coverImg']],
                                i: 0,
                              ),
                            ))
                          : null,
                      child: myDetails['coverImg'] != ''
                          ? Hero(
                              tag: myDetails['coverImg'],
                              child: CachedNetworkImage(
                                fit: BoxFit.fitHeight,
                                height: 190,
                                imageUrl: myDetails['coverImg'],
                                placeholder: (context, url) => const Center(
                                  child: SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            )
                          : Opacity(
                              opacity: 0.6,
                              child: Image.asset(
                                'assets/icons/heyBuddy.png',
                              )),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: MediaQuery.of(context).size.width / 2 - 60,
                      right: MediaQuery.of(context).size.width / 2 - 60,
                      child: myDetails['image'] != ''
                          ? CachedNetworkImage(
                              imageUrl: myDetails['image'],
                              placeholder: (context, url) => const Center(
                                child: SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: neonGreen, width: 2)),
                                child: InkWell(
                                  onTap: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => ImageViewer(
                                      images: [myDetails['image']],
                                      i: 0,
                                    ),
                                  )),
                                  child: Hero(
                                    tag: myDetails['image'],
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage: imageProvider,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Image.asset('assets/icons/heyBuddy.png'))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: StrokeText(
              text: 'Personal Details',
              textStyle: roboto(
                  fontSize: 20, color: neonBlue, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: container,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    StrokeText(
                      text: 'Name',
                      textStyle: roboto(fontSize: 15, color: neonGreen),
                    ),
                    Text(
                      myDetails['name'],
                      style: roboto(fontSize: 15, color: white),
                    ),
                    h10,
                    // Email
                    StrokeText(
                      text: 'Email',
                      textStyle: roboto(fontSize: 15, color: neonGreen),
                    ),
                    Text(
                      '${FirebaseAuth.instance.currentUser!.email}',
                      style: roboto(fontSize: 15, color: white),
                    ),
                    h10,
                    // DOB and Gender
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StrokeText(
                              text: 'DOB',
                              textStyle: roboto(fontSize: 15, color: neonGreen),
                            ),
                            Text(
                              myDetails['DOB'],
                              style: roboto(fontSize: 15, color: white),
                            ),
                          ],
                        ),
                        w20,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StrokeText(
                              text: 'Gender',
                              textStyle: roboto(fontSize: 15, color: neonGreen),
                            ),
                            Text(
                              myDetails['gender'],
                              style: roboto(fontSize: 15, color: white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          h15,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MyPosts(),
                ));
              },
              child: StrokeText(
                text: 'My Posts',
                textStyle: roboto(
                    fontSize: 20, color: neonBlue, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Videos(
                    videos: [],
                  ),
                ));
              },
              child: StrokeText(
                text: 'My Videos',
                textStyle: roboto(
                    fontSize: 20, color: neonBlue, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const Spacer(),
          Center(
            child: InkWell(
              onTap: () async {
                final uid = FirebaseAuth.instance.currentUser!.uid;
                debugprint(uid);
                await FirebaseFirestore.instance
                    .collection('userData')
                    .doc(uid)
                    .update({'token': ''});
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) {
                  return;
                }
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('You logged out')));
              },
              child: Container(
                width: 120,
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: StrokeText(
                  text: 'Logout',
                  textStyle: jotiOne(color: neonBlue, fontSize: 25),
                )),
              ),
            ),
          ),
          h10
        ],
      )),
    );
  }
}
