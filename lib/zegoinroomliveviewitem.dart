import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livechat/util/const/color_const.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

class ZegoInRoomLiveCommentingViewItem extends StatelessWidget {
  const ZegoInRoomLiveCommentingViewItem({
    Key? key,
    required this.user,
    required this.message,
    this.prefix,
    this.maxLines = 3,
    this.isHorizontal = true,
  }) : super(key: key);

  final String? prefix;
  final ZegoUIKitUser user;
  final String message;
  final int? maxLines;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),

        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2.0, 1.0),
            blurRadius: 10.0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                prefixWidget(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10,top: 5),
            child: Text(
              isHorizontal ? message : '\n$message',
              style: TextStyle(
                fontSize: 26.r,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  TextSpan prefixWidget() {
    const messageHostColor = Color(0xff9f76ff);

    return TextSpan(children: [
      WidgetSpan(
        child: Transform.translate(
          offset: Offset(0, 0.r),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 60.r + prefix!.length * 12.r,
              minWidth: 34.r,
              minHeight: 36.r,
              maxHeight: 50.r,
            ),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                // color: messageHostColor,
                gradient: const LinearGradient(
                  colors: [
                    messageHostColor,
                    Colors.purpleAccent
                  ]
                ),
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.r, 4.r, 12.r, 4.r),
                child: Center(
                  child: Text(
                    prefix!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.r,
                      fontWeight: FontWeight.w900
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      WidgetSpan(child: SizedBox(width: 10.r)),
    ]);
  }
}
