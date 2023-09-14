import 'dart:ui';
import 'package:flutter/material.dart';


InputDecoration formDecoration(String labelText,IconData iconData) {
  return InputDecoration(
    errorStyle: const TextStyle(fontSize: 10),
    prefixIcon: Icon(
      iconData,
      color: marrone,
    ),
    errorMaxLines: 3,
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.grey),
    border: const OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: marrone!,
      ),
    ),
  );
}

const TextStyle style16White = TextStyle(
  color: Colors.white,
  fontSize: 16,);

const TextStyle style16Black = TextStyle(
  color: Colors.black,
  fontSize: 16,);

const Color secondaryColor80LightTheme = Color(0xFF202225);
const Color secondaryColor60LightTheme = Color(0xFF313336);
const Color secondaryColor40LightTheme = Color(0xFF585858);
const Color secondaryColor20LightTheme = Color(0xFF787F84);
const Color secondaryColor10LightTheme = Color(0xFFEEEEEE);
const Color secondaryColor5LightTheme = Color(0xFFF8F8F8);
const defaultPadding = 16.0;
const Color green = Color(0xFF1FCC79);
const Color red = Color(0xFFFF6464);
const Color mainText = Color(0xFF2E3E5C);
const Color secondaryText = Color(0xFF9FA5C0);
const Color outline = Color(0xFFD0DBEA);
const Color white = Color(0xFFFFFFFF);
Color? whiteOpacity = Colors.white.withOpacity(0.4);
Color? grey300 = Colors.grey[300];
Color? black54 = Colors.black54;
Color? trasparent = Colors.transparent;
Color? marrone = const Color.fromRGBO(210, 180, 140, 1);


Widget buttonArrow(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: 55,
        width: 55,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: marrone,
            ),
          ),
        ),
      ),
    ),
  );
}
