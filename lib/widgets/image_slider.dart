import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/widgets/image_viewer.dart';
import 'package:stroke_text/stroke_text.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key, required this.images});
  final List images;

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int index = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 230,
      child: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            onPageChanged: (value) {
              setState(() {
                index = value;
              });
            },
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ImageViewer(
                    images: widget.images,
                    i: index,
                  ),
                )),
                child: Hero(
                  tag: widget.images[index],
                  child: CachedNetworkImage(
                    imageUrl: widget.images[index],
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => const Center(
                        child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator())),
                  ),
                ),
              ),
            ),
          ),
          if (widget.images.length != 1)
            Positioned(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StrokeText(
                  text: '${index + 1}',
                  textStyle: roboto(fontSize: 15, color: neonGreen),
                ),
                StrokeText(
                  text: '/',
                  textStyle: roboto(fontSize: 15, color: neonBlue),
                ),
                StrokeText(
                  text: '${widget.images.length}',
                  textStyle: roboto(fontSize: 15, color: neonGreen),
                ),
                w10
              ],
            ))
        ],
      ),
    );
  }
}
