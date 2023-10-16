import 'package:flutter/material.dart';

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
            const AnimatedCarousel(),
          ],
        ),
      ),
    );
  }
}

class AnimatedCarousel extends StatefulWidget {
  const AnimatedCarousel({
    super.key,
    this.height = 200,
  });
  final double height;

  @override
  State<AnimatedCarousel> createState() => _AnimatedCarouselState();
}

class _AnimatedCarouselState extends State<AnimatedCarousel> {
  final itemCount = 20;
  late final focusNodes = List.generate(itemCount, (index) => FocusNode());
  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.separated(
        itemCount: 20,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        itemBuilder: (context, index) {
          final focusNode = focusNodes[index];
          return CarouselItem(
            focusNode: focusNode,
            lable: index.toString(),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 10);
        },
      ),
    );
  }
}

class CarouselItem extends StatefulWidget {
  const CarouselItem({
    super.key,
    this.focusNode,
    this.lable = '',
  });

  final FocusNode? focusNode;
  final String lable;

  @override
  State<CarouselItem> createState() => _CarouselItemState();
}

class _CarouselItemState extends State<CarouselItem>
    with SingleTickerProviderStateMixin {
  bool selected = false;
  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late final scaleAnim =
      Tween<double>(begin: 1, end: 1.2).animate(animationController);
  final key = GlobalKey();
  Offset overlayPosition = Offset.zero;
  OverlayEntry get overlayEntry => OverlayEntry(
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  top: overlayPosition.dy,
                  left: overlayPosition.dx,
                  child: ScaleTransition(
                    scale: scaleAnim,
                    child: RealItem(
                      selected: selected,
                      label: widget.lable,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        overlayPosition = renderBox.localToGlobal(Offset.zero);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      onFocusChange: (isFocused) {
        setState(() {
          selected = isFocused;
        });
        if (selected) {
          Overlay.of(context).insert(overlayEntry);
          animationController.forward();
        } else {
          animationController.reverse();
          // overlayEntry.remove();
        }
      },
      child: RealItem(
        key: key,
        selected: selected,
        label: widget.lable,
      ),
    );
  }
}

class RealItem extends StatelessWidget {
  const RealItem({
    super.key,
    required this.selected,
    this.label = '',
  });

  final bool selected;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: selected ? Colors.teal : Colors.white,
        border: Border.all(),
      ),
      child: Text(label),
    );
  }
}
