import 'dart:convert';

import 'package:ar/widgets/costanti.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../helpers/directions_handler.dart';
import '../main.dart';
import '../screens/auth/auth_view_model.dart';
import '../screens/auth/login_view.dart';
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  final viewModel = AuthViewModel();
  var utente_loggato = false;


  @override
  void initState() {
    super.initState();
    autoLogin();
    initializeLocationAndSave();
  }

  autoLogin() async {
    var prefId = await viewModel.getIdSession();
    if (prefId != "") {
      setState(() {
        utente_loggato=true;
      });
      var user = (await viewModel.getUserFormId(prefId))!;
      viewModel.email= user.email!;
      viewModel.password = user.password!;
      viewModel.signInWithEmailAndPassword(false);
    }
    if(!utente_loggato){Get.offAll(() => const LoginView());}
  }
  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location location = Location();
    bool? serviceEnabled;
    PermissionStatus? permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    // Get capture the current user location
    LocationData locationData = await location.getLocation();
    LatLng currentLatLng = LatLng(locationData.latitude!, locationData.longitude!);

    // Store the user location in sharedPreferences
    sharedPreferences.setDouble('latitude', locationData.latitude!);
    sharedPreferences.setDouble('longitude', locationData.longitude!);

    // Get and store the directions API response in sharedPreferences
    for (int i = 0; i < ammoniti.length; i++) {
      Map modifiedResponse = await getDirectionsAPIResponse(currentLatLng, i);
      saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: grey300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.5,
              width:MediaQuery.of(context).size.width*0.5,
              padding: const EdgeInsets.all(35),
              decoration: BoxDecoration(border: Border.all(color: white), shape: BoxShape.circle, color: marrone,),
              child: Image.asset('assets/image/logo.png', height: 35, width: 35,),),
            const SpinKitCircle(color: Color.fromRGBO(210, 180, 140, 1), size: 50.0,),
            const SizedBox(height: 20,),
            Center(child: Text('INIZIA LA TUA AVVENTURA!',style:  TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: black54,
                letterSpacing: 5,
                fontFamily: 'PlayfairDisplay'
            ),),),
          ],
        ),
      ),
    );
  }
}