import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/debug_print.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/widgets/image_full_screen_view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({super.key, required this.images, required this.i});
  final List images;
  final int i;

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late FocusNode textFieldFocusNode;
  late List images;
  int currentIndex = 0;
  late PageController pageController;

  late ItemPositionsListener itemPositionsListener;
  late ItemScrollController itemScrollController;
  bool isSendingImages = false;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.i);
    pageController = PageController();

    itemPositionsListener = ItemPositionsListener.create();
    itemPositionsListener.itemPositions.addListener(() {});

    itemScrollController = ItemScrollController();
    images = widget.images;
  }

  void changePage(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void dispose() {
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
                      Navigator.of(context).pop();
                    },
                    icon: const ImageIcon(
                      AssetImage('assets/icons/back_arrow.png'),
                      color: neonGreen,
                    )),
                const Spacer(),
              ],
            ),
          ),
          if (widget.images.length > 1)
            Row(
              children: [
                const Spacer(),
                Text(
                  '${currentIndex + 1}',
                  style: jotiOne(color: neonGreen, fontSize: 25),
                ),
                Text(
                  '/',
                  style: jotiOne(color: neonBlue, fontSize: 25),
                ),
                Text(
                  '${widget.images.length}',
                  style: jotiOne(color: neonGreen, fontSize: 25),
                ),
                w20
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
                    debugprint(currentImage);
                    bool imageVisible = currentImage.itemLeadingEdge >= 0 &&
                        currentImage.itemTrailingEdge <= 1;
                    if (!imageVisible) {
                      itemScrollController.scrollTo(
                          alignment: (firstImage.index == currentIndex) ? 1 : 0,
                          index: currentImage.index,
                          duration: Duration(milliseconds: 300));
                    }
                  }
                },
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 20),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ImageFullScreenView(images: images, i: currentIndex),
                    )),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      height: 400,
                      child: InteractiveViewer(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: CachedNetworkImage(
                          imageUrl: widget.images[index],
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              width: 25,
                              height: 20,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      )),
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(
            height: 70,
            child: ScrollablePositionedList.builder(
              itemCount: images.length,
              itemPositionsListener: itemPositionsListener,
              itemScrollController: itemScrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: InkWell(
                    onTap: () {
                      changePage(images.indexOf(images[currentIndex]));
                    },
                    child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            color: currentIndex == images.indexOf(images[index])
                                ? neonGreen
                                : container,
                            borderRadius: BorderRadius.circular(5)),
                        child: Stack(
                          children: [
                            Center(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Hero(
                                  tag: images[index],
                                  child: CachedNetworkImage(
                                    imageUrl: images[index],
                                    placeholder: (context, url) => const Center(
                                      child: SizedBox(
                                        width: 25,
                                        height: 20,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  )),
                            )),
                          ],
                        )),
                  ),
                );
              },
            ),
          ),
          h10
        ],
      )),
    );
  }
}
