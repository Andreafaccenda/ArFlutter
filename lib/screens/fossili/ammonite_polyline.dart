import 'dart:async';
import 'package:ar/screens/ar_flutter/ar_fossil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../helpers/shared_prefs.dart';
import '../../main.dart';
import '../../model/ammonite.dart';
import '../../widgets/costanti.dart';
const MAPBOX_ACCESS_TOKEN='pk.eyJ1IjoiZmFjYzAwIiwiYSI6ImNsam9kc3kzbDFtcHMzZXBqdWQ2YjNzeDcifQ.koA0RgNUY0hLmiOT6W1yqg';

class AmmonitePolyline extends StatefulWidget {
  Ammonite model;
  AmmonitePolyline({super.key, required this.model});

  @override
  State<AmmonitePolyline> createState() => _AmmonitePolylineState();
}

class _AmmonitePolylineState extends State<AmmonitePolyline> {

  late Position currentPosition ;
  late num distance;
  late num duration;
  late FollowOnLocationUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;

  // Carousel related
  int pageIndex = 0;
  bool accessed = false;
  late List<Widget> carouselItems;
  List<LatLng> points = [];

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5,
  );

  @override
  void initState() {
    super.initState();
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) async {
          setState(() {
            currentPosition=position!;
          });
          points.clear();
      points.add(LatLng(double.parse(position!.latitude.toString()), double.parse(position.longitude.toString())));
      points.add(LatLng(double.parse(widget.model.lat.toString()), double.parse(widget.model.long.toString())));
    });
    // Calculate the distance and time from data in SharedPreferences
    for (int index = 0; index < ammoniti.length; index++) {
      String id = getIdFromSharedPrefs(index);
      if (widget.model.id == id) {
        distance = getDistanceFromSharedPrefs(index) / 1000;
        duration = getDurationFromSharedPrefs(index) / 60;
      }
    }

    _followOnLocationUpdate = FollowOnLocationUpdate.always;
    _followCurrentLocationStreamController = StreamController<double?>();
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();
    super.dispose();
  }


  Widget carouselCard() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.18,
      decoration: BoxDecoration(
        color: marrone,
        border: Border.all(color: white),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 3, blurRadius: 10, offset: const Offset(0, 3),),],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 15,right: 0,left: 10,bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(decoration: BoxDecoration(border: Border.all(color: marrone!),shape: BoxShape.circle),
              child: const CircleAvatar(
                backgroundImage:  AssetImage('assets/image/ammonite.gif'),
                radius: 25,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.nome.toString(),
                    style: const TextStyle(
                      color: white,fontWeight: FontWeight.w800, fontFamily: 'PlayfairDisplay',fontSize: 16),
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      Image.asset('assets/image/icon_location.png',height: 20,color: white,),
                      Text(widget.model.indirizzo.toString(),
                          overflow: TextOverflow.ellipsis,style: const TextStyle(
                            color: white,fontWeight: FontWeight.w500,fontFamily: 'PlayfairDisplay', fontSize: 12),),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Image.asset('assets/image/street.png',height: 20,color: white,),
                      const SizedBox(width: 5,),
                      Text( '${distance.toStringAsFixed(2)} km',
                        overflow: TextOverflow.ellipsis,style: const TextStyle(
                            color: white,fontWeight: FontWeight.w400, fontFamily: 'PlayfairDisplay',fontSize: 12),),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      const Icon(Icons.directions_car,size:20,color: white),
                      const SizedBox(width: 5,),
                      Text( '${duration.toStringAsFixed(2)} min',
                        overflow: TextOverflow.ellipsis,style: const TextStyle(
                            color: white,fontWeight: FontWeight.w400, fontFamily: 'PlayfairDisplay',fontSize: 12),),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget flutterMap(){
    return FlutterMap(
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
            Marker(point: LatLng(double.parse(widget.model.lat.toString()),double.parse(widget.model.long.toString())), builder: (context){
              return Image.asset('assets/icon/icon_fossil.png',scale: 1);
            })
          ],
        ),
        PolylineLayer(
          polylines: [
            Polyline(points: points,color: Colors.black54, strokeWidth: 2),
          ],
        ),
        CurrentLocationLayer( // disable animation
          followCurrentLocationStream:
          _followCurrentLocationStreamController.stream,
          followOnLocationUpdate: _followOnLocationUpdate,),
      ],);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: marrone,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              child: flutterMap(),
            ),
            Positioned(
                top: 20,left: 50,right: 50,child: carouselCard()),

          ],
        ),
      ),
      floatingActionButton:  Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Follow the location marker on the map when location updated until user interact with the map.
              setState(
                    () => _followOnLocationUpdate = FollowOnLocationUpdate.always,);
              // Follow the location marker on the map and zoom the map to level 18.
              _followCurrentLocationStreamController.add(15);},
            backgroundColor: marrone,
            child:  const Icon(Icons.my_location,color: white,), ),
          const SizedBox(height: 10,),
          FloatingActionButton(
              heroTag:'fab1',
              onPressed: (){
                Get.to(() => ArFossil(model: widget.model));
              },backgroundColor: marrone,
              child:  Image.asset('assets/image/icon_cattura.png',height: 30,)
          ),
        ],),
    );
  }
}