import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

import 'costanti.dart';



class progressBar extends StatefulWidget {
  const progressBar({Key? key}) : super(key: key);

  @override
  State<progressBar> createState() => _progressBarState();
}

class _progressBarState extends State<progressBar> {


  double ratio = 0;
  void ratioVal() {
    if (ratio == 0) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          ratio = 0.2;
        });
        if (ratio == 0.2) {
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              ratio = 0.4;
            });
            if (ratio == 0.4) {
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  ratio = 0.7;
                });
                if (ratio == 0.7) {
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      ratio = 1;
                    });
                    if (ratio == 1) {
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          ratio = 1;
                        });
                      });
                    }
                  });
                }
              });
            }
          });
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    ratioVal();
    return  SimpleAnimationProgressBar(
                    height: 10,
                    width: 200,
                    backgroundColor: Colors.grey.shade800,
                    foregrondColor: marrone!,
                    ratio: ratio,
                    direction: Axis.horizontal,
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: const Duration(seconds: 2),
                    borderRadius: BorderRadius.circular(10),
                    gradientColor:  LinearGradient(
                        colors: [
                          marrone!,
                          const Color.fromRGBO(222,184,135, 1)]),
                  );
  }
}
