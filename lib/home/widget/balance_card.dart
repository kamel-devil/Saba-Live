import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({Key? key, required this.cardData}) : super(key: key);
  final cardData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launchUrl(Uri.parse(cardData['image']));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                cardData['image']),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(25),
          // color: primary.withOpacity(.4),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.9],
            colors: [
              Colors.black26,
              Colors.white,
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text("Balance", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
        //     SizedBox(height: 5,),
        //     Text(cardData["balance"], maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
        //     SizedBox(height: 30,),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text("Monthly profit", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
        //             SizedBox(height: 5,),
        //             Text(cardData["profit"], maxLines: 1, overflow: TextOverflow.fade, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
        //           ],
        //         ),
        //         Container(
        //           padding: EdgeInsets.only(left: 3, right: 3),
        //           decoration: BoxDecoration(
        //             color: Colors.white.withOpacity(.2),
        //             borderRadius: BorderRadius.circular(30)
        //           ),
        //           child: Row(
        //             children: [
        //               Icon(Icons.arrow_drop_up_sharp),
        //               Text(cardData["change"], style: TextStyle(fontSize: 10,),),
        //             ],
        //           ),
        //         )
        //       ],
        //     ),
        // ],
        // )
      ),
    );
  }

  Future<void> _launchURL2(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
