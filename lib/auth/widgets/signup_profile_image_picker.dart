import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:async';

import 'package:image_picker/image_picker.dart';

import '../../util/const/icons.dart';




class ProfileImagePicker extends StatefulWidget {
  final margin;

  const ProfileImagePicker({this.margin, Key? key}) : super(key: key);

  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
   XFile? _image;

  Future getImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

      setState(() {
        _image = image!;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Container(
            width: 260.0,
            height: 200.0,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    spreadRadius: 0,
                    offset: Offset(0.0, 16.0)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: _image != null
                  ? Image.file(
                      _image as File,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      'assets/images/signup_page_9_profile.png',
                      fit: BoxFit.fill,
                    ),
            ),
          ),
          IconButton(
            onPressed: () async {
              await getImage();
            },
            icon: const Icon(
              IconData(camera, fontFamily: 'Icons'),
              color: Color(0xffDBEDAF),
            ),
          )
        ],
      ),
    );
  }
}
