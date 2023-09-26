import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ar_fossil.dart';

class AvailableModel {
  String name;
  String uri;
  String image;
  AvailableModel(this.name, this.uri, this.image);
}

class ModelSelectionWidget extends StatefulWidget {
  final Function onTap;
  final FirebaseManager firebaseManager;

  ModelSelectionWidget({required this.onTap, required this.firebaseManager});

  @override
  _ModelSelectionWidgetState createState() => _ModelSelectionWidgetState();
}

class _ModelSelectionWidgetState extends State<ModelSelectionWidget> {
  List<AvailableModel> models = [];

  String? selected;

  @override
  void initState() {
    super.initState();
    widget.firebaseManager.downloadAvailableModels((snapshot) {
      snapshot.docs.forEach((element) {
        setState(() {
          models.add(AvailableModel(element.get("name"), element.get("uri"),
              element.get("image")));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Scegli un modello:',
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 20)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.40,
              child: ListView.builder(
                itemCount: models.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      widget.onTap(models[index]);
                    },
                    child:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          CircleAvatar(backgroundColor: Colors.white,
                            backgroundImage: FirebaseImage('gs://serene-circlet-394113.appspot.com/${models[index].image}'),
                            radius: 60,
                          ),
                          Text(models[index].name,style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              letterSpacing: 2,
                              fontFamily: 'PlayfairDisplay'
                          ),),
                        ],
                      ),
                    ),

                  );
                },
              ),
            ),
          )
        ]);

  }


}