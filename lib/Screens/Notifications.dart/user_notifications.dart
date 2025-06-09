import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/Functions/send_notification.dart';
import 'package:heybuddy/Functions/time_and_date.dart';
import 'package:stroke_text/stroke_text.dart';

class UserNotifications extends StatelessWidget {
  const UserNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    String myUid = FirebaseAuth.instance.currentUser!.uid;

    void acceptRequst({
      required String myUid,
      required String requestUid,
      required String fToken,
      required String name,
      required String imageUrl,
      required Map notification,
      // required int index,
    }) async {
      final dt = dateTime();
      final chatId = '$myUid+$requestUid';
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(myUid)
          .update({
        'notification': FieldValue.arrayRemove([notification]),
        'otherRequest': FieldValue.arrayRemove([requestUid]),
        'friendList': FieldValue.arrayUnion([
          {requestUid: chatId}
        ])
      });
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(requestUid)
          .update({
        'notification': FieldValue.arrayUnion([
          {
            'time': dt[1],
            'date': dt[2],
            'requestUid': myUid,
            'seen': false,
            'type': 'Friend Request Accepted',
            'data': 'Hey Buddy, I have accepted your friend request'
          }
        ]),
        'yourRequest': FieldValue.arrayRemove([myUid]),
        'friendList': FieldValue.arrayUnion([
          {myUid: '$myUid+$requestUid'}
        ])
      });
      await FirebaseFirestore.instance.collection('userChats').doc(chatId).set({
        '${myUid}LastIndex': -1,
        '${requestUid}LastIndex': -1,
        'media': [],
        'friendSince': '${dt[1]} ${dt[2]}',
        myUid: false,
        requestUid: false,
      });

      await sendNotification(
          myUid: myUid,
          fToken: fToken,
          name: name,
          imageUrl: imageUrl,
          body: 'Hey Buddy, I have accepted your friend request');
    }

    void deleteRequest(
        {required String myUid,
        required String requestUid,
        required String userToken,
        required String imageUrl,
        required String name,
        required List allNotifications,
        required int index}) async {
      final dt = dateTime();
      allNotifications.removeAt(index);
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(myUid)
          .update({
        'notification': allNotifications,
        'otherRequest': FieldValue.arrayRemove([requestUid])
      });
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(requestUid)
          .update({
        'notification': FieldValue.arrayUnion([
          {
            'time': dt[1],
            'date': dt[2],
            'requestUid': myUid,
            'seen': false,
            'type': 'Friend Request Rejected',
            'data': 'Has rejected your friend request'
          }
        ]),
        'yourRequest': FieldValue.arrayRemove([myUid])
      });

      sendNotification(
          myUid: myUid,
          fToken: userToken,
          name: name,
          imageUrl: imageUrl,
          body: 'Has rejected your friend request');
    }

    void clear(
        {required String myUid,
        required int index,
        required List allNotifications}) async {
      allNotifications.removeAt(index);
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(myUid)
          .update({
        'notification': allNotifications,
      });
    }

    void seen({required String myUid, required List allNotifications}) async {
      for (int x = allNotifications.length - 1; x >= 0; x--) {
        if (allNotifications[x]['seen'] == false) {
          allNotifications[x]['seen'] = true;
        } else {
          break;
        }
      }

      await FirebaseFirestore.instance
          .collection('userData')
          .doc(myUid)
          .update({'notification': allNotifications});
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
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
                  Text(
                    'Notifications',
                    style: jotiOne(color: neonBlue, fontSize: 22),
                  ),
                  const Spacer(),
                  w10,
                ],
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userData')
                    .doc(myUid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final myData = snapshot.data!.data()!;
                  List allNotifications = myData['notification'];
                  seen(myUid: myUid, allNotifications: allNotifications);
                  allNotifications = allNotifications.reversed.toList();
                  if (allNotifications.isEmpty) {
                    return Expanded(
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Notifications',
                            style: roboto(fontSize: 18, color: white),
                          ),
                        ],
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: allNotifications.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> notification =
                            allNotifications[index];
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('userData')
                                .doc(allNotifications[index]['requestUid'])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              final userData = snapshot.data!.data()!;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5),
                                child: Container(
                                  width: double.infinity,
                                  // height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: container,
                                  ),
                                  child: Row(
                                    children: [
                                      w10,
                                      CachedNetworkImage(
                                        imageUrl: userData['image'],
                                        placeholder: (context, url) =>
                                            CircleAvatar(
                                          radius: 20,
                                          backgroundColor: textField,
                                        ),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          radius: 20,
                                          backgroundImage: imageProvider,
                                        ),
                                      ),
                                      w10,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          StrokeText(
                                            text:
                                                userData['name'],
                                            textStyle: roboto(
                                                fontSize: 16, color: neonBlue),
                                          ),
                                          Container(
                                            width: (notification['type'] ==
                                                    'Friend Request Sent')
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    212
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    152,
                                            margin: EdgeInsets.all(1),
                                            child: StrokeText(
                                              text: notification['data'],
                                              overflow: TextOverflow.clip,
                                              textStyle: roboto(
                                                  fontSize: 14, color: white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Spacer(),

                                      // if Friend Request Sent
                                      if (notification['type'] ==
                                          'Friend Request Sent')
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                deleteRequest(
                                                    myUid: myUid,
                                                    requestUid: notification[
                                                        'requestUid'],
                                                    imageUrl: myData['image'],
                                                    name:
                                                        myData['name'],
                                                    userToken:
                                                        userData['token'],
                                                    index: index,
                                                    allNotifications:
                                                        allNotifications);
                                              },
                                              child: Container(
                                                width: 60,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Color(0xFFFF0000)),
                                                child: Center(
                                                  child: StrokeText(
                                                    text: 'Delete',
                                                    textStyle: roboto(
                                                        fontSize: 14,
                                                        color: white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                acceptRequst(
                                                  myUid: myUid,
                                                  requestUid: notification[
                                                      'requestUid'],
                                                  fToken: userData['token'],
                                                  imageUrl: myData['image'],
                                                  name:
                                                      '${myData['fName']} ${myData['lName']}',
                                                  notification: notification,
                                                  // index: index,
                                                );
                                              },
                                              child: Container(
                                                width: 60,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: neonGreen),
                                                child: Center(
                                                  child: StrokeText(
                                                    text: 'Accept',
                                                    textStyle: roboto(
                                                        fontSize: 14,
                                                        color: white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                      // if other type of notification

                                      if (notification['type'] !=
                                          'Friend Request Sent')
                                        InkWell(
                                          onTap: () {
                                            clear(
                                                myUid: myUid,
                                                index: index,
                                                allNotifications:
                                                    allNotifications);
                                          },
                                          child: Container(
                                            width: 60,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Color(0xFFFF0000)),
                                            child: Center(
                                              child: StrokeText(
                                                text: 'Clear',
                                                textStyle: roboto(
                                                    fontSize: 14, color: white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      w10
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
