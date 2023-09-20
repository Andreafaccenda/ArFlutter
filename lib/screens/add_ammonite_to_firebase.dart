import 'package:ar/main.dart';
import 'package:ar/screens/fossili/ammonite_view_model.dart';
import 'package:flutter/material.dart';

import '../model/ammonite.dart';

class AmmoniteFirebase extends StatefulWidget {
  const AmmoniteFirebase({Key? key}) : super(key: key);

  @override
  State<AmmoniteFirebase> createState() => _AmmoniteFirebaseState();
}

class _AmmoniteFirebaseState extends State<AmmoniteFirebase> {

  final viewmodel = AmmoniteViewModel();
   Ammonite ammonite = Ammonite(nome: "", descrAmmonite: "", foto: "", roccia: "", foto_locazione: "",descrRoccia: "", zona: "",
                                lat: "", long: "", periodo: "", indirizzo: "", id: 'Erycites Stamira');
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child:Padding(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          child: Column(
            children: [
              ElevatedButton(onPressed: (){viewmodel.addAmmonite(ammonite);}, child: Text('Upload',style: TextStyle(color: Colors.white),))
            ],
          ),


      ),
    );

  }
}
