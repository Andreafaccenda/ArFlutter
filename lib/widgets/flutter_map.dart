import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import '../main.dart';
const MAPBOX_ACCESS_TOKEN='pk.eyJ1IjoiZmFjYzAwIiwiYSI6ImNsam9kc3kzbDFtcHMzZXBqdWQ2YjNzeDcifQ.koA0RgNUY0hLmiOT6W1yqg';

class Mappa extends StatefulWidget {
  late FollowOnLocationUpdate followOnLocationUpdate;
  late StreamController<double?> followCurrentLocationStreamController;

  Mappa({Key? key,
  required this.followOnLocationUpdate,
  required this.followCurrentLocationStreamController,
  }) : super(key: key);

  @override
  State<Mappa> createState() => _MappaState();
}

class _MappaState extends State<Mappa> {
  @override
  void initState() {
    super.initState();
    widget.followOnLocationUpdate = FollowOnLocationUpdate.always;
    widget.followCurrentLocationStreamController = StreamController<double?>();
  }

  @override
  void dispose() {
    widget.followCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(0, 0),
        zoom: 15,
        minZoom: 5,
        maxZoom: 20,
        // Stop following the location marker on the map if user interacted with the map.
        onPositionChanged: (MapPosition position, bool hasGesture) {
          if (hasGesture &&
              widget.followOnLocationUpdate != FollowOnLocationUpdate.never) {
            setState(
                  () =>
              widget.followOnLocationUpdate = FollowOnLocationUpdate.never,
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
            for(var fossile in fossili )Marker(point: LatLng(double.parse(fossile.latitudine.toString()),double.parse(fossile.longitudine.toString())),builder: (context){
              return GestureDetector(onTap: (){
                Tooltip(
                  message: fossile.nome,
                  triggerMode: TooltipTriggerMode.tap,
                  child: Text(fossile.indirizzo.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.6),
                      )),
                );
              },
                child: Image.asset('assets/icon/icon_fossil.png',scale: 0.4),);
            }),
          ],
        ),
        CurrentLocationLayer( // disable animation
          followCurrentLocationStream:
          widget.followCurrentLocationStreamController.stream,
          followOnLocationUpdate: widget.followOnLocationUpdate,),
      ],);
  }
}

