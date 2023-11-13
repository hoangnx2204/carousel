import 'package:flutter/widgets.dart';
import 'package:hello/carousel_item.dart';

class AnimatedCarousel extends StatefulWidget {
  const AnimatedCarousel({super.key, this.height});
  final double? height;

  @override
  State<AnimatedCarousel> createState() => _AnimatedCarouselState();
}

class _AnimatedCarouselState extends State<AnimatedCarousel>
    with SingleTickerProviderStateMixin {
  final scrollController = ScrollController();
  final scrollController2 = ScrollController();
  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset != scrollController2.offset) {
        scrollController2.jumpTo(scrollController.offset);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    scrollController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ListView.builder(
          clipBehavior: Clip.none,
          controller: scrollController,
          itemCount: 30,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return CarouselItem(
              label: index.toString(),
            );
          },
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 90,
          bottom: -90,
          child: FocusScope(
            canRequestFocus: false,
            skipTraversal: true,
            child: ListView.builder(
              controller: scrollController2,
              itemCount: 30,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return CarouselItem(
                  label: index.toString(),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
