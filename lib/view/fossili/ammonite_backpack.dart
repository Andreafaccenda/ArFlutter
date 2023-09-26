import 'package:ar/view/fossili/ammonite_dettagli.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../model/ammonite.dart';
import '../../model/user_model.dart';
import '../../widgets/costanti.dart';
import '../../widgets/custom_dialog.dart';
import '../../helpers/auth_view_model.dart';

class AmmoniteBackpack extends StatefulWidget {
  const AmmoniteBackpack({Key? key}) : super(key: key);

  @override
  State<AmmoniteBackpack> createState() => _AmmoniteBackpackState();
}

class _AmmoniteBackpackState extends State<AmmoniteBackpack> {
  final viewModel = AuthViewModel();
  late UserModel user;
  List<Ammonite> ammoniti_catturati = [];
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  _getUser()async{
    List<Ammonite> lista = [];
    var prefId = await viewModel.getIdSession();
    user = (await viewModel.getUserFormId(prefId))!;
    if(user.lista_fossili!.isNotEmpty){
      for(String id in user.lista_fossili ?? []) {
        for(int i = 0;i< ammoniti.length;i++){
          if(ammoniti[i].id == id){
            lista.add(ammoniti[i]);
          }
        }
      }
      setState(() {
        ammoniti_catturati = lista;
      });
    }
  }
  Widget builtCard(){
    return  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: white,
      boxShadow: [BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 3,
        blurRadius: 10,
        offset: const Offset(0,3),
      )],),
      width: MediaQuery.of(context).size.width*0.60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(decoration: BoxDecoration(border: Border.all(color: marrone!),shape: BoxShape.circle),
                  child:  CircleAvatar(
                    backgroundImage: FirebaseImage('gs://serene-circlet-394113.appspot.com/${ammoniti_catturati[_selectedItemIndex].foto}'),
                    radius: 35,
                  ),
                ),
              ),
            ),
            Center(child: Text(ammoniti_catturati[_selectedItemIndex].nome.toString(),style: TextStyle(fontFamily: 'PlayfairDisplay',color: marrone,fontSize: 20,fontWeight: FontWeight.w700),)),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/image/description.png',height: 20,color: marrone,),
                const SizedBox(width: 10,),
                Text("roccia: ${ammoniti_catturati[_selectedItemIndex].roccia}",
                  overflow: TextOverflow.ellipsis,style:  TextStyle(
                      color: marrone,fontWeight: FontWeight.w700, fontSize: 12,fontFamily: 'PlayfairDisplay'),),
              ],
            ),
            const SizedBox(height: 6,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/image/icon_location.png',height: 20,color: marrone,),
                const SizedBox(width: 10,),
                Text(ammoniti_catturati[_selectedItemIndex].indirizzo.toString(),
                  overflow: TextOverflow.ellipsis,style:  TextStyle(
                      color: marrone,fontWeight: FontWeight.w700, fontSize: 12,fontFamily: 'PlayfairDisplay'),),
              ],
            ),
            const SizedBox(height: 10,),
            GestureDetector(onTap: () {
              Get.to(() => DettagliAmmonite(model: ammoniti_catturati[_selectedItemIndex]));
            },
              child: Center(
                child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: white,),
                  child:  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Vai ai dettagli',style: TextStyle(color: marrone,fontSize: 12,fontWeight: FontWeight.w700,fontFamily: 'PlayfairDisplay'),),
                            Image.asset('assets/image/arrow.png',height: 15,color: marrone,),
                          ],
                        ),
                      ),
                    ],
                  ),),
              ),),
          ],
        ),
      ),
    );
  }


  // The index of the selected item (the one at the middle of the wheel)
  // In the beginning, it's the index of the first item
  int _selectedItemIndex = 0;

  Future<bool> showExitDialog()async {
    return await showDialog(barrierDismissible: false,context: context, builder: (context)=>
        customAlertDialog(context,"Vuoi uscire dall'applicazione?"),);
  }
  Widget listWheelScrollView(){
    return ListWheelScrollView(
      itemExtent: 150,
      offAxisFraction: -1.2,
      diameterRatio: 1.5,
      physics: const FixedExtentScrollPhysics(),
      squeeze: 0.95,
      onSelectedItemChanged: (int index) {
        // update the UI on selected item changes
        setState(() {
          _selectedItemIndex = index;
        });
      },
      // children of the list
      children: ammoniti_catturati!.map((e) => Container(
        decoration: BoxDecoration(
          // make selected item background color is differ from the rest
          color: ammoniti_catturati!.indexOf(e) == _selectedItemIndex
              ? marrone
              : white,
          shape: BoxShape.circle,),
        child: Center(
          child: Image.asset('assets/image/backpack.png',height: 50,color: black54,
          ),
        ),
      ))
          .toList(),
    );
  }
  Widget listaVuota(){
    return Scaffold(
      backgroundColor: grey300,
      body: WillPopScope(onWillPop: showExitDialog,
        child: Stack(
          children: [
            Center(child: Text('Il tuo zaino è vuoto',
              style: TextStyle(color: black54,fontSize: 25,fontWeight: FontWeight.w600,fontFamily: 'PlayfairDisplay'),),),
            Positioned(
              top: MediaQuery.of(context).size.height*0.50,
              left: MediaQuery.of(context).size.width*0.35,
              child:  Image.asset('assets/image/zaino.png',height:100),
            ),

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return ammoniti_catturati.isEmpty? listaVuota():Scaffold(
      body: WillPopScope(onWillPop: showExitDialog,
        child: Column(children: [
          // display selected item
          // implement the List Wheel Scroll View
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: double.infinity,
              color: grey300,
              child: listWheelScrollView(),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top:50,bottom: 50),
            color: grey300,
            alignment: Alignment.center,
            child:  builtCard(),
          ),
        ]),
      ),
    );
  }
}
