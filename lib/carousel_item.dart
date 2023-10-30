import 'dart:math';

import 'package:flutter/material.dart';

class CarouselItem extends StatefulWidget {
  final int index;
  final FocusNode? focusNode;
  const CarouselItem({
    super.key,
    required this.index,
    this.focusNode,
  });

  @override
  State<CarouselItem> createState() => _CarouselItemState();
}

class _CarouselItemState extends State<CarouselItem>
    with SingleTickerProviderStateMixin {
  late final focusNode = widget.focusNode ?? FocusNode();
  OverlayEntry? overlayEntry;
  late final AnimationController animController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  late final scaleAnim =
      Tween<double>(begin: 1, end: 1.2).animate(animController);

  Widget child(Color color) => Container(
        width: 100,
        height: 100,
        color: color,
        child: Text(hashCode.toString()),
      );

  Future<void> showOverlay() async {
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    print('AppLog: ${widget.index} show');
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy,
        left: max(position.dx, 0),
        child: Material(
          child: ScaleTransition(
            scale: scaleAnim,
            child: child(Colors.teal),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(overlayEntry!);
    await animController.forward();
  }

  Future<void> hideOverlay() async {
    print('AppLog: ${widget.index} hide');

    await animController.reverse();
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    try {
      animController.dispose();
    } catch (_) {}
    super.dispose();
  }

  Color get color => focusNode.hasFocus ? Colors.teal : Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      onFocusChange: (isFocused) {
        setState(() {});
        if (isFocused) {
          animController.forward();
        }
      },
      child: OverflowBox(
        maxHeight: 120,
        maxWidth: 120,
        child: ScaleTransition(
          scale: scaleAnim,
          child: child(color),
        ),
      ),
    );
  }
}

class CarouselMoveIntent extends Intent {}
