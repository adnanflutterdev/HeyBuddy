import 'dart:async';
import 'dart:io';
import 'package:camera_image_picker/camera_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heybuddy/Consts/colored_text.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/Functions/encrypter.dart';
import 'package:heybuddy/Functions/send_notification.dart';
import 'package:heybuddy/Functions/time_and_date.dart';
import 'package:heybuddy/Provider/friend_provider.dart';
import 'package:heybuddy/main.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SendImage extends ConsumerStatefulWidget {
  const SendImage(
      {super.key,
      required this.myUid,
      required this.images,
      required this.chatId,
      required this.itemScrollController});
  final String myUid;
  final List<XFile> images;
  final String chatId;
  final ItemScrollController itemScrollController;

  @override
  ConsumerState<SendImage> createState() => _SendImageState();
}

class _SendImageState extends ConsumerState<SendImage> {
  int currentIndex = 0;
  bool isSendingImages = false;

  late List<XFile> images;
  late FocusNode textFieldFocusNode;
  late PageController pageController;
  late ItemScrollController itemScrollController;
  late TextEditingController textEditingController;
  late ItemPositionsListener itemPositionsListener;

  String myUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    images = widget.images;

    textFieldFocusNode = FocusNode();

    pageController = PageController();

    itemScrollController = ItemScrollController();

    textEditingController = TextEditingController();
    itemPositionsListener = ItemPositionsListener.create();
    itemPositionsListener.itemPositions.addListener(() {});
  }

  void pickImagesFromCamera() async {
    int index = images.length;
    List<XFile> pickedImages =
        await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CameraImagePicker(cameras: camera),
    ));
    if (pickedImages.isNotEmpty) {
      images.addAll(pickedImages);
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      itemScrollController.scrollTo(
          index: index, duration: Duration(milliseconds: 300));
      setState(() {});
    }
  }

  void pickImagesFromGallery() async {
    int index = images.length;
    List<XFile> pickedImages = await ImagePicker().pickMultiImage(
        maxWidth: 5000, maxHeight: 5000, imageQuality: 60, limit: 10);
    if (pickedImages.isNotEmpty) {
      images.addAll(pickedImages);

      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      itemScrollController.scrollTo(
          index: index, duration: Duration(milliseconds: 300));
      setState(() {});
    }
  }

  void changePage(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void cropImage(File image) async {
    final croppedImage =
        await ImageCropper.platform.cropImage(sourcePath: image.path);
    if (croppedImage != null) {
      int index = currentIndex;
      images.removeAt(index);
      images.insert(index, XFile(croppedImage.path));
      setState(() {});
    }
  }

  void sendImages({
    required String fToken,
    required String chatId,
    required String fUid,
    required int length,
    required String name,
    required String imageUrl,
  }) async {
    bool status = await InternetConnectionChecker.instance.hasConnection;
    if (status) {
      if (images.isNotEmpty) {
        setState(() {
          isSendingImages = true;
        });
        final fire =
            FirebaseFirestore.instance.collection('userChats').doc(chatId);
        String docId = '${Timestamp.now().microsecondsSinceEpoch}';
        List dt = dateTime();

        DocumentSnapshot snapshot = await fire.get();
        final isAcvite = snapshot.get(fUid);
        if (!isAcvite) {
          sendNotification(
              myUid: myUid,
              fToken: fToken,
              name: name,
              imageUrl: imageUrl,
              body: 'image(${images.length}) 📷');
        }
        List imagesUrl = [];
        for (int x = 0; x < images.length; x++) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('chatImages')
              .child('$docId-$x.jpg');
          await storageRef.putFile(File(images[x].path));
          final url = await storageRef.getDownloadURL();
          imagesUrl.add(url);
        }
        // Adding in users chat
        await fire.collection(myUid).doc(docId).set({
          'second': dt[0],
          'time': dt[1],
          'date': dt[2],
          'edited': false,
          'message': textEditingController.text.isEmpty
              ? ''
              : encrypter(textEditingController.text),
          'seen': false,
          'type': 'images',
          'images': imagesUrl,
          'userId': myUid,
        });
        // Adding in friends chat
        await fire.collection(fUid).doc(docId).set({
          'second': dt[0],
          'time': dt[1],
          'date': dt[2],
          'edited': false,
          'message': textEditingController.text.isEmpty
              ? ''
              : encrypter(textEditingController.text),
          'seen': false,
          'type': 'images',
          'images': imagesUrl,
          'userId': myUid,
        });
        if (!mounted) {
          return;
        }
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating, content: Text('Images sent')));
      } else {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Add atleast one image')));
      }
      widget.itemScrollController
          .scrollTo(index: length, duration: Duration(milliseconds: 300));
    } else {
      showSnackBar();
    }
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      'No Internet Connection. Please Connect To Active Internet Connection',
      style: TextStyle(color: Colors.red),
    )));
  }

  @override
  void dispose() {
    textEditingController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final friendRef = ref.watch(friendProvider);
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
                        FocusScope.of(context).unfocus();
                        Timer(const Duration(milliseconds: 300), () {
                          Navigator.of(context).pop();
                        });
                      },
                      icon: const ImageIcon(
                        AssetImage('assets/icons/back_arrow.png'),
                        color: neonGreen,
                      )),
                  coloredText(
                    text1: 'To ',
                    text2: friendRef.last['name'],
                    fontSize: 18,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const Spacer(),
                IconButton(
                    onPressed: pickImagesFromCamera,
                    icon: Badge(
                      label: Text('+'),
                      textColor: Colors.black,
                      textStyle:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      backgroundColor: white,
                      child: Icon(
                        Icons.photo_camera,
                        color: white,
                      ),
                    )),
                IconButton(
                    onPressed: pickImagesFromGallery,
                    icon: Badge(
                      label: Text('+'),
                      textColor: Colors.black,
                      textStyle:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      backgroundColor: white,
                      child: Icon(
                        Icons.photo,
                        color: white,
                      ),
                    )),
                if (images.isNotEmpty)
                  IconButton(
                      onPressed: () {
                        cropImage(File(images[currentIndex].path));
                      },
                      icon: const ImageIcon(
                        AssetImage('assets/icons/crop.png'),
                        color: white,
                      ))
              ],
            ),

            if (images != [])
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  onPageChanged: (value) {
                    setState(() {
                      currentIndex = value;
                    });
                    final firstImage =
                        itemPositionsListener.itemPositions.value.first;
                    final lastImage =
                        itemPositionsListener.itemPositions.value.last;
                    final currentImage = (firstImage.index == currentIndex)
                        ? firstImage
                        : (lastImage.index == currentIndex)
                            ? lastImage
                            : null;
                    if (currentImage != null) {
                      bool imageVisible = currentImage.itemLeadingEdge >= 0 &&
                          currentImage.itemTrailingEdge <= 1;
                      if (!imageVisible) {
                        itemScrollController.scrollTo(
                            alignment:
                                (firstImage.index == currentIndex) ? 1 : 0,
                            index: currentImage.index,
                            duration: Duration(milliseconds: 300));
                      }
                    }
                  },
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 20),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 400,
                        child: InteractiveViewer(
                          child: Image.file(
                            File(images[index].path),
                            fit: BoxFit.contain,
                          ),
                        )),
                  ),
                ),
              ),
            SizedBox(
              height: 70,
              child: Expanded(
                  child: ScrollablePositionedList.builder(
                itemCount: images.length,
                scrollDirection: Axis.horizontal,
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: InkWell(
                      onTap: () {
                        changePage(images.indexOf(images[index]));
                      },
                      child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              color:
                                  currentIndex == images.indexOf(images[index])
                                      ? neonGreen
                                      : container,
                              borderRadius: BorderRadius.circular(5)),
                          child: Stack(
                            children: [
                              Center(
                                  child: Image.file(
                                File(images[index].path),
                                height: 55,
                              )),
                              Positioned(
                                  top: -15,
                                  right: -15,
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          images.remove(images[index]);
                                          currentIndex = 0;
                                          pageController
                                              .jumpToPage(currentIndex);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.cancel,
                                        color: white,
                                        size: 20,
                                      ))),
                            ],
                          )),
                    ),
                  );
                },
              )),
            ),

            // TextField
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: white,
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 200),
                        child: TextField(
                          controller: textEditingController,
                          focusNode: textFieldFocusNode,
                          autofocus: false,
                          cursorColor: white,
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          style: roboto(fontSize: 16, color: white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: container,
                            hintText: 'Write here...',
                            hintStyle: roboto(fontSize: 14, color: white),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  w10,
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('userData')
                          .doc(widget.myUid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Image.asset(
                            'assets/icons/send.png',
                            width: 25,
                          );
                        }
                        final myData = snapshot.data!.data()!;
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('userChats')
                                .doc(widget.chatId)
                                .collection(myUid)
                                .snapshots(),
                            builder: (context, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return Image.asset(
                                  'assets/icons/send.png',
                                  width: 25,
                                );
                              }
                              final length = snap.data!.docs.length;
                              return GestureDetector(
                                onTap: () {
                                  sendImages(
                                      fToken: friendRef.last['token'],
                                      chatId: widget.chatId,
                                      fUid: friendRef.first,
                                      length: length,
                                      name: myData['name'],
                                      imageUrl: myData['image']);
                                },
                                child: isSendingImages
                                    ? CircularProgressIndicator()
                                    : Image.asset(
                                        'assets/icons/send.png',
                                        width: 25,
                                      ),
                              );
                            });
                      }),
                  w10
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
