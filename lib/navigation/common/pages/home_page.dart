import 'dart:math';

import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../live_page.dart';
import '../../../util/const/color_const.dart';

class HomePage extends StatelessWidget {
  HomePage(this.onMenuPressed, {super.key});

  final VoidCallback onMenuPressed;
  final roomIDTextCtrl =
      TextEditingController(text: Random().nextInt(10000).toString());
  final layoutValueNotifier =
      ValueNotifier<LayoutMode>(LayoutMode.defaultLayout);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      fixedSize: const Size(120, 60),
      backgroundColor: const Color(0xff2C2F3E).withOpacity(0.6),
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [YELLOW, GREEN, BLUE],
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2.0, 1.0),
            blurRadius: 10.0,
          )
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User ID:$localUserID'),
            const Text('Please test with two or more devices'),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Layout : '),
                  switchDropList<LayoutMode>(
                    layoutValueNotifier,
                    [
                      LayoutMode.defaultLayout,
                      LayoutMode.full,
                      LayoutMode.hostTopCenter,
                      LayoutMode.hostCenter,
                      LayoutMode.fourPeoples,
                    ],
                    (LayoutMode layoutMode) {
                      return Text(layoutMode.text);
                    },
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: roomIDTextCtrl,
              decoration: const InputDecoration(labelText: 'join a live by id'),
            ),
            const SizedBox(height: 20),
            // click me to navigate to LivePage
            ElevatedButton(
              style: buttonStyle,
              child: const Text('Start a live'),
              onPressed: () => jumpToLivePage(
                context,
                roomID: roomIDTextCtrl.text.trim(),
                isHost: true,
              ),
            ),
            const SizedBox(height: 20),
            // click me to navigate to LivePage
            ElevatedButton(
              style: buttonStyle,
              child: const Text('Watch a live'),
              onPressed: () => jumpToLivePage(
                context,
                roomID: roomIDTextCtrl.text,
                isHost: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void jumpToLivePage(BuildContext context,
      {required String roomID, required bool isHost}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePage(
          roomID: roomID,
          isHost: isHost,
          layoutMode: layoutValueNotifier.value,
        ),
      ),
    );
  }

  Widget switchDropList<T>(
    ValueNotifier<T> notifier,
    List<T> itemValues,
    Widget Function(T value) widgetBuilder,
  ) {
    return ValueListenableBuilder<T>(
      valueListenable: notifier,
      builder: (context, value, _) {
        return DropdownButton<T>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: itemValues.map((T itemValue) {
            return DropdownMenuItem(
              value: itemValue,
              child: widgetBuilder(itemValue),
            );
          }).toList(),
          onChanged: (T? newValue) {
            if (newValue != null) {
              notifier.value = newValue;
            }
          },
        );
      },
    );
  }
}
