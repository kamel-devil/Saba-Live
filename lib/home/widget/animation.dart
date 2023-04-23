import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 5),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.yellowAccent),
        child: SlideTransition(
          position: _offsetAnimation,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  children: List.generate(
                    3,
                    (index) => Row(
                      children:  [
                        FlutterLogo(size: 30.0).paddingLeft(8.0 * index),
                        Text('كريم لفته'),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: List.generate(
                    5,
                    (index) => Row(
                      children:  [
                        FlutterLogo(size: 30.0).paddingLeft(8.0 * index),
                        Text('كريم لفته'),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: List.generate(
                    3,
                    (index) => Row(
                      children:  [
                        FlutterLogo(size: 30.0).paddingLeft(8.0 * index),
                        Text('كريم لفته'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
