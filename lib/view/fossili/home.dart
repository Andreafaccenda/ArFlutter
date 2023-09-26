import 'dart:async';
import 'package:ar/helpers/ammonite_view_model.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import '../../main.dart';
import '../../widgets/costanti.dart';
import '../../widgets/custom_dialog.dart';

const MAPBOX_ACCESS_TOKEN='pk.eyJ1IjoiZmFjYzAwIiwiYSI6ImNsam9kc3kzbDFtcHMzZXBqdWQ2YjNzeDcifQ.koA0RgNUY0hLmiOT6W1yqg';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {

  late final MapController mapController;

  final viewModel = AmmoniteViewModel();
  late FollowOnLocationUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;
  List<Map> carouselData = [];

  // Carousel related
  int pageIndex = 0;
  bool accessed = false;
  late List<Widget> carouselItems;

  @override
  void initState() {
    super.initState();
    mapController = MapController();

    // Calculate the distance and time from data in SharedPreferences
    for(int i = 0;i<ammoniti.length;i++){
      _getPlace(double.parse(ammoniti[i].lat.toString()),double.parse(ammoniti[i].long.toString()),i);
    }
    _followOnLocationUpdate = FollowOnLocationUpdate.always;
    _followCurrentLocationStreamController = StreamController<double?>();
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();
    super.dispose();
  }

  void _getPlace(double latitudine,double longitudine,int index) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(latitudine,longitudine);

    Placemark placeMark  = newPlace[0];
    String? address = "${placeMark.street} \n ${placeMark.locality} ";
    ammoniti[index].indirizzo=address;
    viewmodel.updateAmmonite(ammoniti[index]);
  }

  Widget _listViewAmmonit() {
    return
          SizedBox(
            height: 100,
            child: ListView.separated(
              itemCount: ammoniti.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    mapController.move(
                        LatLng(double.parse(ammoniti[index].lat.toString()),double.parse(ammoniti[index].long.toString())),15);
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: white),
                        height: 60,
                        width: 60,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(image:FirebaseImage('gs://serene-circlet-394113.appspot.com/${ammoniti[index].foto}')),
                        ),),
                      const SizedBox(height: 2,),
                      Text(ammoniti[index].nome.toString(),style: TextStyle(color: black54,fontWeight: FontWeight.w300,fontFamily: 'PlayfairDisplay'),),],),
                );
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 12,),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey300,
      body: SingleChildScrollView(
        child: WillPopScope(
          onWillPop: showExitDialog,
          child: Container(
            padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Lista fossili',style: TextStyle(color: black54,fontSize:16,fontWeight: FontWeight.w600,fontFamily: 'PlayfairDisplay')),
                    Icon(Icons.more_horiz,color: black54,),],),
                const SizedBox(height: 10,),
                _listViewAmmonit(),
                Divider(height: 4,color: black54,),
                const SizedBox(height: 10,),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mappa',style: TextStyle(color: black54,fontSize:16,fontWeight: FontWeight.w600,fontFamily: 'PlayfairDisplay')),]),
                const SizedBox(height: 5,),
                SizedBox(
                  height:MediaQuery.of(context).size.height*0.62,
                  child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      center: LatLng(0, 0),
                      zoom: 15,
                      minZoom: 5,
                      maxZoom: 20,
                      // Stop following the location marker on the map if user interacted with the map.
                      onPositionChanged: (MapPosition position, bool hasGesture) {
                        if (hasGesture &&
                            _followOnLocationUpdate != FollowOnLocationUpdate.never) {
                          setState(
                                () =>
                            _followOnLocationUpdate = FollowOnLocationUpdate.never,
                          );
                        }
                      },
                    ),
                    // ignore: sort_child_properties_last
                    children: [
                      TileLayer(
                        urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                        additionalOptions: const {
                          'accessToken': MAPBOX_ACCESS_TOKEN,
                          'id': 'mapbox/streets-v12',
                        },
                      ),
                      MarkerLayer(
                        markers: [
                          for(var ammonite in ammoniti )Marker(point: LatLng(double.parse(ammonite.lat.toString()),double.parse(ammonite.long.toString())),builder: (context){
                            return GestureDetector(onTap: (){
                              Tooltip(
                                message: ammonite.nome,
                                triggerMode: TooltipTriggerMode.tap,
                                child: Text(ammonite.indirizzo.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.6),
                                    )),
                              );
                            },
                              child: Image.asset('assets/icon/icon_fossil.png',scale: 0.4),
                                  );
                          }),
                        ],
                      ),
                      CurrentLocationLayer( // disable animation
                        followCurrentLocationStream:
                        _followCurrentLocationStreamController.stream,
                        followOnLocationUpdate: _followOnLocationUpdate,),
                    ],),
                ),
              ],),),
        ),),
      floatingActionButton:  Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 70,),
          FloatingActionButton(
            onPressed: () {
              // Follow the location marker on the map when location updated until user interact with the map.
              setState(
                    () => _followOnLocationUpdate = FollowOnLocationUpdate.always,);
              // Follow the location marker on the map and zoom the map to level 18.
              _followCurrentLocationStreamController.add(15);},
            backgroundColor: marrone,
            child: const Icon(Icons.my_location,color: Colors.white,), ),
        ],),);
  }


  Future<bool> showExitDialog()async {
    return await showDialog(barrierDismissible: false,context: context, builder: (context)=>
       customAlertDialog(context,"Vuoi uscire dall'applicazione?"),);
  }
}