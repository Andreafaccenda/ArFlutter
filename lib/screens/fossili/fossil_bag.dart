import 'package:ar/screens/fossili/dettagli_fossile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../model/fossil.dart';
import '../../model/user_model.dart';
import '../../widgets/costanti.dart';
import '../auth/auth_view_model.dart';

class FossilBag extends StatefulWidget {
  const FossilBag({Key? key}) : super(key: key);

  @override
  State<FossilBag> createState() => _FossilBagState();
}

class _FossilBagState extends State<FossilBag> {
  final viewModel = AuthViewModel();
  late UserModel user;
  List<FossilModel>? fossili_catturati;
  bool listaVuota = false;
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  _getUser()async{
    List<FossilModel> lista = [];
    var prefId = await viewModel.getIdSession();
    user = (await viewModel.getUserFormId(prefId))!;
    if(user.lista_fossili!.isEmpty){
      setState(() {
        listaVuota=true;
      });
    }else{
      setState(() {
        listaVuota=false;
      });
      for(var id in user.lista_fossili ?? <String>[]) {
        for(var fossile in fossili){
          if(fossile.id == id){
            lista.add(fossile);
          }
        }
      }
      setState(() {
        fossili_catturati = lista;
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
      width: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(decoration: BoxDecoration(border: Border.all(color: marrone!),shape: BoxShape.circle),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(fossili_catturati![_selectedItemIndex].immagine.toString()),
                    radius: 35,
                  ),
                ),
              ),
            ),
            Center(child: Text(fossili_catturati![_selectedItemIndex].nome.toString(),style: TextStyle(color: marrone,fontSize: 20,fontWeight: FontWeight.w700),)),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/image/description.png',height: 20,color: marrone,),
                const SizedBox(width: 10,),
                Text(fossili_catturati![_selectedItemIndex].descrizione.toString(),
                  overflow: TextOverflow.ellipsis,style:  TextStyle(
                      color: marrone,fontWeight: FontWeight.w500, fontSize: 12),),
              ],
            ),
            const SizedBox(height: 6,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/image/icon_location.png',height: 20,color: marrone,),
                const SizedBox(width: 10,),
                Text(fossili_catturati![_selectedItemIndex].indirizzo.toString(),
                  overflow: TextOverflow.ellipsis,style:  TextStyle(
                      color: marrone,fontWeight: FontWeight.w500, fontSize: 12),),
              ],
            ),
            const SizedBox(height: 10,),
            GestureDetector(onTap: () {
              Get.to(DettagliFossile(model: fossili_catturati![_selectedItemIndex]));
            },
              child: Center(
                child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: white,),
                  child:  Column(
                    children: [
                      Image.asset('assets/image/details.png',height: 30,color:  marrone,),
                      const SizedBox(height: 5,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Vai ai dettagli',style: TextStyle(color: marrone,fontSize: 10,fontWeight: FontWeight.w700),),
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
      children: fossili_catturati
          !.map((e) => Container(
        decoration: BoxDecoration(
          // make selected item background color is differ from the rest
          color: fossili_catturati!.indexOf(e) == _selectedItemIndex
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


  @override
  Widget build(BuildContext context) {
   if(listaVuota){
     return Scaffold(
       backgroundColor: grey300,
       body: Stack(
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
     );
   }
   return Scaffold(
     body: Column(children: [
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
   );

  }
}
