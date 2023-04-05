import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livechat/util/const/gradient_const.dart';
import 'package:livechat/zegoinroomliveviewitem.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';
import 'gift_send.dart';

class LivePage extends StatefulWidget {
  final String roomID;
  final bool isHost;
  final LayoutMode layoutMode;

  const LivePage({
    Key? key,
    required this.roomID,
    this.layoutMode = LayoutMode.defaultLayout,
    this.isHost = false,
  }) : super(key: key);

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  final List<StreamSubscription<dynamic>?> subscriptions = [];
  var animationVisibility = ValueNotifier<bool>(true);
  int? numOfUsers;

  void onInRoomCommandReceived(ZegoInRoomCommandReceivedData commandData) {
    debugPrint(
        "onInRoomCommandReceived, fromUser:${commandData.fromUser}, command:${commandData.command}");
    // You can display different animations according to gift-type
    if (commandData.fromUser.id != localUserID) {
      GiftWidget.show(context, "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      subscriptions.add(ZegoUIKit()
          .getInRoomCommandReceivedStream()
          .listen(onInRoomCommandReceived));
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (var subscription in subscriptions) {
      subscription?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: ZegoUIKitPrebuiltLiveAudioRoom(
          appID: 1091141321 /*input your AppID*/,
          appSign:
          '93f42e59c8f5b204e500416d4a9ccb639e4cb28bccd0fd927c637281b7918e21' /*input your AppSign*/,
          userID: localUserID,
          userName: 'Kareem',
          roomID: widget.roomID,
          config: (widget.isHost
              ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
              : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience())
            ..takeSeatIndexWhenJoining = widget.isHost ? getHostSeatIndex() : -1
            ..hostSeatIndexes = getLockSeatIndex()
            ..layoutConfig = getLayoutConfig()
            ..seatConfig = getSeatConfig()
            ..background = background()
            ..inRoomMessageViewConfig = getMessageViewConfig()
            ..bottomMenuBarConfig =
            ZegoBottomMenuBarConfig(maxCount: 5, hostExtendButtons: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  fixedSize: const Size(40, 40),
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return InkWell(
                        onTap: () {
                          _sendGift();
                        },
                        child: const SizedBox(
                          width: 200,
                          height: 200,
                          child: SVGASimpleImage(
                              resUrl:
                              "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"),
                        ),
                      );
                    },
                  );
                },
                child: Image.asset('assets/images/gift.png'),
              )
            ], speakerExtendButtons: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  fixedSize: const Size(40, 40),
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return InkWell(
                        onTap: () {
                          _sendGift();
                        },
                        child: const SizedBox(
                          width: 200,
                          height: 200,
                          child: SVGASimpleImage(
                              resUrl:
                              "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"),
                        ),
                      );
                    },
                  );
                },
                child: Image.asset('assets/images/gift.png'),
              )
            ], audienceExtendButtons: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  fixedSize: const Size(40, 40),
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return InkWell(
                        onTap: () {
                          _sendGift();
                        },
                        child: const SizedBox(
                          width: 200,
                          height: 200,
                          child: SVGASimpleImage(
                              resUrl:
                              "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"),
                        ),
                      );
                    },
                  );
                },
                child: Image.asset('assets/images/gift.png'),
              )
            ])
          // ..userAvatarUrl = 'your_avatar_url'
            ..onUserCountOrPropertyChanged = (List<ZegoUIKitUser> users) {
              debugPrint(
                  'onUserCountOrPropertyChanged:${users.map((e) => e.toString())}');
              debugPrint(users.length.toString());
              setState(() {
                numOfUsers = users.length;
              });
            }
            ..onSeatClosed = () {
              debugPrint('on seat closed');
            }
            ..onSeatsOpened = () {
              debugPrint('on seat opened');
            }
            ..onSeatsChanged = (
                Map<int, ZegoUIKitUser> takenSeats,
                List<int> untakenSeats,
                ) {
              debugPrint(
                  'on seats changed, taken seats:$takenSeats, untaken seats:$untakenSeats');
            }
            ..onSeatTakingRequested = (ZegoUIKitUser audience) {
              debugPrint(
                  'on seat taking requested, audience:${audience.toString()}');
            }
            ..onSeatTakingRequestCanceled = (ZegoUIKitUser audience) {
              debugPrint(
                  'on seat taking request canceled, audience:${audience.toString()}');
            }
            ..onInviteAudienceToTakeSeatFailed = () {
              debugPrint('on invite audience to take seat failed');
            }
            ..onSeatTakingInviteRejected = () {
              debugPrint('on seat taking invite rejected');
            }
            ..onSeatTakingRequestFailed = () {
              debugPrint('on seat taking request failed');
            }
            ..onSeatTakingRequestRejected = () {
              debugPrint('on seat taking request rejected');
            }
            ..onHostSeatTakingInviteSent = () {
              debugPrint('on host seat taking invite sent');
            }

          /// WARNING: will override prebuilt logic
            ..onSeatClicked = (int index, ZegoUIKitUser? user) {
              debugPrint(
                  'on seat clicked, index:$index, user:${user.toString()}');

              showDemoBottomSheet(context);
            }

          /// WARNING: will override prebuilt logic
            ..onMemberListMoreButtonPressed = (ZegoUIKitUser user) {
              debugPrint(
                  'on member list more button pressed, user:${user.toString()}');

              showDemoBottomSheet(context);
            },
        ),
      ),
    );
  }

  Future<void> _sendGift() async {
    late http.Response response;
    try {
      response = await http.post(
        Uri.parse(
            'https://zego-example-server-nextjs.vercel.app/api/send_gift'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'app_id': 1091141321,
          'server_secret': 'c65303ded2a97728cf5b9d76b978453d',
          'room_id': widget.roomID,
          'user_id': localUserID,
          'user_name': 'user_$localUserID',
          'gift_type': 1001,
          'gift_count': 1,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          "to": localUserID,
        }),
      );

      if (response.statusCode == 200) {
        // When the gift giver calls the gift interface successfully,
        // the gift animation can start to be displayed
        GiftWidget.show(context,
            "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true");
      }
    } on Exception catch (error) {
      debugPrint("[ERROR], store fcm token exception, ${error.toString()}");
    }
  }

  Widget background() {
    /// how to replace background view
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(gradient: SIGNUP_BACKGROUND),
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     fit: BoxFit.fill,
          //     image: Image.asset('assets/images/background.png').image,
          //   ),
          // ),
        ),
        const Positioned(
            top: 10,
            left: 10,
            child: Text(
              'Live Audio Room',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xff1B1B1B),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            )),
        Positioned(
          top: 10 + 20,
          left: 10,
          child: Text(
            'ID: ${widget.roomID}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xff606060),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(numOfUsers.toString()),
                const Icon(Icons.person),

              ],
            )),
      ],
    );
  }

  ZegoLiveAudioRoomSeatConfig getSeatConfig() {
    if (widget.layoutMode == LayoutMode.hostTopCenter) {
      return ZegoLiveAudioRoomSeatConfig(
        backgroundBuilder: (
          BuildContext context,
          Size size,
          ZegoUIKitUser? user,
          Map<String, dynamic> extraInfo,
        ) {
          return Container(color: Colors.grey);
        },
      );
    }

    return ZegoLiveAudioRoomSeatConfig(
      avatarBuilder: avatarBuilder,
    );
  }

  ZegoInRoomMessageViewConfig getMessageViewConfig() {
    return ZegoInRoomMessageViewConfig(itemBuilder: (
      BuildContext context,
      ZegoInRoomMessage message,
      Map<String, dynamic> extraInfo,
    ) {
      /// how to use itemBuilder to custom message view
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            ZegoInRoomLiveCommentingViewItem(
              prefix: message.user.name,
              user: message.user,
              message: message.message,
            ),

            /// add a red point
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purpleAccent,
                ),
                width: 10,
                height: 10,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget avatarBuilder(
    BuildContext context,
    Size size,
    ZegoUIKitUser? user,
    Map<String, dynamic> extraInfo,
  ) {
    return CircleAvatar(
      maxRadius: size.width,
      backgroundImage: Image.asset(
              "assets/avatars/avatar_${((int.tryParse(user?.id ?? "") ?? 0) % 6).toString()}.png")
          .image,
    );
  }

  int getHostSeatIndex() {
    if (widget.layoutMode == LayoutMode.hostCenter) {
      return 4;
    }

    return 0;
  }

  List<int> getLockSeatIndex() {
    if (widget.layoutMode == LayoutMode.hostCenter) {
      return [4];
    }

    return [0];
  }

  ZegoLiveAudioRoomLayoutConfig getLayoutConfig() {
    final config = ZegoLiveAudioRoomLayoutConfig();
    switch (widget.layoutMode) {
      case LayoutMode.defaultLayout:
        break;
      case LayoutMode.full:
        config.rowSpacing = 5;
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
      case LayoutMode.hostTopCenter:
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 1,
            alignment: ZegoLiveAudioRoomLayoutAlignment.center,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 2,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceEvenly,
          ),
        ];
        break;
      case LayoutMode.hostCenter:
        config.rowSpacing = 5;
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 3,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
      case LayoutMode.fourPeoples:
        config.rowConfigs = [
          ZegoLiveAudioRoomLayoutRowConfig(
            count: 4,
            alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
          ),
        ];
        break;
    }
    return config;
  }

  void showDemoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color(0xff111014),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
      ),
      isDismissible: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 50),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      'Menu $index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
