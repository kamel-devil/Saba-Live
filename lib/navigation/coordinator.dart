import 'package:flutter/material.dart';

import 'package:livechat/navigation/navigation1/widgets/menu_buttons.dart';

import 'common/pages/home_page.dart';
import 'common/widgets/background_common.dart';
import 'navigation1/animations/home_page_animator.dart';
import 'navigation1/widgets/top_title.dart';

class NavigationOneCoordinator extends StatefulWidget {
  const NavigationOneCoordinator({super.key});

  @override
  _Coordinator createState() => _Coordinator();
}

class _Coordinator extends State<NavigationOneCoordinator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late HomePageAnimator _animator;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _animator = HomePageAnimator(_controller);
  }

  _onHomePressed() => _showHome();

  _onChatPressed() {
    debugPrint("Chat Pressed");
  }

  _onFeedPressed() {
    debugPrint("Feed Pressed");
  }

  _onProfilePressed() {
    debugPrint("Profile Pressed");
  }

  _onSettingsPressed() {
    debugPrint("settings Pressed");
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar:AppBar(),
        body: Material(
          child: BackgroundCommon(
            child: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 100.0,
                  right: 50.0,
                  child: MenuButtons(
                    onChatPressed: _onChatPressed,
                    onFeedPressed: _onFeedPressed,
                    onHomePressed: _onHomePressed,
                    onProfilePressed: _onProfilePressed,
                    onSettingsPressed: _onSettingsPressed,
                  ),
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, widget) =>
                      Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.translationValues(
                            _animator.translateLeft.value, 0.0, 0.0)
                          ..scale(_animator.scaleDown.value),
                        child: HomePage(() => _openMenu()),
                      ),
                ),
              ],
            ),
          ),
        ),
      );

  Future _openMenu() async {
    try {
      await _controller
          .forward()
          .orCancel;
    } on TickerCanceled {
      print("Animation Failed");
    }
  }

  Future _showHome() async {
    try {
      await _controller
          .reverse()
          .orCancel;
    } on TickerCanceled {
      print("Animation Failed");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
