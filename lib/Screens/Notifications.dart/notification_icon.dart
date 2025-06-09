import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/Screens/Notifications.dart/user_notifications.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('userData')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final loadedData = snapshot.data!.data()!;
          List notification = loadedData['notification'];
          int length = notification.length;
          for (int x = 0; x < notification.length; x++) {
            if (notification[x]['seen'] == true &&
                !(notification[x]['type'] == 'Friend Request Sent')) {
              length--;
            }
          }
          return Badge(
            offset: Offset(-5, 1),
            textStyle: roboto(fontSize: 10, fontWeight: FontWeight.bold),
            padding: EdgeInsets.zero,
            backgroundColor: length == 0
                ? Colors.transparent
                : const Color.fromARGB(255, 255, 0, 0),
            label: length != 0 ? Text('$length') : null,
            child: IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return UserNotifications();
                }));
              },
              icon: Image.asset(
                'assets/icons/notification.png',
                width: 25,
                height: 25,
              ),
            ),
          );
        });
  }
}
