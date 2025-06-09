import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colored_text.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/Functions/time_and_date.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:uuid/uuid.dart';

class PostUploadScreen extends StatefulWidget {
  const PostUploadScreen({super.key});

  @override
  State<PostUploadScreen> createState() => _PostUploadScreenState();
}

class _PostUploadScreenState extends State<PostUploadScreen> {
  // For images
  List<File> images = [];
  int currentIndex = 0;
  late PageController pageController;
  late ScrollController scrollController;

  // For content
  late TextEditingController textController;

  // For uploading
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    pageController = PageController();
    textController = TextEditingController();
  }

  void pickImages() async {
    List<XFile> pickedImages = await ImagePicker().pickMultiImage(
        maxWidth: 5000, maxHeight: 5000, imageQuality: 60, limit: 10);
    if (pickedImages.isNotEmpty) {
      for (XFile x in pickedImages) {
        images.add(File(x.path));
      }
      pageController.animateToPage(images.length - 1,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      scrollController.animateTo((images.length - 1) * 60 + 60,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
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
      images.insert(index, File(croppedImage.path));
      setState(() {});
    }
  }

  void upload() async {
    try {
      if (textController.text.isEmpty && images.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('A image or text content is necessary')));
        }
      } else {
        setState(() {
          isUploading = true;
        });

        List downloadUrl = [];

        final dt = dateTime();

        final docId = const Uuid().v4();
        for (int x = 0; x < images.length; x++) {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('post')
              .child('$docId-$x.jpg');
          await storageRef.putFile(images[x]);
          final url = await storageRef.getDownloadURL();
          downloadUrl.add(url);
        }
        await FirebaseFirestore.instance.collection('posts').doc(docId).set({
          'comment': [],
          'content': textController.text.isEmpty ? '' : textController.text,
          'date': dt[2],
          'dislike': [],
          'like': [],
          'postAt': dt[1],
          'postNo': '${Timestamp.now()}',
          'postUrl': downloadUrl,
          'share': [],
          'userId': FirebaseAuth.instance.currentUser!.uid
        });
        setState(() {
          isUploading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Post successfully uploaded')));
          Navigator.of(context).pop();
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(behavior: SnackBarBehavior.floating, content: Text('$e')));
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    textController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  coloredText(text1: 'Upload ', text2: 'Post', fontSize: 22),
                  const Spacer(),
                  InkWell(
                    onTap: upload,
                    child: Container(
                      width: 75,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: neonBlue,
                      ),
                      child: Center(
                        child: isUploading
                            ? const CircularProgressIndicator()
                            : StrokeText(
                                text: 'Upload',
                                textStyle:
                                    jotiOne(color: neonGreen, fontSize: 18),
                              ),
                      ),
                    ),
                  ),
                  w10,
                ],
              ),
            ),
            Row(
              children: [
                const Spacer(),
                if (images.isNotEmpty)
                  IconButton(
                      onPressed: () {
                        cropImage(images[currentIndex]);
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
                      if (scrollController.position.atEdge) {
                        scrollController.animateTo(
                          value * 60,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      } else {
                        scrollController.animateTo(
                          value * 60,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    });
                  },
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 20),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 400,
                        child: InteractiveViewer(
                          child: Image.file(
                            images[index],
                            fit: BoxFit.contain,
                          ),
                        )),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (images != [])
                      Row(
                        children: images
                            .map(
                              (e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: InkWell(
                                  onTap: () {
                                    changePage(images.indexOf(e));
                                  },
                                  child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          color:
                                              currentIndex == images.indexOf(e)
                                                  ? Colors.black
                                                  : container,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Stack(
                                        children: [
                                          Center(
                                              child: Image.file(
                                            e,
                                            fit: BoxFit.fitWidth,
                                            height: 55,
                                          )),
                                          Positioned(
                                              top: -10,
                                              right: -10,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      images.remove(e);
                                                    });
                                                  },
                                                  icon: const ImageIcon(
                                                    AssetImage(
                                                        'assets/icons/cross.png'),
                                                    color: white,
                                                  ))),
                                        ],
                                      )),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: InkWell(
                        onTap: pickImages,
                        child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                color: container,
                                borderRadius: BorderRadius.circular(5)),
                            child: const Icon(
                              Icons.add,
                              size: 35,
                              color: white,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 150),
                child: TextField(
                  controller: textController,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: textField,
                    hintText: 'Write something...',
                    focusColor: bgColor,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
