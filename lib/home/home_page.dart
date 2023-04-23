import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:livechat/home/widget/countries.dart';
import 'package:nb_utils/nb_utils.dart';

import 'widget/animation.dart';
import 'widget/card_slider.dart';

class MWGridViewScreen extends StatefulWidget {
  static String tag = '/MWGridViewScreen';

  @override
  MWGridViewScreenState createState() => MWGridViewScreenState();
}

class MWGridViewScreenState extends State<MWGridViewScreen> {
  late List<ItemModel> mListing;
  List balanceCards = [
    {
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYR_YNyA6yGvBuxONz0-VA4HsPQ93YKFN4VVbYkHy7RDfpL5Hr57qlUwdzR8CI5Rqv1Qg&usqp=CAU",
      "balance": "\$654,300",
      "profit": "\$23,000",
      "change": "+3%",
      "state": true,
    },
    {
      "image": "https://wallpaper.dog/large/20555163.jpg",
      "balance": "\$240,300",
      "profit": "\$22,000",
      "change": "-3%",
      "state": false,
    },
    {
      "image": "https://g.foolcdn.com/art/companylogos/square/btc.png",
      "balance": "\$876,300",
      "profit": "\$43,000",
      "change": "8%",
      "state": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    mListing = getData();

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = context.width() / 2;
    double cardHeight = context.height() / 4;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        // appBar: appBar(context, 'Grid View'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Column(
              children: [
                CardSlider(balanceCards: balanceCards),
                const MyStatefulWidget(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.black26)),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Image(image: AssetImage('assets/images/fire.png'),width: 30,height: 30,),
                            2.width,
                            const Text('Hot',style: TextStyle(fontWeight: FontWeight.w700),)
                          ],
                        ),
                      ),

                      for (var country in countries)
                        Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.black26)),
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleFlag(
                                country.countryCode,
                                size: 32,
                              ),
                              8.width,
                              Text(country.name)
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: mListing.length,
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemBuilder: (context, index) =>
                      Product(mListing[index], index),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Product extends StatelessWidget {
  late ItemModel model;

  Product(ItemModel model, int pos) {
    this.model = model;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.asset(
            model.img,
            fit: BoxFit.fill,
            height: context.height() / 2,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: CircleFlag(
            'EG',
            size: 32,
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 60,
            decoration: const BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0)

              )
            ),
            child: const Text('chat',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w500),textAlign: TextAlign.center),
          )
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(model.name, style: primaryTextStyle(color: Colors.black)),
              Row(
                children: const [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  Text('111111111')
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class ItemModel {
  var name = "";
  var img = "";
}

List<ItemModel> getData() {
  List<ItemModel> popularArrayList = [];
  ItemModel item1 = ItemModel();
  item1.img = 'assets/images/3yd1.png';
  item1.name = "فين العيديه";

  ItemModel item2 = ItemModel();
  item2.img = 'assets/images/3yd1.png';
  item2.name = "فين العيديه";

  ItemModel item3 = ItemModel();
  item3.img = 'assets/images/3yd1.png';
  item3.name = "فين العيديه";

  ItemModel item4 = ItemModel();
  item4.img = 'assets/images/3yd.png';
  item4.name = "فين العيديه";

  ItemModel item5 = ItemModel();
  item5.img = 'assets/images/3yd.png';
  item5.name = "فين العيديه";

  ItemModel item6 = ItemModel();
  item6.img = 'assets/images/3yd.png';
  item6.name = "فين العيديه";

  popularArrayList.add(item1);
  popularArrayList.add(item2);
  popularArrayList.add(item3);
  popularArrayList.add(item4);
  popularArrayList.add(item5);
  popularArrayList.add(item6);
  popularArrayList.add(item1);
  popularArrayList.add(item2);
  popularArrayList.add(item3);
  popularArrayList.add(item4);
  popularArrayList.add(item1);
  popularArrayList.add(item2);
  popularArrayList.add(item3);
  popularArrayList.add(item4);
  popularArrayList.add(item5);
  popularArrayList.add(item6);
  popularArrayList.add(item1);
  popularArrayList.add(item2);
  popularArrayList.add(item3);
  popularArrayList.add(item4);
  popularArrayList.add(item1);
  popularArrayList.add(item2);
  popularArrayList.add(item3);
  popularArrayList.add(item4);
  popularArrayList.add(item5);
  popularArrayList.add(item6);
  popularArrayList.add(item1);
  popularArrayList.add(item2);
  popularArrayList.add(item3);
  popularArrayList.add(item4);
  popularArrayList.add(item1);
  popularArrayList.add(item2);
  popularArrayList.add(item3);
  popularArrayList.add(item4);
  popularArrayList.add(item5);
  popularArrayList.add(item6);
  popularArrayList.add(item1);
  popularArrayList.add(item2);
  popularArrayList.add(item3);
  popularArrayList.add(item4);
  return popularArrayList;
}
