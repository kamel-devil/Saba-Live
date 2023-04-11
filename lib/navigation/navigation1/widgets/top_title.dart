import "package:flutter/material.dart";

import "../../../feed/feed_const.dart";
import '../../../util/SizeUtil.dart';
import "../../../util/const/color_const.dart";

class TopTitleBar extends StatelessWidget {
  TopTitleBar(
      {super.key,
      this.leftImage = FeedImage.search_circle,
      this.rightImage = FeedImage.more_circle,
      required this.right,
      required this.left});

  final String leftImage;
  final String rightImage;
  Function() left;
  Function() right;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: SizeUtil.getAxisY(152.0)),
      child: Stack(
        children: <Widget>[
          Container(
            constraints:
                BoxConstraints.expand(height: SizeUtil.getAxisY(133.0)),
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [YELLOW, BLUE])),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: SizeUtil.getAxisY(30.0)),
              child: Text(
                'FEED',
                style: TextStyle(
                    color: TEXT_BLACK,
                    fontSize: SizeUtil.getAxisBoth(28.0),
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: SizeUtil.getAxisX(24.0)),
            alignment: AlignmentDirectional.bottomStart,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: left,
                    child: Image.asset(leftImage,
                        width: SizeUtil.getAxisY(87.0),
                        height: SizeUtil.getAxisY(87.0)),
                  ),
                  InkWell(
                    onTap: right,
                    child: Image.asset(rightImage,
                        width: SizeUtil.getAxisY(87.0),
                        height: SizeUtil.getAxisY(87.0)),
                  )
                ]),
          )
        ],
      ),
    );
  }
}
