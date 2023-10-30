import 'dart:math';

import 'package:flutter/services.dart';
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
  final itemCount = 20;
  final scrollController = ScrollController();

  late final List<FocusNode> focusNodes = List.generate(
    itemCount,
    (index) => FocusNode(debugLabel: index.toString()),
  );

  @override
  void initState() {
    scrollController.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    currentIndex.dispose();
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  OverlayEntry? entry;
  ValueNotifier<int?> currentIndex = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            print('AppLog: ${notification.metrics}');
          }
          return false;
        },
        child: ListView.separated(
          controller: scrollController,
          itemCount: itemCount,
          cacheExtent: MediaQuery.of(context).size.width,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.arrowLeft): () async {
                  if (index == 0) return;
                  currentIndex.value = max(index - 1, 0);
                  final focusNode = focusNodes[currentIndex.value!];
                  focusNode.requestFocus();
                  Scrollable.ensureVisible(
                    focusNode.context!,
                    duration: const Duration(milliseconds: 200),
                  );
                },
                const SingleActivator(LogicalKeyboardKey.arrowRight): () async {
                  if (index == focusNodes.length - 1) return;
                  currentIndex.value = min(index + 1, focusNodes.length - 1);
                  final focusNode = focusNodes[currentIndex.value!];
                  focusNode.requestFocus();
                  Scrollable.ensureVisible(
                    focusNode.context!,
                    duration: const Duration(milliseconds: 200),
                  );
                }
              },
              child: CarouselItem(
                index: index,
                focusNode: focusNodes[index],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 10);
          },
        ),
      ),
    );
  }
}
