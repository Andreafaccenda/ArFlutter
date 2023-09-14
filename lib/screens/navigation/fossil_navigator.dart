import 'dart:async';
import 'package:ar/model/fossil.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../main.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import '../../helpers/shared_prefs.dart';
import '../../widgets/costanti.dart';

class NavigationFossils extends StatefulWidget {
  FossilModel model;
   NavigationFossils({super.key,required this.model});

  @override
  State<NavigationFossils> createState() => _NavigationFossilsState();
}

class _NavigationFossilsState extends State<NavigationFossils> {

  Timer? searchOnStoppedTyping;
  String query = '';
  final bool _isMultipleStop = false;
  MapBoxNavigationViewController? _controller;
  String currentAddress = "";
  late Position currentPosition ;
  late MapBoxOptions _navigationOption;

  @override
  void initState() {
    super.initState();
    _useCurrentAddress();
    initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption.simulateRoute = true;
    MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);
    MapBoxNavigation.instance.setDefaultOptions(_navigationOption);

  }
  Widget builtCard(){
    return Card(
      color: marrone,
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
            child: Row(
              children: [
                Column(
                  children: [
                    const Icon(Icons.directions_car, size: 20),
                    Container(
                      margin: const EdgeInsets.only(top: 3),
                      color: white,
                      width: 3,
                      height: 40,
                    ),
                    const SizedBox(height: 10,),
                    const Icon(Icons.location_on, size: 20),
                  ],
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration:  const BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: SizedBox(
                          height:53,
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Text(currentAddress,style: TextStyle(color: Colors.grey[500],fontWeight: FontWeight.w300,fontSize: 14),),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        decoration:  const BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: SizedBox(
                          height:53,
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Text(widget.model.indirizzo.toString(),style: TextStyle(color: Colors.grey[500],fontWeight: FontWeight.w300,fontSize: 14),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 150),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),),
                elevation: 5,
                shadowColor: Colors.grey[400],
              ),
              label:  Text('Inizia la navigazione',style: TextStyle(color: marrone,fontWeight: FontWeight.w300),),
              icon:  Icon(Icons.directions_car,size: 20,color: marrone,),
              onPressed: () async {
                var wayPoints = <WayPoint>[];
                final source = WayPoint(
                    name: "Partenza",
                    latitude: currentPosition.latitude,
                    longitude: currentPosition.longitude,
                    isSilent: false);

                final destination = WayPoint(
                    name: "Destinazione",
                    latitude: double.parse(widget.model.latitudine.toString()),
                    longitude: double.parse(widget.model.longitudine.toString()),
                    isSilent: false);
                wayPoints.add(source);
                wayPoints.add(destination);

                await MapBoxNavigation.instance
                    .startNavigation(wayPoints: wayPoints,
                    options: MapBoxOptions(
                        mode: MapBoxNavigationMode.walking,
                        simulateRoute: false,
                        language: "it",
                        allowsUTurnAtWayPoints: true,
                        units: VoiceUnits.metric));
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: grey300,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: marrone,
        title: const Text('Imposta la navigazione',style: TextStyle(color: white,fontSize: 20,fontWeight: FontWeight.w200,letterSpacing: 0.5),),
        actions: [
          CircleAvatar(
            backgroundColor: marrone,
            child: Image.asset('assets/image/icon_navigazione.png',height: 35,width: 35),
          ),
          const SizedBox(width: defaultPadding)
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
               SizedBox(height: MediaQuery.of(context).size.height * .26,
                    child: builtCard(),
                  ),

            ],
          ),
        ),
      ),
    );
  }
  _useCurrentAddress() async{
    currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
        '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
  Future<void> _onEmbeddedRouteEvent(e) async {

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller?.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
        });
        break;
      default:
        break;
    }
    setState(() {});
  }
}

