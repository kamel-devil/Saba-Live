import 'package:flutter/material.dart';

import '../../../util/const/color_const.dart';




class BackgroundCommon extends StatelessWidget {

	const BackgroundCommon({required this.child, Key? key}) : super(key: key);
	final Widget child;

	@override
  Widget build(BuildContext context) => Container(
      decoration: const BoxDecoration(
					gradient: LinearGradient(
						begin: Alignment.topLeft,
						end: Alignment.bottomRight,
						colors: [YELLOW, GREEN, BLUE],
					)
			),
			child: child
	);
}
