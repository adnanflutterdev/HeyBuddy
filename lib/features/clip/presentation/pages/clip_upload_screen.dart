import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/model/post_and_clip.dart';
import 'package:hey_buddy/core/model/media_meta.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/riverpod/upload_progress_provider.dart';
import 'package:hey_buddy/core/utils/file_uploader.dart';
import 'package:hey_buddy/core/utils/messenger.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/core/widgets/custom_app_bar.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';
import 'package:hey_buddy/features/clip/data/models/clip_model.dart';
import 'package:hey_buddy/features/clip/presentation/riverpod/clip_provider.dart';
import 'package:hey_buddy/features/post/presentation/riverpod/post_provider.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/my_data_provider.dart';
import 'package:hey_buddy/features/clip/presentation/widgets/video_preview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class ClipUploadScreen extends StatefulWidget {
  const ClipUploadScreen({super.key});

  @override
  State<ClipUploadScreen> createState() => _ClipUploadScreenState();
}

class _ClipUploadScreenState extends State<ClipUploadScreen> {
  File? _video;
  VideoPlayerController? _videoPlayerController;
  final TextEditingController _contentController = .new();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void pickVideo() async {
    final pickedVideo = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 2),
    );

    if (pickedVideo != null) {
      await _videoPlayerController?.dispose();
      _video = File(pickedVideo.path);
      _videoPlayerController = VideoPlayerController.file(_video!)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  void removeImage() {
    _video = null;
    setState(() {});
  }

  void uploadPost(WidgetRef ref) async {
    String text = _contentController.text.trim();
    if (_video != null) {
      String videoId = const Uuid().v4();
      UserData? user = ref.read(myDataProvider).value;
      if (user == null) {
        if (mounted) {
          showMessenger(
            context,
            result: Result.failure('Failed to fetch your data'),
          );
        }
        return;
      }
      MediaMeta? video;
      if (_video != null) {
        String uid = ref.read(uidProvider);
        String name = const Uuid().v4();
        MediaMeta? uploadedVideo = await FileUploader.uploadVideo(
          ref: ref,
          video: _video!,
          name: name,
          folder: 'clip/$uid/$videoId',
        );
        if (uploadedVideo == null && mounted) {
          showMessenger(
            context,
            result: Result.failure('Failed to upload video'),
          );
          ref.read(uploadProgressProvider.notifier).updateProgress(0);
          return;
        } else {
          video = uploadedVideo;
        }
      }
      MediaModel? media = MediaModel(data: video!, type: .video);

      ClipContentModel content = ClipContentModel(
        text: text,
        media: media,
        tags: [],
      );
      ClipModel clip = ClipModel.setNewPost(
        id: videoId,
        userId: user.uid,
        content: content,
      );
      Result result = await ref
          .read(createClipProvider.notifier)
          .uploadClip(clip);
      if (mounted) {
        showMessenger(context, result: result);
        ref.read(uploadProgressProvider.notifier).updateProgress(0);
        Future.delayed(const Duration(milliseconds: 200), () {
          AppNavigator.pop();
        });
      }
    } else {
      showMessenger(context, result: Result.failure('A video is required'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: ('New', ' Post'),
        actions: [_buildUploadButton()],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.p16,
          child: Column(
            spacing: 10,
            children: [
              if (_video == null || _videoPlayerController == null)
                Expanded(
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      IconButton(
                        onPressed: pickVideo,
                        icon: const Icon(Icons.add, size: 30),
                      ),
                      const Text('Pick a video', textAlign: .center),
                    ],
                  ),
                )
              else
                Expanded(
                  child: Stack(
                    children: [_buildVideo(), _buildImageActionButtons()],
                  ),
                ),
              // _buildImagesPreview(),
              AppTextField(
                hintText: 'Write something',
                controller: _contentController,
                minLines: 1,
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return Consumer(
      builder: (context, ref, _) {
        final progress = ref.watch(uploadProgressProvider);
        final createPostRef = ref.watch(createPostProvider);

        if (createPostRef.isLoading || progress > 0) {
          return AppMeterialButton(text: '$progress %');
        }
        return AppMeterialButton(
          text: 'Upload',
          icon: Icons.upload,
          onPressed: () => uploadPost(ref),
        );
      },
    );
  }

  Widget _buildImageActionButtons() {
    return Positioned(
      top: 0,
      right: 0,
      child: Row(
        spacing: 10,
        mainAxisAlignment: .end,
        children: [
          AppMeterialButton(onPressed: pickVideo, icon: Icons.repeat_outlined),
          AppMeterialButton(onPressed: removeImage, icon: Icons.close),
        ],
      ),
    );
  }

  Widget _buildVideo() {
    return Center(child: VideoPreview(controller: _videoPlayerController!));
  }
}
