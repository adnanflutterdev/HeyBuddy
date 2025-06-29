import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/debug_print.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/Functions/send_notification.dart';
import 'package:heybuddy/Root/hey_buddy.dart';
import 'package:stroke_text/stroke_text.dart';

class FriendDetails extends StatelessWidget {
  const FriendDetails({
    super.key,
    required this.friendData,
    required this.chatUid,
    required this.fUid,
    required this.myUid,
  });
  final Map friendData;
  final String chatUid;
  final String myUid;
  final String fUid;

  @override
  Widget build(BuildContext context) {
    debugprint(chatUid);
    void deleteFriend() async {
      final fire = FirebaseFirestore.instance.collection('userData');
      //getting myData
      DocumentSnapshot snapshot1 = await fire.doc(myUid).get();
      DocumentSnapshot snapshot2 = await fire.doc(fUid).get();

      Map myFriendList = snapshot1.get('friendList');
      myFriendList.remove(fUid);
      Map friendsFriendList = snapshot2.get('friendList');
      friendsFriendList.remove(myUid);

      await fire.doc(myUid).update({'friendList': myFriendList});
      await fire.doc(fUid).update({'friendList': friendsFriendList});
      await FirebaseFirestore.instance
          .collection('userChats')
          .doc(chatUid)
          .delete();

      await sendNotification(
        myUid: myUid,
        fToken: friendData['token'],
        name: snapshot1.get('name'),
        imageUrl: snapshot1.get('image'),
        body: 'Has removed you from friend list',
      );
    }

    void deleteFriendDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Deleting Friend',
            style: roboto(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Deleting friend will remove this friend from your friend list and all of your chats will disappear.',
            style: roboto(fontSize: 12),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  deleteFriend();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Heybuddy(
                      i: 2,
                    ),
                  ));
                },
                child: StrokeText(
                  text: 'Delete',
                  strokeColor: container.withValues(alpha: .5),
                  textStyle: roboto(fontSize: 15, color: Colors.red),
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: StrokeText(
                  text: 'Cancel',
                  strokeColor: container.withValues(alpha: .5),
                  textStyle: roboto(fontSize: 15, color: neonBlue),
                ))
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Appbar
            //
            Container(
              width: double.infinity,
              height: 60,
              color: appBarColor,
              child: Row(
                children: [
                  IconButton(
                      tooltip: 'Back',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: neonGreen,
                      )),
                  w10,
                  Text(
                    friendData['name'],
                    style: roboto(
                        fontSize: 20,
                        color: neonBlue,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            h10,

            // Friend Image
            friendData['image'] != ''
                ? CachedNetworkImage(
                    imageUrl: friendData['image'],
                    placeholder: (context, url) => CircleAvatar(
                      radius: MediaQuery.of(context).size.width / 2 - 40,
                      backgroundColor: container,
                    ),
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: MediaQuery.of(context).size.width / 2 - 40,
                      backgroundImage: imageProvider,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset('assets/icons/heyBuddy.png'),
                  ),
            const Spacer(),

            // Delete friend
            //
            InkWell(
              onTap: deleteFriendDialog,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Delete Friend',
                      style: jotiOne(color: white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
