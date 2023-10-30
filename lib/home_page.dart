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
            SizedBox(
              height: 100,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          width: 100,
                          height: 100,
                          color: Colors.teal,
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Transform.translate(
                          offset: const Offset(-50, 0),
                          child: Container(
                            width: 100,
                            height: 100,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          width: 100,
                          height: 100,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // const SizedBox(
            //   height: 100,
            //   child: AnimatedCarousel(),
            // )
          ],
        ),
      ),
    );
  }
}
