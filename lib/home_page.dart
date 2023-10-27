import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('button 1'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('button 2'),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
              child: AnimatedCarousel(),
            )
          ],
        ),
      ),
    );
  }
}

class AnimatedCarousel extends StatefulWidget {
  const AnimatedCarousel({super.key, this.height});
  final double? height;

  @override
  State<AnimatedCarousel> createState() => _AnimatedCarouselState();
}

class _AnimatedCarouselState extends State<AnimatedCarousel>
    with SingleTickerProviderStateMixin {
  final itemCount = 20;
  int? focusedIndex;
  final key = GlobalKey();
  OverlayEntry? overlayEntry;
  late final childHeight =
      (key.currentContext?.findRenderObject() as RenderBox).size.height;

  final List<FocusNode> focusNodes = List.generate(
    30,
    (index) => FocusNode(debugLabel: index.toString()),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: key,
      height: widget.height,
      child: ListView.separated(
        itemCount: 30,
        cacheExtent: MediaQuery.of(context).size.width,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Shortcuts(
            shortcuts: {
              const SingleActivator(LogicalKeyboardKey.arrowLeft):
                  CarouselMoveIntent(
                index > 0 ? focusNodes.elementAtOrNull(index - 1) : null,
              ),
              const SingleActivator(LogicalKeyboardKey.arrowRight):
                  CarouselMoveIntent(
                index <= focusNodes.length - 1
                    ? focusNodes.elementAtOrNull(index + 1)
                    : null,
              ),
            },
            child: CarouselItem(
              focusNode: focusNodes[index],
              height: widget.height ?? double.infinity,
              title: index.toString(),
              isSelected: focusedIndex == index,
              onFocusChange: (focused) {
                // if (focused) {
                //   CarouselOverlay.show(
                //     context,
                //     height: childHeight,
                //     title: index.toString(),
                //   );
                // } else {
                //   CarouselOverlay.remove();
                // }
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 10);
        },
      ),
    );
  }
}

abstract class CarouselOverlay {
  static OverlayEntry? _entry;
  static void show(
    BuildContext context, {
    double? height,
    required String title,
    double? top,
    double? right,
    double? left,
    double? bottom,
  }) {
    _entry = OverlayEntry(
      builder: (context) {
        return FocusedCarouselItem(
          height: height,
          title: title,
          top: 100,
          left: 100,
        );
      },
    );
    Overlay.of(context).insert(_entry!);
  }

  static void remove() {
    _entry?.remove();
    _entry = null;
  }
}

class FocusedCarouselItem extends StatefulWidget {
  const FocusedCarouselItem({
    super.key,
    required this.height,
    required this.title,
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  final double? height;
  final String title;
  final double? left, top, right, bottom;

  @override
  State<FocusedCarouselItem> createState() => _FocusedCarouselItemState();
}

class _FocusedCarouselItemState extends State<FocusedCarouselItem>
    with SingleTickerProviderStateMixin {
  late final animController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  )..forward();
  late final scaleAnim = Tween<double>(begin: 1, end: 2).animate(
    animController,
  );
  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      left: widget.left,
      bottom: widget.bottom,
      right: widget.right,
      child: Material(
        child: ScaleTransition(
          scale: scaleAnim,
          child: CarouselItem(
            title: widget.title,
            height: widget.height,
          ),
        ),
      ),
    );
  }
}

class CarouselItem extends StatefulWidget {
  const CarouselItem({
    super.key,
    required this.title,
    this.isSelected = false,
    this.onFocusChange,
    this.onTap,
    this.focusNode,
    this.height,
  });
  final double? height;
  final String title;
  final bool isSelected;
  final ValueChanged<bool>? onFocusChange;
  final ValueChanged<double>? onTap;
  final FocusNode? focusNode;

  @override
  State<CarouselItem> createState() => _CarouselItemState();
}

class _CarouselItemState extends State<CarouselItem> {
  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: {
        CarouselMoveIntent: CallbackAction(
          onInvoke: (intent) {
            final focusNode = (intent as CarouselMoveIntent).nextNode;
            if (focusNode == null) {
              print('AppLog: do nothing');
              return;
            }
            Scrollable.ensureVisible(focusNode.context ?? context,
                    duration: const Duration(milliseconds: 200))
                .then((value) {
              final dx = (context.findRenderObject() as RenderBox)
                  .localToGlobal(Offset.zero)
                  .dx;
              CarouselOverlay.show(
                context,
                height: widget.height,
                top: 100,
                left: dx,
                title: widget.title,
              );
            });
            focusNode.requestFocus();
            return;
          },
        )
      },
      child: Focus(
        focusNode: widget.focusNode,
        onFocusChange: widget.onFocusChange,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(),
            color: widget.isSelected ? Colors.amber : Colors.white,
          ),
          child: Center(child: Text(widget.title)),
        ),
      ),
    );
  }
}

class CarouselMoveIntent extends Intent {
  final FocusNode? nextNode;

  const CarouselMoveIntent(this.nextNode);
}
