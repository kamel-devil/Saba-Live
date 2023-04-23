import 'dart:async';
import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:http/http.dart' as http;
import 'package:livechat/util/const/color_const.dart';
import 'package:livechat/util/const/gradient_const.dart';
import 'package:livechat/zegoinroomliveviewitem.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

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

class _LivePageState extends State<LivePage>
    with SingleTickerProviderStateMixin {
  final List<StreamSubscription<dynamic>?> subscriptions = [];
  var animationVisibility = ValueNotifier<bool>(true);
  int? numOfUsers;
  late TabController _tabController;
  int? selectIndex;
  String selectValue = '1'; // late ZegoAudioLiveRoomOption _option;
  // late ZegoAudioLiveRoomController _controller;

  void onInRoomCommandReceived(ZegoInRoomCommandReceivedData commandData) {
    debugPrint(
        "onInRoomCommandReceived, fromUser:${commandData
            .fromUser}, command:${commandData.command}");
    // You can display different animations according to gift-type
    if (commandData.fromUser.id != localUserID) {
      GiftWidget.show(context,
          "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true");
    }
  }

  @override
  void initState() {
    super.initState();
    ZegoExpressEngine.createEngine(
        1091141321,
        '93f42e59c8f5b204e500416d4a9ccb639e4cb28bccd0fd927c637281b7918e21',
        false,
        ZegoScenario.Live);
    ZegoExpressEngine.instance.enableCamera(false);
    // await ZegoExpressEngine.instance.enableMicrophone(true);
    ZegoExpressEngine.instance.setAudioConfig(
        ZegoAudioConfig(48, ZegoAudioChannel.Stereo, ZegoAudioCodecID.Default));
    // await ZegoExpressEngine.instance.setSoundLevelUpdateFrequency(1000);

    ZegoExpressEngine.instance
        .loginRoom(widget.roomID, ZegoUser(localUserID, 'kareem'));

    ZegoExpressEngine.instance.startPublishingStream(widget.roomID);
    ZegoExpressEngine.instance.startPlayingStream(widget.roomID);
    _tabController = TabController(vsync: this, length: 6);
    final isolate = FlutterIsolate.spawn(backgroundTask, 'hallo');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      subscriptions.add(ZegoUIKit()
          .getInRoomCommandReceivedStream()
          .listen(onInRoomCommandReceived));
    });
    print(ZegoUIKit().getAllUsers());
  }

  void backgroundTask(String arg) async {
    await ZegoExpressEngine.instance.startPublishingStream(widget.roomID);
    await ZegoExpressEngine.instance.startPlayingStream(widget.roomID);
  }

  @override
  void dispose() {
    // ZegoExpressEngine.instance
    //     .loginRoom(widget.roomID, ZegoUser.id(localUserID));
    super.dispose();
    _tabController.dispose();
    for (var subscription in subscriptions) {
      subscription?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ZegoUIKitPrebuiltLiveAudioRoom(
            appID: 1091141321 /*input your AppID*/,
            appSign:
            '93f42e59c8f5b204e500416d4a9ccb639e4cb28bccd0fd927c637281b7918e21' /*input your AppSign*/,
            userID: localUserID,
            userName: 'Kareem',
            roomID: widget.roomID,
            config:
            (widget.isHost
                ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
                : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience())
              ..takeSeatIndexWhenJoining =
              widget.isHost ? getHostSeatIndex() : -1
              ..hostSeatIndexes = getLockSeatIndex()
              ..layoutConfig = getLayoutConfig()
              ..seatConfig = (ZegoLiveAudioRoomSeatConfig()
                ..backgroundBuilder = backgroundBuilder
                ..foregroundBuilder = foregroundBuilder)
              ..background = background()
              ..inRoomMessageViewConfig = getMessageViewConfig()
              ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
                  maxCount: 5,
                  hostExtendButtons: [
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
                            return StatefulBuilder(builder:
                                (BuildContext context,
                                StateSetter setState) {
                              return Container(
                                width: double.infinity,
                                height: 400,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [YELLOW, GREEN, BLUE],
                                    ),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(2.0, 1.0),
                                        blurRadius: 10.0,
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        topLeft: Radius.circular(25))),
                                child: Stack(
                                  fit: StackFit.loose,
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 50),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                DottedBorder(
                                                  borderType:
                                                  BorderType.Oval,
                                                  dashPattern: const [
                                                    10,
                                                    5,
                                                    10,
                                                    5,
                                                    10,
                                                    5
                                                  ],
                                                  child: CircleAvatar(
                                                    radius: 19,
                                                    backgroundColor: Colors
                                                        .yellow.shade700,
                                                    child: const Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 6,),
                                                MultiSelectContainer(
                                                  itemsDecoration:
                                                  MultiSelectDecorations(
                                                    selectedDecoration:
                                                    BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(100),
                                                      gradient:
                                                      LinearGradient(
                                                          colors: [
                                                            Colors.yellowAccent
                                                                .shade700,
                                                            Colors
                                                                .lightGreen
                                                          ]),
                                                    ),
                                                  ),
                                                  items: [
                                                    ...List.generate(
                                                        6,
                                                            (index) =>
                                                            MultiSelectCard(
                                                                value: '',
                                                                child:
                                                                const Padding(
                                                                  padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                      5.0),
                                                                  child:
                                                                  CircleAvatar(
                                                                    radius: 15,
                                                                    backgroundImage:
                                                                    AssetImage(
                                                                        'assets/avatars/avatar_5.png'),
                                                                  ),
                                                                )))
                                                  ],
                                                  onChange: (List<String>
                                                  selectedItems,
                                                      String
                                                      selectedItem) {},
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.blueGrey,
                                            thickness: 2,
                                          ),
                                          TabBar(
                                            controller: _tabController,
                                            indicatorColor: Colors.white,
                                            isScrollable: true,
                                            unselectedLabelColor:
                                            Colors.grey,
                                            unselectedLabelStyle:
                                            const TextStyle(
                                                fontWeight:
                                                FontWeight.w600),
                                            labelColor: Colors.black,
                                            labelStyle: const TextStyle(
                                                fontWeight:
                                                FontWeight.w900),
                                            indicatorSize:
                                            TabBarIndicatorSize.label,
                                            tabs: const [
                                              Tab(text: 'Tab 1'),
                                              Tab(text: 'Tab 2'),
                                              Tab(text: 'Tab 2'),
                                              Tab(text: 'Tab 2'),
                                              Tab(text: 'Tab 2'),
                                              Tab(text: 'Tab 2'),
                                            ],
                                          ),
                                          Expanded(
                                            child: TabBarView(
                                              controller: _tabController,
                                              physics:
                                              const ScrollPhysics(),
                                              children: [
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    alignment: WrapAlignment
                                                        .spaceAround,
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  selectIndex =
                                                                      index;
                                                                });
                                                              },
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    4,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: selectIndex ==
                                                                        index
                                                                        ? Colors
                                                                        .yellowAccent
                                                                        .shade700
                                                                        : null
                                                                ),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              YELLOW,
                                              GREEN,
                                              BLUE,
                                              GREEN,
                                            ],
                                          ),
                                          boxShadow: const <BoxShadow>[
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(2.0, 1.0),
                                              blurRadius: 15.0,
                                            )
                                          ],
                                        ),
                                        width: double.infinity,
                                        height: 55,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/coin.png',
                                                  width: 30,
                                                  height: 20,
                                                ),
                                                const Text(
                                                  '300',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.w700),
                                                ),
                                                const Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                  size: 20,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                            Container(
                                              padding:
                                              const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    50),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      width: 80,
                                                      height: 70,
                                                      alignment:
                                                      Alignment.center,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .yellow
                                                                  .shade400),
                                                          borderRadius: const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                  50),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                  50))),
                                                      child: DropdownButton(
                                                        value: selectValue,
                                                        items: const [
                                                          //add items in the dropdown
                                                          DropdownMenuItem(
                                                            value: "1",
                                                            child:
                                                            Text("1"),
                                                          ),
                                                          DropdownMenuItem(
                                                              value: "4",
                                                              child: Text(
                                                                  "4")),
                                                          DropdownMenuItem(
                                                            value: "6",
                                                            child:
                                                            Text("6"),
                                                          )
                                                        ],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectValue =
                                                            value!;
                                                          });
                                                        },
                                                        icon: const Icon(Icons
                                                            .arrow_drop_down),
                                                        iconEnabledColor:
                                                        Colors.white,
                                                        //Icon color
                                                        style:
                                                        const TextStyle(
                                                          //te
                                                            color: Colors
                                                                .white,
                                                            //Font color
                                                            fontSize:
                                                            20 //font size on dropdown button
                                                        ),

                                                        dropdownColor:
                                                        Colors
                                                            .greenAccent
                                                            .shade100,
                                                        //dropdown background color
                                                        underline:
                                                        Container(),
                                                        //remove underline
                                                        isExpanded:
                                                        true, //make true to make width 100%
                                                      )),
                                                  const Divider(
                                                    thickness: 2,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      _sendGift();
                                                    },
                                                    child: Container(
                                                      width: 80,
                                                      height: 50,
                                                      alignment:
                                                      Alignment.center,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .yellow
                                                                  .shade900),
                                                          color: Colors.yellow
                                                              .shade700,
                                                          borderRadius: const BorderRadius
                                                              .only(
                                                              topRight: Radius
                                                                  .circular(
                                                                  50),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                  50))),
                                                      child: const Text(
                                                        'send',
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .w700),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                          },
                        );
                      },
                      child: Image.asset('assets/images/gift.png'),
                    )
                  ],
                  speakerExtendButtons: [
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
                            return StatefulBuilder(builder:
                                (BuildContext context,
                                StateSetter setState) {
                              return Container(
                                width: double.infinity,
                                height: 400,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [YELLOW, GREEN, BLUE],
                                    ),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(2.0, 1.0),
                                        blurRadius: 10.0,
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        topLeft: Radius.circular(25))),
                                child: Stack(
                                  fit: StackFit.loose,
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 50),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                DottedBorder(
                                                  borderType:
                                                  BorderType.Oval,
                                                  dashPattern: const [
                                                    10,
                                                    5,
                                                    10,
                                                    5,
                                                    10,
                                                    5
                                                  ],
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors
                                                        .yellow.shade700,
                                                    child: const Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                ...List.generate(
                                                    ZegoUIKit()
                                                        .getAllUsers()
                                                        .length,
                                                        (index) =>
                                                    const Padding(
                                                      padding:
                                                      EdgeInsets
                                                          .all(5.0),
                                                      child:
                                                      CircleAvatar(
                                                        backgroundImage:
                                                        AssetImage(
                                                            'assets/avatars/avatar_5.png'),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.blueGrey,
                                            thickness: 2,
                                          ),
                                          TabBar(
                                            controller: _tabController,
                                            indicatorColor: Colors.white,
                                            isScrollable: true,
                                            unselectedLabelColor:
                                            Colors.grey,
                                            unselectedLabelStyle:
                                            const TextStyle(
                                                fontWeight:
                                                FontWeight.w600),
                                            labelColor: Colors.black,
                                            labelStyle: const TextStyle(
                                                fontWeight:
                                                FontWeight.w900),
                                            indicatorSize:
                                            TabBarIndicatorSize.label,
                                            tabs: const [
                                              Tab(text: 'Tab 1'),
                                              Tab(text: 'Tab 2'),
                                              Tab(text: 'Tab 2'),
                                              Tab(text: 'Tab 2'),
                                              Tab(text: 'Tab 2'),
                                              Tab(text: 'Tab 2'),
                                            ],
                                          ),
                                          Expanded(
                                            child: TabBarView(
                                              controller: _tabController,
                                              physics:
                                              const ScrollPhysics(),
                                              children: [
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              onTap: () {
                                                                _sendGift();
                                                              },
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              YELLOW,
                                              GREEN,
                                              BLUE,
                                              GREEN,
                                            ],
                                          ),
                                          boxShadow: const <BoxShadow>[
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(2.0, 1.0),
                                              blurRadius: 15.0,
                                            )
                                          ],
                                        ),
                                        width: double.infinity,
                                        height: 55,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/coin.png',
                                                  width: 30,
                                                  height: 20,
                                                ),
                                                const Text(
                                                  '300',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.w700),
                                                ),
                                                const Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                  size: 20,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                            Container(
                                              padding:
                                              const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    50),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      width: 80,
                                                      height: 70,
                                                      alignment:
                                                      Alignment.center,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .yellow
                                                                  .shade400),
                                                          borderRadius: const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                  50),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                  50))),
                                                      child: DropdownButton(
                                                        value: selectValue,
                                                        items: const [
                                                          //add items in the dropdown
                                                          DropdownMenuItem(
                                                            value: "1",
                                                            child:
                                                            Text("1"),
                                                          ),
                                                          DropdownMenuItem(
                                                              value: "4",
                                                              child: Text(
                                                                  "4")),
                                                          DropdownMenuItem(
                                                            value: "6",
                                                            child:
                                                            Text("6"),
                                                          )
                                                        ],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectValue =
                                                            value!;
                                                          });
                                                        },
                                                        icon: const Icon(Icons
                                                            .arrow_drop_down),
                                                        iconEnabledColor:
                                                        Colors.white,
                                                        //Icon color
                                                        style:
                                                        const TextStyle(
                                                          //te
                                                            color: Colors
                                                                .white,
                                                            //Font color
                                                            fontSize:
                                                            20 //font size on dropdown button
                                                        ),

                                                        dropdownColor:
                                                        Colors
                                                            .greenAccent
                                                            .shade100,
                                                        //dropdown background color
                                                        underline:
                                                        Container(),
                                                        //remove underline
                                                        isExpanded:
                                                        true, //make true to make width 100%
                                                      )),
                                                  const Divider(
                                                    thickness: 2,
                                                  ),
                                                  Container(
                                                    width: 80,
                                                    height: 50,
                                                    alignment:
                                                    Alignment.center,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.yellow
                                                                .shade900),
                                                        color: Colors.yellow
                                                            .shade700,
                                                        borderRadius: const BorderRadius
                                                            .only(
                                                            topRight: Radius
                                                                .circular(
                                                                50),
                                                            bottomRight: Radius
                                                                .circular(
                                                                50))),
                                                    child: const Text(
                                                      'send',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .w700),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                          },
                        );
                      },
                      child: Image.asset('assets/images/gift.png'),
                    )
                  ],
                  audienceExtendButtons: [
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
                            return StatefulBuilder(builder:
                                (BuildContext context,
                                StateSetter setState) {
                              return Container(
                                width: double.infinity,
                                height: 400,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [YELLOW, GREEN, BLUE],
                                    ),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(2.0, 1.0),
                                        blurRadius: 10.0,
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        topLeft: Radius.circular(25))),
                                child: Stack(
                                  fit: StackFit.loose,
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 50),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                DottedBorder(
                                                  borderType:
                                                  BorderType.Oval,
                                                  dashPattern: const [
                                                    10,
                                                    5,
                                                    10,
                                                    5,
                                                    10,
                                                    5
                                                  ],
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors
                                                        .yellow.shade700,
                                                    child: const Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                // MultiSelectChipDisplay(
                                                //   items: ZegoUIKit()
                                                //       .getAllUsers().map((
                                                //       e) => null).toList(),
                                                //   onTap: (value) {
                                                //     setState(() {
                                                //       // _selectedAnimals.remove(value);
                                                //     });
                                                //   },
                                                // ),
                                                //  ...List.generate(
                                                //     ZegoUIKit()
                                                //         .getAllUsers()
                                                //         .length,
                                                //         (index) =>
                                                //     const Padding(
                                                //       padding:
                                                //       EdgeInsets.all(5.0),
                                                //       child: CircleAvatar(
                                                //         backgroundImage: AssetImage(
                                                //             'assets/avatars/avatar_5.png'),
                                                //       ),
                                                //     ))
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.blueGrey,
                                            thickness: 2,
                                          ),
                                          TabBar(
                                            controller: _tabController,
                                            indicatorColor: Colors.white,
                                            isScrollable: true,
                                            unselectedLabelColor:
                                            Colors.grey,
                                            unselectedLabelStyle:
                                            const TextStyle(
                                                fontWeight:
                                                FontWeight.w600),
                                            labelColor: Colors.black,
                                            labelStyle: const TextStyle(
                                                fontWeight:
                                                FontWeight.w900),
                                            indicatorSize:
                                            TabBarIndicatorSize.label,
                                            tabs: const [
                                              Tab(text: 'Tab 1'),
                                              Tab(text: 'Tab 2'),
                                              Tab(text: 'Tab 2'),
                                              Tab(text: 'Tab 2'),
                                              Tab(text: 'Tab 2'),
                                              Tab(text: 'Tab 2'),
                                            ],
                                          ),
                                          Expanded(
                                            child: TabBarView(
                                              controller: _tabController,
                                              physics:
                                              const ScrollPhysics(),
                                              children: [
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              onTap: () {
                                                                _sendGift();
                                                              },
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                                SingleChildScrollView(
                                                  child: Wrap(
                                                    children: List.generate(
                                                        10,
                                                            (index) =>
                                                            InkWell(
                                                              child:
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width /
                                                                    5,
                                                                margin: const EdgeInsets
                                                                    .all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        12),
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.2)),
                                                                child:
                                                                Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                                  children: [
                                                                    const SizedBox(
                                                                      width:
                                                                      50,
                                                                      height:
                                                                      60,
                                                                      child:
                                                                      SVGASimpleImage(
                                                                        assetsName:
                                                                        'assets/angel.svga',
                                                                        // resUrl:
                                                                        //     "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"
                                                                      ),
                                                                    ),
                                                                    const Text(
                                                                      'Angle',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight
                                                                              .w700),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/coin.png',
                                                                          width: 30,
                                                                          height: 20,
                                                                        ),
                                                                        const Text(
                                                                          '300',
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight
                                                                                  .w700),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              YELLOW,
                                              GREEN,
                                              BLUE,
                                              GREEN,
                                            ],
                                          ),
                                          boxShadow: const <BoxShadow>[
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(2.0, 1.0),
                                              blurRadius: 15.0,
                                            )
                                          ],
                                        ),
                                        width: double.infinity,
                                        height: 55,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/coin.png',
                                                  width: 30,
                                                  height: 20,
                                                ),
                                                const Text(
                                                  '300',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.w700),
                                                ),
                                                const Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                  size: 20,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                            Container(
                                              padding:
                                              const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    50),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      width: 80,
                                                      height: 70,
                                                      alignment:
                                                      Alignment.center,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .yellow
                                                                  .shade400),
                                                          borderRadius: const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                  50),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                  50))),
                                                      child: DropdownButton(
                                                        value: selectValue,
                                                        items: const [
                                                          //add items in the dropdown
                                                          DropdownMenuItem(
                                                            value: "1",
                                                            child:
                                                            Text("1"),
                                                          ),
                                                          DropdownMenuItem(
                                                              value: "4",
                                                              child: Text(
                                                                  "4")),
                                                          DropdownMenuItem(
                                                            value: "6",
                                                            child:
                                                            Text("6"),
                                                          )
                                                        ],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectValue =
                                                            value!;
                                                          });
                                                        },
                                                        icon: const Icon(Icons
                                                            .arrow_drop_down),
                                                        iconEnabledColor:
                                                        Colors.white,
                                                        //Icon color
                                                        style:
                                                        const TextStyle(
                                                          //te
                                                            color: Colors
                                                                .white,
                                                            //Font color
                                                            fontSize:
                                                            20 //font size on dropdown button
                                                        ),

                                                        dropdownColor:
                                                        Colors
                                                            .greenAccent
                                                            .shade100,
                                                        //dropdown background color
                                                        underline:
                                                        Container(),
                                                        //remove underline
                                                        isExpanded:
                                                        true, //make true to make width 100%
                                                      )),
                                                  const Divider(
                                                    thickness: 2,
                                                  ),
                                                  Container(
                                                    width: 80,
                                                    height: 50,
                                                    alignment:
                                                    Alignment.center,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.yellow
                                                                .shade900),
                                                        color: Colors.yellow
                                                            .shade700,
                                                        borderRadius: const BorderRadius
                                                            .only(
                                                            topRight: Radius
                                                                .circular(
                                                                50),
                                                            bottomRight: Radius
                                                                .circular(
                                                                50))),
                                                    child: const Text(
                                                      'send',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .w700),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            });
                          },
                        );
                      },
                      child: Image.asset('assets/images/gift.png'),
                    )
                  ])
            // ..userAvatarUrl = 'your_avatar_url'
              ..onUserCountOrPropertyChanged = (List<ZegoUIKitUser> users) {
                debugPrint(
                    'onUserCountOrPropertyChanged:${users.map((e) =>
                        e.toString())}');
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
              ..onSeatsChanged = (Map<int, ZegoUIKitUser> takenSeats,
                  List<int> untakenSeats,) {
                debugPrint(
                    'on seats changed, taken seats:$takenSeats, untaken seats:$untakenSeats');
              }
              ..onSeatTakingRequested = (ZegoUIKitUser audience) {
                debugPrint(
                    'on seat taking requested, audience:${audience
                        .toString()}');
              }
              ..onSeatTakingRequestCanceled = (ZegoUIKitUser audience) {
                debugPrint(
                    'on seat taking request canceled, audience:${audience
                        .toString()}');
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
          // ..onSeatClicked = (int index, ZegoUIKitUser? user) {
          //   debugPrint(
          //       'on seat clicked, index:$index, user:${user.toString()}');
          //
          //   showDemoBottomSheet(context);
          // }
          //
          // /// WARNING: will override prebuilt logic
          // ..onMemberListMoreButtonPressed = (ZegoUIKitUser user) {
          //   debugPrint(
          //       'on member list more button pressed, user:${user.toString()}');
          //
          //   showDemoBottomSheet(context);
          // },
        ),
      ),
    );
  }

  bool isAttributeHost(Map<String, String>? userInRoomAttributes) {
    return (userInRoomAttributes?[attributeKeyRole] ?? "") ==
        ZegoLiveAudioRoomRole.host.index.toString();
  }

  Widget backgroundBuilder(BuildContext context, Size size, ZegoUIKitUser? user,
      Map extraInfo) {
    if (!isAttributeHost(user?.inRoomAttributes.value)) {
      return Container();
    }

    return Positioned(
      top: -8,
      left: 0,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/user_background.png')),
        ),
      ),
    );
  }

  Widget foregroundBuilder(BuildContext context, Size size, ZegoUIKitUser? user,
      Map extraInfo) {
    var userName = user?.name.isEmpty ?? true
        ? Container()
        : Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Text(
        user?.name ?? "",
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          backgroundColor: Colors.black.withOpacity(0.1),
          fontSize: 9,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.none,
        ),
      ),
    );

    if (!isAttributeHost(user?.inRoomAttributes.value)) {
      return userName;
    }

    var hostIconSize = Size(size.width / 3, size.height / 3);
    var hostIcon = Positioned(
      bottom: 3,
      right: 0,
      child: Container(
        width: hostIconSize.width,
        height: hostIconSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/user_background.png')),
        ),
      ),
    );

    return Stack(children: [userName, hostIcon]);
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
          'timestamp': DateTime
              .now()
              .millisecondsSinceEpoch,
          "to": localUserID,
        }),
      );

      if (response.statusCode == 200) {
        // When the gift giver calls the gift interface successfully,
        // the gift animation can start to be displayed
        print(response.body);
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
        backgroundBuilder: (BuildContext context,
            Size size,
            ZegoUIKitUser? user,
            Map<String, dynamic> extraInfo,) {
          return Container(color: Colors.grey);
        },
      );
    }

    return ZegoLiveAudioRoomSeatConfig(
      avatarBuilder: avatarBuilder,
    );
  }

  ZegoInRoomMessageViewConfig getMessageViewConfig() {
    return ZegoInRoomMessageViewConfig(itemBuilder: (BuildContext context,
        ZegoInRoomMessage message,
        Map<String, dynamic> extraInfo,) {
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

  Widget avatarBuilder(BuildContext context,
      Size size,
      ZegoUIKitUser? user,
      Map<String, dynamic> extraInfo,) {
    return CircleAvatar(
      maxRadius: size.width,
      backgroundImage: Image
          .asset(
          "assets/avatars/avatar_${((int.tryParse(user?.id ?? "") ?? 0) % 6)
              .toString()}.png")
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
          padding: MediaQuery
              .of(context)
              .viewInsets,
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
