import 'package:ar/screens/ar_flutter/ar_fossil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/fossil.dart';
import '../../widgets/content_model.dart';
import '../../widgets/costanti.dart';

class GuideToCatchFossil extends StatefulWidget {
  FossilModel model;
  GuideToCatchFossil({super.key, required this.model});
  @override
  _GuideToCatchFossilState createState() => _GuideToCatchFossilState();
}

class _GuideToCatchFossilState extends State<GuideToCatchFossil> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: marrone,
        title: const Text('Guida',style: TextStyle(color: white,fontSize: 25,fontWeight: FontWeight.w800),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      Text(
                        contents[i].discription,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 50,),
                      Image.asset(
                        contents[i].image,
                        height: MediaQuery.of(context).size.height*0.45,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                    (index) => buildDot(index, context),
              ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.all(40),
            width: double.infinity,
            child: CupertinoButton(borderRadius: const BorderRadius.all(Radius.circular(10)), color: const Color.fromRGBO(210, 180, 140, 1),
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArFossil(model: widget.model),
                      //ArWidget(model: widget.model),
                    ),
                  );
                }
                _controller.nextPage(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.bounceIn,
                );
              },
              child: Text(
                  currentIndex == contents.length - 1 ? "Continua" : "Prossima",style:  style16White,),

            ),
          )
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: black54,
      ),
    );
  }
}