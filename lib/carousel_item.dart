import 'package:flutter/material.dart';

class CarouselItem extends StatefulWidget {
  const CarouselItem({
    super.key,
    required this.label,
  });
  final String label;

  @override
  State<CarouselItem> createState() => _CarouselItemState();
}

class _CarouselItemState extends State<CarouselItem>
    with SingleTickerProviderStateMixin {
  Color color = Colors.teal;
  final node = FocusNode();
  late final animController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late final scaleAnim =
      Tween<double>(begin: 1.0, end: 1.3).animate(animController);
  void changeFocus(bool needChangeFocus) {
    if (needChangeFocus) {
      node.requestFocus();
    }
  }

  @override
  void didUpdateWidget(covariant CarouselItem oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    animController.dispose();
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onShowFocusHighlight: changeFocus,
      onShowHoverHighlight: changeFocus,
      onFocusChange: (isFocused) {
        isFocused ? animController.forward() : animController.reverse();
        setState(() {
          color = isFocused ? Colors.amber : Colors.teal;
        });
      },
      child: ScaleTransition(
        scale: scaleAnim,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(),
            color: color,
          ),
          child: Center(child: Text(widget.label)),
        ),
      ),
    );
  }
}
