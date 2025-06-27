import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/debug_print.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Functions/decrypter.dart';
import 'package:heybuddy/Provider/friend_provider.dart';
import 'package:heybuddy/Screens/Chat/chat_screen.dart';
import 'package:my_progress_bar/loaders.dart';

class Chat extends ConsumerStatefulWidget {
  const Chat({super.key});

  @override
  ConsumerState<Chat> createState() => _ChatState();
}

class _ChatState extends ConsumerState<Chat> {
  String myUid = FirebaseAuth.instance.currentUser!.uid;
  late Future<Map> friends;
  late FocusNode focusNode;
  List friendsData = [];
  Map searchedFriends = {};

  Future<Map> loadFriends() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('userData')
        .doc(myUid)
        .get();
    if (snapshot.exists) {
      Map friendList = snapshot.get('friendList');
      getFriendData(allFriends: friendList.keys.toList());
      return friendList;
    }
    return {};
  }

  void getFriendData({required List allFriends}) async {
    for (final x in allFriends) {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('userData').doc(x).get();
      friendsData.add({'uid': x, 'name': snapshot.get('name')});
    }
  }

  @override
  void initState() {
    super.initState();
    friends = loadFriends();
    focusNode = FocusNode();
  }

  void searchFriend(String str) async {
    searchedFriends = {};
    if (str != '') {
      final allFriends = await friends;
      str = str.trim().toLowerCase();
      for (Map x in friendsData) {
        if (x['name'].toString().toLowerCase().contains(str)) {
          searchedFriends.addAll({x['uid']: allFriends[x['uid']]});
        }
      }
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final friendRef = ref.watch(friendProvider.notifier);
    return Column(
      children: [
        //
        // TextField for search friends.
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            focusNode: focusNode,
            onChanged: (value) {
              searchFriend(value);
              setState(() {});
            },
            decoration: InputDecoration(
                hintText: 'Search Friends',
                hintStyle: TextStyle(fontSize: 12, color: bgColor),
                filled: true,
                fillColor: textField,
                contentPadding: EdgeInsets.all(10),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                border: OutlineInputBorder()),
          ),
        ),

        // Vertical space
        h15,
        FutureBuilder(
          future: friends,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: RotatingCirclesLoader(),
              );
            }
            if (snapshot.hasError) {
              return Text('No friends');
            }
            final allFriends = snapshot.data!;
            List fUids = searchedFriends.isEmpty
                ? allFriends.keys.toList()
                : searchedFriends.keys.toList();

            return Expanded(
              child: ListView.builder(
                itemCount: searchedFriends.isEmpty
                    ? fUids.length :searchedFriends.length,
                    
                itemBuilder: (context, index) {
                  final fUid = fUids[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      color: container,
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('userData')
                              .doc(fUid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            }
                            final friendData = snapshot.data!.data()!;
                            String chatId = allFriends[fUid];
                            return ListTile(
                              onTap: () {
                                friendRef.updateFriend(fUid, friendData);

                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    chatId: chatId,
                                  ),
                                ));
                              },
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 3),
                              trailing: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('userData')
                                      .doc(myUid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        width: 10,
                                      );
                                    }
                                    Map badge = snapshot.data!
                                        .data()!['chatNotification'];
                                    bool hasNotificaton =
                                        badge.keys.contains(fUid);
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Badge(
                                          backgroundColor: hasNotificaton
                                              ? Colors.red
                                              : Colors.transparent,
                                          label: Text(hasNotificaton
                                              ? '${badge[fUid].length}'
                                              : '')),
                                    );
                                  }),
                              leading: friendData['image'] != ''
                                  ? CachedNetworkImage(
                                      imageUrl: friendData['image'],
                                      placeholder: (context, url) =>
                                          CircleAvatar(
                                        radius: 25,
                                      ),
                                      imageBuilder: (context, imageProvider) {
                                        return CircleAvatar(
                                          radius: 25,
                                          backgroundImage: imageProvider,
                                        );
                                      },
                                    )
                                  : Image.asset('assets/icons/heyBuddy.png'),
                              title: Text(
                                friendData['name'],
                                style: TextStyle(
                                    color: neonGreen,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('userChats')
                                    .doc(allFriends[fUid])
                                    .collection(myUid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox(
                                      width: 70,
                                      child: JumpingCirclesLoader(
                                        ballRadius: 5,
                                      ),
                                    );
                                  }
                                  if (snapshot.hasError && !snapshot.hasData) {
                                    return Text(' ');
                                  }
                                  final chat = snapshot.data!.docs;
                                  return Text(
                                    chat.isEmpty
                                        ? ''
                                        : '${chat.last['userId'] == myUid ? 'You' : friendData['name']}${chat.last['type'] == 'text reply' || chat.last['type'] == 'image reply' ? ' replied: ' : ': '}'
                                            '${chat.last['type'] == 'text' ? decrypter(chat.last['message']) : chat.last['type'] == 'text reply' || chat.last['type'] == 'image reply' ? decrypter(chat.last['replied message']) : '📷'}',
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: white,
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis),
                                  );
                                },
                              ),
                            );
                          }),
                    ),
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}
