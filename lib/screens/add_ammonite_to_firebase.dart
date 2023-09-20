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
  late  TextEditingController controllerNome;
  late  TextEditingController controllerdescFossile;
  late  TextEditingController controllerfoto;
  late  TextEditingController controllerroccia;
  late  TextEditingController controllerzona;
  late  TextEditingController controllerlat;
  late  TextEditingController controllerlong;
  late  TextEditingController controllerperiodo;

  final viewmodel = AmmoniteViewModel();
   Ammonite ammonite = Ammonite(nome: "", descrAmmonite: "", foto: "", roccia: "", descrRoccia: "", zona: "",
                                lat: "", long: "", periodo: "", indirizzo: "", id: '');
  @override
  void initState() {
    controllerNome=TextEditingController();
    controllerdescFossile=TextEditingController();
    controllerfoto=TextEditingController();
    controllerroccia=TextEditingController();
    controllerzona=TextEditingController();
    controllerlat=TextEditingController();
    controllerlong=TextEditingController();
    controllerperiodo=TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    controllerNome.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child:Padding(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          child: Column(
            children: [
              const SizedBox(height: 5,),
              TextField(
                controller: controllerNome,
                onSubmitted: (String value){
                  setState(() {
                    ammonite.nome = controllerNome.text;
                  });
                },
              ),
              const SizedBox(height: 5,),
              TextField(
                controller: controllerdescFossile,
                onSubmitted: (String value){
                  setState(() {
                    ammonite.descrAmmonite = controllerdescFossile.text;
                  });
                },
              ),
              const SizedBox(height: 5,),
              TextField(
                controller: controllerfoto,
                onSubmitted: (String value){
                  setState(() {
                    ammonite.foto = controllerfoto.text;
                  });
                },
              ),
              const SizedBox(height: 5,),
              TextField(
                controller: controllerzona,
                onSubmitted: (String value){
                  setState(() {
                    ammonite.zona = controllerzona.text;
                  });
                },
              ),
              const SizedBox(height: 5,),
              TextField(
                controller: controllerroccia,
                onSubmitted: (String value){
                  setState(() {
                    ammonite.roccia = controllerroccia.text;
                  });
                },
              ),
              const SizedBox(height: 5,),
              TextField(
                controller: controllerperiodo,
                onSubmitted: (String value){
                  setState(() {
                    ammonite.periodo = controllerperiodo.text;
                  });
                },
              ),
              const SizedBox(height: 5,),
              TextField(
                controller: controllerlat,
                onSubmitted: (String value){
                  setState(() {
                    ammonite.lat = controllerlat.text;
                  });
                },
              ),
              const SizedBox(height: 5,),
              TextField(
                controller: controllerlong,
                onSubmitted: (String value){
                  setState(() {
                    ammonite.long = controllerlong.text;
                  });
                },
              ),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: (){viewmodel.addAmmonite(ammonite);}, child: Text('Upload',style: TextStyle(color: Colors.white),))
            ],
          ),


      ),
    );

  }
}
