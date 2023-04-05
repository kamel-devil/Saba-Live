import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_places_picker/google_places_picker.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
   Place? _place;

  Future _selectPlace(BuildContext context) async {
    try {
      Place picker = await PluginGooglePlacePicker.showAutocomplete(mode: PlaceAutocompleteMode.MODE_FULLSCREEN);
      setState(() {
        _place = picker;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectPlace(context),
      child: Container(
        margin: const EdgeInsets.only(left: 32.0, right: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        decoration: BoxDecoration(
            color: const Color(0x3305756D),
            borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'LOCATION',
              style: TextStyle(letterSpacing: 2.0, fontFamily: 'Montserrat'),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Text(
                  _place != null ? _place!.name! : 'Frankfurt',
                  style: const TextStyle(
                      letterSpacing: 2.0,
                      color: Color(0xff353535),
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                  overflow: TextOverflow.fade,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
