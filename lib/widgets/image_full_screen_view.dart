import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';

class ImageFullScreenView extends StatefulWidget {
  const ImageFullScreenView({super.key, required this.images, required this.i});
  final List images;
  final int i;

  @override
  State<ImageFullScreenView> createState() => _ImageFullScreenViewState();
}

class _ImageFullScreenViewState extends State<ImageFullScreenView> {
  int index = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.i);
    index = widget.i;
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
                Text(
                  '${index + 1}',
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
          ),
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  index = value;
                });
              },
              itemCount: widget.images.length,
              itemBuilder: (context, index) => InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 10,
                  clipBehavior: Clip.hardEdge,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Hero(
                        tag: widget.images[index],
                        child: CachedNetworkImage(
                          imageUrl: widget.images[index],
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              width: 25,
                              height: 20,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )),
                  )),
            ),
          ),
          h10,
        ],
      )),
    );
  }
}
