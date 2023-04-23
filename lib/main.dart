// Flutter imports:
import 'package:flutter/material.dart';
import 'package:livechat/util/const/color_const.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

// Project imports:
import 'auth/login.dart';
import 'home/home_page.dart';
import 'navigation/coordinator.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ZegoUIKit().initLog().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: BLUE_DEEP,
          accentColor: YELLOW,
          fontFamily: "Montserrat",
        ),
        title: 'Flutter Demo',
        home:  MWGridViewScreen());
  }
}
