import 'dart:io';
import 'package:ar/screens/fossili/fossils_list.dart';
import 'package:ar/ui/hidden_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'costanti.dart';

Widget customAlertDialog(BuildContext context,String text) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('USCITA APP',style: TextStyle(fontFamily: 'PlayfairDisplay'),),
        Container(height: 50,
          width: 50,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(border: Border.all(color: white),
            shape: BoxShape.circle,
            color: marrone,),
          child: Image.asset('assets/image/logo.png', height:10, width: 10,),),
      ],
    ), content:  Text(text,style: const TextStyle(fontFamily: 'PlayfairDisplay'),),
    actions: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: white),
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        child:  Text(
          "RIMANI", style: TextStyle(color: marrone,fontFamily: 'PlayfairDisplay'),),),
      ElevatedButton(style: ElevatedButton.styleFrom(
          backgroundColor:marrone,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)) ),
          onPressed: () {
            exit(0);
          },
          child: const Text("ESCI", style: TextStyle(color: white,fontFamily: 'PlayfairDisplay'),))
    ],);

}
 Widget customSnackBar(String str,bool catturato){
  return  Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        height: 90,
        padding: const EdgeInsets.all(16),
        decoration:  BoxDecoration(
          color: marrone,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child:  Row(
          children: [
            const SizedBox(width: 48,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fossil World',style: TextStyle(color: white,fontSize: 18),),
                  const SizedBox(height: 5,),
                  Text(str,style: const TextStyle(color: white,fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Positioned(bottom:0,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
          ),
          child: SvgPicture.asset('assets/image/bubbles.svg',height: 48,width: 40,color: Colors.black38,),
        ),
      ),
      Positioned(
        top: -20,
        left: 0,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset('assets/image/fail.svg',
              height: 40,
            color:  Colors.black38,),
            Positioned(
              top: 10,
              child: Visibility(
                visible: catturato,
                child: Image.asset(
                  'assets/image/pickage.png',
                  height: 16,),
              ),
            ),
            Positioned(
              top: 10,
              child: Visibility(
                visible: !catturato,
                child: SvgPicture.asset(
                  'assets/image/close.svg',
                  height: 16,),
              ),
            ),
          ],
        ),
      )
    ],
  );
 }
