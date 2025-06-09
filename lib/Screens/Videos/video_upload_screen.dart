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
import 'package:heybuddy/MyVideoPlayer/my_video_player.dart';
import 'package:heybuddy/MyVideoPlayer/my_video_player_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:uuid/uuid.dart';

class VideoUploadScreen extends StatefulWidget {
  const VideoUploadScreen({super.key});

  @override
  State<VideoUploadScreen> createState() => _PostUploadScreenState();
}

class _PostUploadScreenState extends State<VideoUploadScreen> {
  File? video;
  String progress = '';
  UploadTask? uploadTask;
  bool isUploading = false;
  late String downloadUrl;
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  void pickVideo() async {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      video = File(pickedVideo.path);
      setState(() {});
    }
  }

  void upload() async {
    if (video != null) {
      try {
        DateTime dt = DateTime.now();
        // date
        final day = dt.day < 10 ? '0${dt.day}' : '${dt.day}';
        final month = dt.month < 10 ? '0${dt.month}' : '${dt.month}';
        // time
        final minute = dt.minute < 10 ? '0${dt.minute}' : '${dt.minute}';
        final hr = dt.hour > 12 ? dt.hour - 12 : dt.hour;
        final hour = hr < 10 ? '0$hr' : '$hr';
        final meridian = dt.hour > 11 ? 'PM' : 'AM';

        // for uploading on firebase
        final date = '$day/$month/${dt.year}';
        final postAt = '$hour:$minute $meridian';
        final docId = const Uuid().v4();

        setState(() {
          isUploading = true;
        });
        final storageRef =
            FirebaseStorage.instance.ref().child('video').child('$docId.mp4');
        uploadTask = storageRef.putFile(video!);
        uploadTask!.snapshotEvents.listen((snapshot) {
          setState(() {
            progress =
                '${(snapshot.bytesTransferred / snapshot.totalBytes * 100).toInt()}%';
          });
        });
        await uploadTask!.whenComplete(() async {
          downloadUrl = await storageRef.getDownloadURL();

          await FirebaseFirestore.instance.collection('videos').doc(docId).set({
            'comment': [],
            'content': textController.text.isEmpty ? '' : textController.text,
            'date': date,
            'dislike': [],
            'like': [],
            'postAt': postAt,
            'videoNo': '${Timestamp.now()}',
            'videoUrl': downloadUrl,
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
        });
      } on FirebaseException catch (_) {
        setState(() {
          isUploading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Upload failed')));
        }
      }
    }
  }

  @override
  void dispose() {
    textController.dispose();
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
                  coloredText(text1: 'Upload ', text2: 'Video', fontSize: 22),
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
                            ? StrokeText(
                                text: progress,
                                textStyle:
                                    jotiOne(color: neonGreen, fontSize: 18),
                              )
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
            const Spacer(),
            if (video != null)
              MyVideoPlayer(
                  myVideoPlayerController:
                      MyVideoPlayerController.file(source: video!)),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: InkWell(
                onTap: pickVideo,
                child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: container,
                        borderRadius: BorderRadius.circular(5)),
                    child: Icon(
                      video != null ? Icons.swap_horiz : Icons.add,
                      size: 35,
                      color: white,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: textController,
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
          ],
        ),
      ),
    );
  }
}
