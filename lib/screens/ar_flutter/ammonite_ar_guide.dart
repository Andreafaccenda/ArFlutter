import 'package:ar/screens/ar_flutter/ar_fossil.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/ammonite.dart';
import '../../widgets/content_model.dart';
import '../../widgets/costanti.dart';

class ArGuide extends StatefulWidget {
  Ammonite model;
  ArGuide({super.key, required this.model});
  @override
  _ArGuideState createState() => _ArGuideState();
}

class _ArGuideState extends State<ArGuide> {
  int currentIndex = 0;
  late PageController _controller;
  List<UnbordingContent> contents = [];
  List<String>  url = [];

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    setState(() {
      contents.insert(0,UnbordingContent(
          title: 'Guida per la cattura dei fossili',
          image: loadImage(widget.model.foto.toString(),0),
          discription: "Quando sarai nelle vicinanze del fossile,l'icona delle coordinate geografiche diventerà verde e potrai proseguire con la cattura."
      ),);
      contents.insert(1,UnbordingContent(
          title: 'Identificazione del piano',
          image: loadImage('plane_detected.jpg',1),
          discription: "Una volta che ti troverai nei pressi del fossile,rimani immobile per permettere alla fotocamera di individuare un piano su cui far apparire il fossile."
      ),);
    });
    super.initState();
  }

  loadImage(String path,int index) async{

  Reference  ref = FirebaseStorage.instance.ref().child(path);

  //get image url from firebase storage
  var urlImage = await ref.getDownloadURL();
    setState(() {
      url.insert(index,urlImage);
    });
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return url.isEmpty?  Scaffold(
      backgroundColor: grey300,
      body: Center(child: CircularProgressIndicator(color: marrone,),),
    ): Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: marrone,
        title: Text('GUIDA',style: defaultTextStyle),
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
                          fontFamily: 'PlayfairDisplay',
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 30,),
                      Image.network(url[i], height: MediaQuery.of(context).size.height*0.45),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              contents.length,
                  (index) => buildDot(index, context),
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
                  currentIndex == contents.length - 1 ? "Continua" : "Prossima",style:  const TextStyle(color: white,fontFamily: 'PlayfairDisplay')),

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