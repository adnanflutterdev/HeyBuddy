import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/debug_print.dart';
import 'package:heybuddy/Provider/chats_provider.dart';
import 'package:heybuddy/widgets/image_viewer.dart';

class ImageBubble extends ConsumerStatefulWidget {
  const ImageBubble(
      {super.key,
      required this.images,
      required this.chatIndex,
      required this.message,
      required this.textFieldFocusNode});
  final List images;
  final String message;
  final int chatIndex;
  final FocusNode textFieldFocusNode;

  @override
  ConsumerState<ImageBubble> createState() => _ImageBubbleState();
}

class _ImageBubbleState extends ConsumerState<ImageBubble> {
  int currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    // chat selection providers and notifiers
    final chatNotifier = ref.watch(chatSelectionProvider.notifier);
    final chatProvider = ref.watch(chatSelectionProvider);

    // long press notifier
    final longPressedNotifier = ref.watch(longPressedProvider.notifier);
    final longPressed = ref.watch(longPressedProvider);
// copy providers
    final copyNotifier = ref.watch(chatCopyProvider.notifier);


    void chatSelection() {
      widget.textFieldFocusNode.unfocus();
      if (longPressed) {
        if (chatProvider.contains(widget.chatIndex)) {
          if (chatProvider.length == 1) {
            chatNotifier.clear();
            copyNotifier.clear();
            longPressedNotifier.stop();
          } else {
            chatNotifier.removeChat(widget.chatIndex);
            copyNotifier.removeText(widget.message);
          }
        } else {
          chatNotifier.addChat(widget.chatIndex);
          copyNotifier.addText(widget.message);
        }
      } else {
        longPressedNotifier.start();
        chatNotifier.addChat(widget.chatIndex);
        copyNotifier.addText(widget.message);
      }
    }

    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: widget.images.length,
            onPageChanged: (value) {
              currentIndex = value;
              setState(() {});
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: chatSelection,
                onTap: () {
                  widget.textFieldFocusNode.unfocus();
                  if (longPressed) {
                    if (chatProvider.contains(widget.chatIndex)) {
                      if (chatProvider.length == 1) {
                        chatNotifier.clear();
                        copyNotifier.clear();
                        longPressedNotifier.stop();
                      } else {
                        chatNotifier.removeChat(widget.chatIndex);
                        copyNotifier.removeText(widget.message);
                      }
                    } else {
                      chatNotifier.addChat(widget.chatIndex);
                      copyNotifier.addText(widget.message);
                    }
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ImageViewer(images: widget.images, i: index),
                    ));
                  }
                },
                child: CachedNetworkImage(
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                  imageUrl: widget.images[index],
                  placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                    color: white,
                  )),
                ),
              );
            },
          ),
          if (currentIndex != 0)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () {
                    pageController.animateToPage(currentIndex - 1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                  icon: Icon(Icons.arrow_back_ios_new_rounded, color: white)),
            ),
          if (currentIndex < widget.images.length - 1)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: () {
                    pageController.animateToPage(currentIndex + 1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                  icon: Icon(Icons.arrow_forward_ios_rounded, color: white)),
            ),
          if (widget.images.length > 1)
            Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                      color: white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      '${currentIndex + 1}/${widget.images.length}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
