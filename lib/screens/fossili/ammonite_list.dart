import 'package:ar/screens/ar_flutter/ar_fossil.dart';
import 'package:ar/screens/fossili/ammonite_view_model.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../model/ammonite.dart';
import '../../model/user_model.dart';
import '../../widgets/costanti.dart';
import '../../widgets/custom_dialog.dart';
import 'ammonite_dettagli.dart';
import 'ammonite_polyline.dart';
import '../auth/auth_view_model.dart';

late UserModel user;
class AmmoniteList extends StatefulWidget {
  const AmmoniteList({Key? key}) : super(key: key);

  @override
  State<AmmoniteList> createState() => _AmmoniteListState();
}

class _AmmoniteListState extends State<AmmoniteList> {

  final viewModel = AmmoniteViewModel();
  late List<Ammonite> lista;
  final viewModelAuth = AuthViewModel();

  @override
  void initState(){
    super.initState();
    lista = ammoniti;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey300,
      body: SafeArea(
        child: WillPopScope(onWillPop: showExitDialog,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10,),
                  searchText(),
                  const SizedBox(height: 15),
                  _listViewFossils(),
                ],
              ),
            ),
          )),
      ),);
  }
  Widget _listViewFossils() {
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.75,
      child: ListView.separated(
        itemCount: lista.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.to(() => DettagliAmmonite(model: lista[index]));
            },
            child: Container(
              height: MediaQuery.of(context).size.height*0.15,
              margin: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 20),
              child: AspectRatio(
                aspectRatio: 3/1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: white,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      AspectRatio(aspectRatio: 1/1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image(
                            image:FirebaseImage('gs://serene-circlet-394113.appspot.com/${lista[index].foto}',)
                          ),
                        ),),
                      const SizedBox(width: 10 ,),
                      AspectRatio(aspectRatio: 4/3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(lista[index].nome.toString(),style:  TextStyle(color: black54,fontFamily: 'PlayfairDisplay',fontSize: 14,fontWeight: FontWeight.bold),),
                            const SizedBox(height: 2,),
                            Text("${lista[index]
                                .zona}",style:  TextStyle(color: black54,fontFamily: 'PlayfairDisplay',fontSize: 12,fontWeight: FontWeight.w500),),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(onTap: () {
                                  Get.to(() => AmmonitePolyline(model: lista[index]));
                                },
                                  child: Container(padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: white,),
                                    child:  Column(
                                      children: [
                                        Image.asset('assets/image/icon_mappa.png',height: 30),
                                      ],
                                    ),),),
                                const SizedBox(width: 15,),
                                GestureDetector(onTap: () {
                                  Get.to(() => ArFossil(model: lista[index],));
                                },
                                  child: Container(padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: white,),
                                    child:  Column(
                                      children: [
                                        Image.asset('assets/image/pickage.png',height: 30,),
                                      ],
                                    ),),),
                              ],
                            ),
                          ],),),
                    ],),),),
            ),
          );
        },
        separatorBuilder: (context, index) =>
            const SizedBox(width: 20,),),
    );
  }
  Widget cardButtons(String path) {
    return SizedBox(
      width: 45,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding: const EdgeInsets.all(7),
            minimumSize: Size.zero,
            backgroundColor: marrone,
          ),
          child: Image.asset(path,height: 20,color: white,),
        ),

    );
  }
  Widget searchText(){
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 5),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color:white, boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 0.0, offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )],),
        child: TextFormField(onChanged: (value) =>{filtraLista(value), setState(() {}), },
          decoration:  InputDecoration(hintText: 'Ricerca fossili', hintStyle: TextStyle(color: black54,fontFamily: 'PlayfairDisplay',fontWeight: FontWeight.w400), border: InputBorder.none, prefixIcon: Icon(Icons.search, color:black54,),), style:  TextStyle(color:black54),),),);
    }
  void filtraLista(String text) {
    List<Ammonite> listaCompleta = viewModel.ammonite;
    List<Ammonite> listaFiltrata = [];
    for (int i = 0; i < listaCompleta.length; i++) {
      if (listaCompleta[i].nome.toString().toLowerCase().startsWith(
          text.toLowerCase())) {
        listaFiltrata.add(listaCompleta[i]);
      }
    }
    setState(() {
      lista = listaFiltrata;
    });
  }

  Future<bool> showExitDialog()async {
    return await showDialog(barrierDismissible: false,context: context, builder: (context)=>
        customAlertDialog(context,"Vuoi uscire dall'applicazione?"),);
  }
}





