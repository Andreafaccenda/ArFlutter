import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../model/ammonite.dart';
import '../../widgets/costanti.dart';

const MAPBOX_ACCESS_TOKEN='pk.eyJ1IjoiZmFjYzAwIiwiYSI6ImNsam9kc3kzbDFtcHMzZXBqdWQ2YjNzeDcifQ.koA0RgNUY0hLmiOT6W1yqg';

class DettagliAmmonite extends StatefulWidget {
  Ammonite model;
  DettagliAmmonite({super.key, required this.model});

  @override
  State<DettagliAmmonite> createState() => _DettagliAmmoniteState();
}

class _DettagliAmmoniteState extends State<DettagliAmmonite> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
               SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.45,
                child: const WebView(
                      initialUrl: 'https://app.vectary.com/p/6LgldENY7Kch7KwWlbEycm',
                      javascriptMode: JavascriptMode.unrestricted,
                      ),
                  ),
              buttonArrow(context),
              scroll(),
            ],
          ),
        ));
  }
  Widget flutterMap(){
    return FlutterMap(
      options: MapOptions(
        center:  LatLng(double.parse(widget.model.lat.toString()),double.parse(widget.model.long.toString())),
        zoom: 15,
        minZoom: 5,
        maxZoom: 20,
        // Stop following the location marker on the map if user interacted with the map.

      ),
      // ignore: sort_child_properties_last
      children: [
        TileLayer(
          urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
          additionalOptions: const  {
            'accessToken': MAPBOX_ACCESS_TOKEN,
            'id': 'mapbox/streets-v12',
          },
        ),
        MarkerLayer(
          markers: [
            Marker(point: LatLng(double.parse(widget.model.lat.toString()),double.parse(widget.model.long.toString())), builder: (context){
              return Image.asset('assets/icon/icon_fossil.png',scale: 0.4);
            })
          ],
        ),
      ],);
  }

  scroll() {
    double width = MediaQuery.of(context).size.width;
    return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 1.0,
        minChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.hardEdge,
            decoration:  BoxDecoration(
              color:  marrone,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: 35,
                          color: Colors.black12,),],),),
                   Text(widget.model.nome.toString(), style: const TextStyle(fontSize: 18,fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.bold, color: white,),),
                  const SizedBox(height: 5,),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 4,color: white,),),
                  Text("Periodo storico:",style: TextStyle(color: black54,fontSize: 16,fontFamily: 'PlayfairDisplay',fontWeight: FontWeight.w900),),
                  const SizedBox(height: 2,),
                  Text(widget.model.periodo.toString(),style: const TextStyle(color: white,fontFamily: 'PlayfairDisplay',fontWeight: FontWeight.normal,letterSpacing: 0.5,wordSpacing: 1.5),),
                  const SizedBox(height: 5,),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 4,color: white,),),
                  Text("Descrizione:",style: TextStyle(color: black54,fontSize: 16,fontFamily: 'PlayfairDisplay',fontWeight: FontWeight.w900),),
                  const SizedBox(height: 2,),
                  Text(widget.model.descrAmmonite.toString(),style: const TextStyle(color: white,fontFamily: 'PlayfairDisplay',fontWeight: FontWeight.normal,letterSpacing: 0.5,wordSpacing: 1.5),),
                  const SizedBox(height: 5,),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 4,color: white,),),
                  Text("Roccia:",style: TextStyle(color: black54,fontSize: 16,fontFamily: 'PlayfairDisplay',fontWeight: FontWeight.w900),),
                  const SizedBox(height: 2,),
                  Text(widget.model.roccia.toString(),style: const TextStyle(color: white,fontFamily: 'PlayfairDisplay',fontWeight: FontWeight.normal,letterSpacing: 0.5,wordSpacing: 1.5),),
                  const SizedBox(height: 5,),
                  Text(widget.model.descrRoccia.toString(),style: const TextStyle(color: white,fontFamily: 'PlayfairDisplay',fontWeight: FontWeight.normal,letterSpacing: 0.5,wordSpacing: 1.5),),
                  const SizedBox(height: 5,),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 4,color: white,),),
                  Text("Posizione:",style: TextStyle(color: black54,fontSize: 16,fontWeight: FontWeight.w900),),
                  const SizedBox(height: 2,),
                  Text(' ${widget.model.indirizzo.toString()}',style: const TextStyle(color: white,fontWeight: FontWeight.normal,letterSpacing: 0.5,wordSpacing: 1.5),),
                  const SizedBox(height: 2,),
                  Text(' ${widget.model.zona.toString()}',style: const TextStyle(color: white,fontWeight: FontWeight.normal,letterSpacing: 0.5,wordSpacing: 1.5),),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Divider(height: 4,),),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.45,
                    child: flutterMap(),),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          );
        });
  }
}


