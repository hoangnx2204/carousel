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
              height: 60,
              child: AnimatedCarousel(),
            )
          ],
        ),
      ),
    );
  }
}

class AnimatedCarousel extends StatefulWidget {
  const AnimatedCarousel({
    super.key,
  });

  @override
  State<AnimatedCarousel> createState() => _AnimatedCarouselState();
}

class _AnimatedCarouselState extends State<AnimatedCarousel>
    with SingleTickerProviderStateMixin {
  final itemCount = 20;
  int? focusedIndex;
  late final animController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late final scaleAnim = Tween<double>(begin: 1, end: 1.2).animate(
    animController,
  );
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
    return ListView.separated(
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
            title: index.toString(),
            isSelected: focusedIndex == index,
            onFocusChange: (focused) {
              if (focused) {
                // print('AppLog: ${focusNodes[index].debugLabel}');
              }
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(width: 10);
      },
    );
  }
}

class CarouselItem extends StatelessWidget {
  const CarouselItem({
    super.key,
    required this.title,
    this.isSelected = false,
    this.onFocusChange,
    this.onTap,
    this.focusNode,
  });
  final String title;
  final bool isSelected;
  final ValueChanged<bool>? onFocusChange;
  final ValueChanged<double>? onTap;
  final FocusNode? focusNode;

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
                duration: const Duration(milliseconds: 200));
            focusNode.requestFocus();
            return;
          },
        )
      },
      child: Focus(
        focusNode: focusNode,
        onFocusChange: onFocusChange,
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(),
            color: isSelected ? Colors.amber : Colors.white,
          ),
          child: Center(child: Text(title)),
        ),
      ),
    );
  }
}

class CarouselMoveIntent extends Intent {
  final FocusNode? nextNode;

  const CarouselMoveIntent(this.nextNode);
}
