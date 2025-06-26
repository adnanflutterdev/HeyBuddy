import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/Functions/send_notification.dart';
import 'package:heybuddy/Functions/time_and_date.dart';
import 'package:heybuddy/Notification/user_notifications.dart';

class Users extends StatelessWidget {
  const Users({super.key});

  void sendFriendRequest(
      {required String fToken,
      required String name,
      required String userId,
      required String myUid,
      required String imageUrl}) async {
    await FirebaseFirestore.instance.collection('userData').doc(myUid).update({
      'yourRequest': FieldValue.arrayUnion([userId])
    });

    final dt = dateTime();

    await FirebaseFirestore.instance.collection('userData').doc(userId).update({
      'notification': FieldValue.arrayUnion([
        {
          'time': dt[1],
          'date': dt[2],
          'requestUid': myUid,
          'type': 'Friend Request Sent',
          'data': 'Hi, accept my friend request',
          'seen': false,
        }
      ]),
      'otherRequest': FieldValue.arrayUnion([myUid])
    });

    await sendNotification(
        myUid: myUid,
        fToken: fToken,
        name: name,
        imageUrl: imageUrl,
        body: 'Has sent you friend request.');
  }

  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('userData')
            .doc(myUid)
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshots.hasData) {
            return Center(
              child: Text(
                'No Data Found',
                style: roboto(fontSize: 18, color: white),
              ),
            );
          }
          final myData = snapshots.data!.data()!;
          String myName = myData['name'];
          List keys = myData['friendList'].keys.toList();

          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('userData')
                .orderBy('name')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('No Data Found'),
                );
              }
              final users = snapshot.data!.docs;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return myUid != users[index].id &&
                          !keys.contains(users[index].id)
                      ? StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('userData')
                              .doc(users[index].id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: container,
                                  ),
                                  child: const Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                            final userData = snapshot.data!.data();
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: container),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 2),
                                  child: Row(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: userData!['image'],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          backgroundImage: imageProvider,
                                        ),
                                      ),
                                      w10,
                                      Text(
                                        userData['name'],
                                        style:
                                            roboto(fontSize: 15, color: white),
                                      ),
                                      const Spacer(),
                                      !myData['otherRequest']
                                              .contains(users[index].id)
                                          ? IconButton(
                                              onPressed: () {
                                                myData['yourRequest'].contains(
                                                        users[index].id)
                                                    ? null
                                                    : sendFriendRequest(
                                                        fToken:
                                                            userData['token'],
                                                        name: myName,
                                                        myUid: myUid,
                                                        userId: users[index].id,
                                                        imageUrl:
                                                            myData['image']);
                                              },
                                              icon: userData['otherRequest']
                                                      .contains(myUid)
                                                  ? const Icon(
                                                      Icons.check,
                                                      size: 20,
                                                      color: neonGreen,
                                                    )
                                                  : const ImageIcon(
                                                      AssetImage(
                                                          'assets/icons/add_friend.png'),
                                                      color: white,
                                                      size: 20,
                                                    ))
                                          : TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserNotifications(),
                                                ));
                                              },
                                              child: Text(
                                                'Accept',
                                                style: roboto(
                                                    fontSize: 15,
                                                    color: neonGreen),
                                              ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Container();
                },
              );
            },
          );
        });
  }
}
