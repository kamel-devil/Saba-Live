import "package:flutter/material.dart";
import 'package:livechat/auth/widgets/date_picker.dart';
import 'package:livechat/auth/widgets/gender_picker.dart';
import 'package:livechat/auth/widgets/location_picker.dart';
import 'package:livechat/auth/widgets/signup_apbar.dart';
import 'package:livechat/auth/widgets/signup_button.dart';
import 'package:livechat/auth/widgets/signup_profile_image_picker.dart';

import '../util/const/gradient_const.dart';

class SignPageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SignupApbar(
        title: 'CREATE ACCOUNT',
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 64.0),
        decoration: const BoxDecoration(gradient: SIGNUP_BACKGROUND),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            const Center(
              child: ProfileImagePicker(
                margin:
                    EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
              ),
            ),
            const DatePicker(),
            GenderPicker(),
             LocationPicker(),
            Container(
                margin: const EdgeInsets.only(top: 32.0),
                child: Center(child: signupButton('NEXT', context)))
          ],
        ),
      ),
    );
  }
}
