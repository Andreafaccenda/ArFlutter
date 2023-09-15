import 'dart:async';
import 'dart:convert';

import 'package:ar/widgets/progressBar.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

import '../../helpers/directions_handler.dart';
import '../../model/fossil.dart';
import '../../model/user_model.dart';
import '../../ui/hidden_drawer.dart';
import '../../widgets/costanti.dart';
import '../../widgets/custom_dialog.dart';
import '../auth/auth_view_model.dart';

class ArFossil extends StatefulWidget {
  FossilModel model;
  ArFossil({Key? key,required this.model}) : super(key: key);
  @override
  _ArFossilState createState() =>
      _ArFossilState();
}

class _ArFossilState extends State<ArFossil> {
  // Firebase stuff
  bool _initialized = false;
  bool _error = false;
  FirebaseManager firebaseManager = FirebaseManager();
  Map<String, Map> anchorsInDownloadProgress = Map<String, Map>();
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  late UserModel user;
  final viewModel = AuthViewModel();
  bool catturato = false;
  ARLocationManager? arLocationManager;
  double meter = 0.00;
  Distance distance = const Distance();
  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];
  String lastUploadedAnchor = "";
  late   StreamSubscription _getPositionSubscription;
  AvailableModel selectedModel = AvailableModel(
      "Duck",
      "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
      "");
  bool readyToUpload = false;
  bool readyToDownload = true;
  bool modelChoiceActive = false;
  bool vicino = false;

  final LocationSettings locationSettings =  const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 2,
  );

  @override
  void initState() {
    firebaseManager.initializeFlutterFire().then((value) => setState(() {
      _initialized = value;
      _error = !value;
    }));
    _getUser();
    _isFossilNearly();
    super.initState();
  }

  @override
  void dispose() {
    arSessionManager!.dispose();
    _getPositionSubscription?.cancel();
    super.dispose();

  }
  _getUser()async{

    var prefId = await viewModel.getIdSession();
    user = (await viewModel.getUserFormId(prefId))!;
    for(var id in user.lista_fossili ?? <String>[]){
      if(id == widget.model.id){
        setState(() {
          catturato=true;
        });
      }
    }
  }
  _isFossilNearly(){
    _getPositionSubscription  = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) async {
      setState(() {
        meter = distance.as(
            LengthUnit.Meter,
            LatLng(position!.latitude, position!.longitude),LatLng(double.parse(widget.model.latitudine.toString()),double.parse(widget.model.longitudine.toString())));
      });
      if (meter <= 5.00) {
        setState(() {
          vicino = true;
        });
      }else{
        setState(() {
          vicino = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('External Model Management'),
          ),
          body: Container(
              child: Center(
                  child: Column(
                    children: [
                      Text("Firebase initialization failed"),
                      ElevatedButton(
                          child: Text("Retry"), onPressed: () => {initState()})
                    ],
                  ))));
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('External Model Management'),
          ),
          body: Container(
              child: Center(
                  child: Column(children: [
                    CircularProgressIndicator(),
                    Text("Initializing Firebase")
                  ]))));
    }

    return Scaffold(
        backgroundColor: grey300,
        appBar: AppBar(
            backgroundColor:  marrone,
            centerTitle: true,
            title: const Text('Cattura',style: TextStyle(color: white,fontWeight: FontWeight.bold,fontSize: 20),),
            actions: <Widget>[
              IconButton(
                icon: Image.asset('assets/image/choose.png',color: Colors.white,height: 30,),
                onPressed: () {
                  setState(() {
                    modelChoiceActive = !modelChoiceActive;
                  });
                },
              ),
            ]),
        body:  Stack(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child:  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * .67,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                        child: ARView(
                          onARViewCreated: onARViewCreated,
                          planeDetectionConfig: PlaneDetectionConfig.horizontal,),

                    ),
                ),
            ),
                    Positioned(
                    top: MediaQuery.of(context).size.height*0.70,
                    child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          Icon(Icons.directions_walk,color: vicino ? green: red,size: 15,),
                          const SizedBox(width: 2,),
                          Text('${meter.toStringAsFixed(2)} m',style: TextStyle(color: vicino ? green: red,fontSize: 10,fontWeight: FontWeight.w700),),],),),),
                    Positioned(
                    top: MediaQuery.of(context).size.height*0.73,
                    left: MediaQuery.of(context).size.width*0.17,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: grey300,),
                      child:  Column(
                      children: [
                        Image.asset('assets/image/location.png',height: 30,color: vicino ? green: red,),
                        const SizedBox(height: 5,),
                        Text('Coordinate',style: TextStyle(color: vicino ? green: red,fontSize: 10,fontWeight: FontWeight.w700),),
                    ],),),
                    const SizedBox(width: 10),
                    Visibility(
                      visible: !readyToDownload,
                      child: GestureDetector(onTap: () {
                        calculateDistance();
                      },
                      child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: grey300),
                      child:  Column(
                      children: [
                          Image.asset('assets/image/icon_cattura.png',height: 30,),
                          const SizedBox(height: 5,),
                          Text('Cattura',style: TextStyle(color: black54,fontSize: 10,fontWeight: FontWeight.w700),),
                      ],
                      ),),),
                    ),
                        const SizedBox(width: 10,),
                        Visibility(
                          visible: readyToDownload,
                          child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: grey300),
                            child:  Column(
                              children: [
                                IconButton(onPressed: onDownloadButtonPressed, icon:  Image.asset('assets/image/download.png',height: 30,color: vicino ? green: red,)),
                                Text('Download',style: TextStyle(color: vicino ? green: red,fontSize: 10,fontWeight: FontWeight.w700),),
                              ],
                            ),),
                        ),
                    const SizedBox(width: 10),
                    GestureDetector(onTap: () {onRemoveEverything();},
                        child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: grey300),
                        child:  Column(
                        children: [
                        Image.asset('assets/image/icon_cestino.png',height: 30,color: black54,),
                        const SizedBox(height: 5,),
                        Text('Cestino',style: TextStyle(color: black54,fontSize: 10,fontWeight: FontWeight.w700),),
                        ],
                        ),),),
                        ],
                    ),
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.height*0.82,
                        left: MediaQuery.of(context).size.width*0.10,
                        child:  Visibility(
                          visible: !readyToDownload,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Download \n in corso: ',style: TextStyle(color: black54,fontWeight: FontWeight.w300),),
                              const SizedBox(width: 5,),
                              const progressBar(),
                            ],
                          ),

                    )),

                    Align(
                    alignment: FractionalOffset.topCenter,
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Visibility(
                        visible: readyToUpload,
                        child: ElevatedButton(
                        onPressed: onUploadButtonPressed,
                        child: Text("Upload"))),
                    ]),
                    ),
                    Align(
                    alignment: FractionalOffset.centerLeft,
                      child: Visibility(
                        visible: modelChoiceActive,
                          child: ModelSelectionWidget(
                          onTap: onModelSelected,
                          firebaseManager: this.firebaseManager)))
                    ]),
        );
  }


  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;
    this.arLocationManager = arLocationManager;

    this.arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "assets/image/triangle.png",
      showWorldOrigin: true,
      showAnimatedGuide: false,
    );
    this.arObjectManager!.onInitialize();
    this.arAnchorManager!.initGoogleCloudAnchorMode();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager!.onNodeTap = onNodeTapped;
    this.arAnchorManager!.onAnchorUploaded = onAnchorUploaded;
    this.arAnchorManager!.onAnchorDownloaded = onAnchorDownloaded;

    this
        .arLocationManager!
        .startLocationUpdates()
        .then((value) => null)
        .onError((error, stackTrace) {
      switch (error.toString()) {
        case 'Location services disabled':
          {
            showAlertDialog(
                context,
                "Action Required",
                "To use cloud anchor functionality, please enable your location services",
                "Settings",
                this.arLocationManager!.openLocationServicesSettings,
                "Cancel");
            break;
          }

        case 'Location permissions denied':
          {
            showAlertDialog(
                context,
                "Action Required",
                "To use cloud anchor functionality, please allow the app to access your device's location",
                "Retry",
                this.arLocationManager!.startLocationUpdates,
                "Cancel");
            break;
          }

        case 'Location permissions permanently denied':
          {
            showAlertDialog(
                context,
                "Action Required",
                "To use cloud anchor functionality, please allow the app to access your device's location",
                "Settings",
                this.arLocationManager!.openAppPermissionSettings,
                "Cancel");
            break;
          }

        default:
          {
            this.arSessionManager!.onError(error.toString());
            break;
          }
      }
      this.arSessionManager!.onError(error.toString());
    });
  }

  void onModelSelected(AvailableModel model) {
    this.selectedModel = model;
    this.arSessionManager!.onError(model.name + " selected");
    setState(() {
      modelChoiceActive = false;
    });
  }

  Future<void> onRemoveEverything() async {
    anchors.forEach((anchor) {
      this.arAnchorManager!.removeAnchor(anchor);
    });
    anchors = [];
    if (lastUploadedAnchor != "") {
      setState(() {
        readyToDownload = true;
        readyToUpload = false;
      });
    } else {
      setState(() {
        readyToDownload = true;
        readyToUpload = false;
      });
    }
  }
  /*Future<bool> showExit()async {
    return await showDialog(barrierDismissible: false,context: context, builder: (context)=>
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('USCITA APP'),
              Container(height: 50,
                width: 50,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(border: Border.all(color: white),
                  shape: BoxShape.circle,
                  color: marrone,),
                child: Image.asset('assets/image/logo.png', height: 8, width: 8,),),
            ],
          ), content:  Text('Torna indietro per catturare altri fossili',style: TextStyle(fontWeight: FontWeight.w500,color: white),),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: white),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child:  Text(
                "NO", style: TextStyle(color: marrone,fontWeight: FontWeight.w300),),),
            ElevatedButton(style: ElevatedButton.styleFrom(
                backgroundColor:marrone),
                onPressed: () {
                  Get.to(const HiddenDrawer());
                },
                child: const Text("SI", style: TextStyle(color: white,fontWeight: FontWeight.w300),))
          ],),);

  }
*/
  Future<void> onNodeTapped(List<String> nodeNames) async {
    var foregroundNode = nodes.firstWhere((element) => element.name == nodeNames.first);
    this.arSessionManager!.onError(foregroundNode.data!["onTapText"]);
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
            (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      var newAnchor = ARPlaneAnchor(
          transformation: singleHitTestResult.worldTransform, ttl: 2);
      bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        this.anchors.add(newAnchor);
        // Add note to anchor
        var newNode = ARNode(
            type: NodeType.webGLB,
            uri: this.selectedModel.uri,
            scale: VectorMath.Vector3(0.2, 0.2, 0.2),
            position: VectorMath.Vector3(0.0, 0.0, 0.0),
            rotation: VectorMath.Vector4(1.0, 0.0, 0.0, 0.0),
            data: {"onTapText": "I am a " + this.selectedModel.name});
        bool? didAddNodeToAnchor =
        await this.arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          this.nodes.add(newNode);
          setState(() {
            readyToUpload = true;
          });
        } else {
          this.arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        this.arSessionManager!.onError("Adding Anchor failed");
      }
    }
  }

  Future<void> onUploadButtonPressed() async {
    this.arAnchorManager!.uploadAnchor(this.anchors.last);
    setState(() {
      readyToUpload = false;
    });
  }

  onAnchorUploaded(ARAnchor anchor) {
    // Upload anchor information to firebase
    firebaseManager.uploadAnchor(anchor,
        currentLocation: this.arLocationManager!.currentLocation);
    // Upload child nodes to firebase
    if (anchor is ARPlaneAnchor) {
      anchor.childNodes.forEach((nodeName) => firebaseManager.uploadObject(
          nodes.firstWhere((element) => element.name == nodeName)));
    }
    setState(() {
      readyToDownload = true;
      readyToUpload = false;
    });
    this.arSessionManager!.onError("Upload successful");
  }

  ARAnchor onAnchorDownloaded(Map<String,dynamic> serializedAnchor) {
    final anchor = ARPlaneAnchor.fromJson(anchorsInDownloadProgress[serializedAnchor["cloudanchorid"]] as Map<String,dynamic>);
    anchorsInDownloadProgress.remove(anchor.cloudanchorid);
    this.anchors.add(anchor);

    // Download nodes attached to this anchor
    firebaseManager.getObjectsFromAnchor(anchor, (snapshot) {
      snapshot.docs.forEach((objectDoc) {
        ARNode object = ARNode.fromMap(objectDoc.data() as Map<String, dynamic>);
        arObjectManager!.addNode(object, planeAnchor: anchor);
        this.nodes.add(object);
      });
    });

    return anchor;
  }

  Future<void> onDownloadButtonPressed() async {
    //this.arAnchorManager.downloadAnchor(lastUploadedAnchor);
    //firebaseManager.downloadLatestAnchor((snapshot) {
    //  final cloudAnchorId = snapshot.docs.first.get("cloudanchorid");
    //  anchorsInDownloadProgress[cloudAnchorId] = snapshot.docs.first.data();
    //  arAnchorManager.downloadAnchor(cloudAnchorId);
    //});

    // Get anchors within a radius of 100m of the current device's location
    if (this.arLocationManager!.currentLocation != null) {
      firebaseManager.downloadAnchorsByLocation((snapshot) {
        final cloudAnchorId = snapshot.get("cloudanchorid");
        anchorsInDownloadProgress[cloudAnchorId] = snapshot.data() as Map<String, dynamic>;
        arAnchorManager!.downloadAnchor(cloudAnchorId);
      }, this.arLocationManager!.currentLocation, 0.1);
      setState(() {
        readyToDownload = false;
      });
    } else {
      this
          .arSessionManager!
          .onError("Location updates not running, can't download anchors");
    }
  }
  calculateDistance() {
    for (var anchor in anchors) {
      arSessionManager!.getDistanceFromAnchor(anchor).then((value) => catch_3Dfossil(value!));
    }
  }
  catch_3Dfossil(double value) {
    if (value <= 1.50) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: customSnackBar('Fossile catturato', true),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          backgroundColor: trasparent,
        ),
      );
      onRemoveEverything();
      if (!catturato) {
        user.lista_fossili?.add(widget.model.id);
        viewModel.updateUser(user);
        setState(() {
          catturato = true;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: customSnackBar('Devi avvicinarti ancora', false),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          backgroundColor: trasparent,
        ),
      );
    }
  }

  void showAlertDialog(BuildContext context, String title, String content,
      String buttonText, Function buttonFunction, String cancelButtonText) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text(cancelButtonText),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget actionButton = ElevatedButton(
      child: Text(buttonText),
      onPressed: () {
        buttonFunction();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        cancelButton,
        actionButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

// Class for managing interaction with Firebase (in your own app, this can be put in a separate file to keep everything clean and tidy)
typedef FirebaseListener = void Function(QuerySnapshot snapshot);
typedef FirebaseDocumentStreamListener = void Function(
    DocumentSnapshot snapshot);

class FirebaseManager {
  FirebaseFirestore? firestore;
  Geoflutterfire? geo;
  CollectionReference? anchorCollection;
  CollectionReference? objectCollection;
  CollectionReference? modelCollection;

  // Firebase initialization function
  Future<bool> initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize
      await Firebase.initializeApp();
      geo = Geoflutterfire();
      firestore = FirebaseFirestore.instance;
      anchorCollection = FirebaseFirestore.instance.collection('anchors');
      objectCollection = FirebaseFirestore.instance.collection('objects');
      modelCollection = FirebaseFirestore.instance.collection('models');
      return true;
    } catch (e) {
      return false;
    }
  }

  void uploadAnchor(ARAnchor anchor, {Position? currentLocation}) {
    if (firestore == null) return;

    var serializedAnchor = anchor.toJson();
    var expirationTime = DateTime.now().millisecondsSinceEpoch / 1000 +
        serializedAnchor["ttl"] * 24 * 60 * 60;
    serializedAnchor["expirationTime"] = expirationTime;
    // Add location
    if (currentLocation != null) {
      GeoFirePoint myLocation = geo!.point(
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude);
      serializedAnchor["position"] = myLocation.data;
    }

    anchorCollection!
        .add(serializedAnchor)
        .then((value) =>
        print("Successfully added anchor: " + serializedAnchor["name"]))
        .catchError((error) => print("Failed to add anchor: $error"));
  }

  void uploadObject(ARNode node) {
    if (firestore == null) return;

    var serializedNode = node.toMap();

    objectCollection!
        .add(serializedNode)
        .then((value) =>
        print("Successfully added object: " + serializedNode["name"]))
        .catchError((error) => print("Failed to add object: $error"));
  }

  void downloadLatestAnchor(FirebaseListener listener) {
    anchorCollection!
        .orderBy("expirationTime", descending: false)
        .limitToLast(1)
        .get()
        .then((value) => listener(value))
        .catchError(
            (error) => (error) => print("Failed to download anchor: $error"));
  }

  void downloadAnchorsByLocation(FirebaseDocumentStreamListener listener,
      Position location, double radius) {
    GeoFirePoint center =
    geo!.point(latitude: location.latitude, longitude: location.longitude);

    Stream<List<DocumentSnapshot>> stream = geo!
        .collection(collectionRef: anchorCollection!)
        .within(center: center, radius: radius, field: 'position');

    stream.listen((List<DocumentSnapshot> documentList) {
      documentList.forEach((element) {
        listener(element);
      });
    });
  }

  void downloadAnchorsByChannel() {}

  void getObjectsFromAnchor(ARPlaneAnchor anchor, FirebaseListener listener) {
    objectCollection!
        .where("name", whereIn: anchor.childNodes)
        .get()
        .then((value) => listener(value))
        .catchError((error) => print("Failed to download objects: $error"));
  }

  void deleteExpiredDatabaseEntries() {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    anchorCollection!
        .where("expirationTime",
        isLessThan: DateTime.now().millisecondsSinceEpoch / 1000)
        .get()
        .then((anchorSnapshot) => anchorSnapshot.docs.forEach((anchorDoc) {
      // Delete all objects attached to the expired anchor
      objectCollection!
          .where("name", arrayContainsAny: anchorDoc.get("childNodes"))
          .get()
          .then((objectSnapshot) => objectSnapshot.docs.forEach(
              (objectDoc) => batch.delete(objectDoc.reference)));
      // Delete the expired anchor
      batch.delete(anchorDoc.reference);
    }));
    batch.commit();
  }

  void downloadAvailableModels(FirebaseListener listener) {
    modelCollection!
        .get()
        .then((value) => listener(value))
        .catchError((error) => print("Failed to download objects: $error"));
  }
}

class AvailableModel {
  String name;
  String uri;
  String image;
  AvailableModel(this.name, this.uri, this.image);
}

class ModelSelectionWidget extends StatefulWidget {
  final Function onTap;
  final FirebaseManager firebaseManager;

  ModelSelectionWidget({required this.onTap, required this.firebaseManager});

  @override
  _ModelSelectionWidgetState createState() => _ModelSelectionWidgetState();
}

class _ModelSelectionWidgetState extends State<ModelSelectionWidget> {
  List<AvailableModel> models = [];

  String? selected;

  @override
  void initState() {
    super.initState();
    widget.firebaseManager.downloadAvailableModels((snapshot) {
      snapshot.docs.forEach((element) {
        setState(() {
          models.add(AvailableModel(element.get("name"), element.get("uri"),
              element.get("image")));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Scegli un modello:',
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 20)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.40,
              child: ListView.builder(
                itemCount: models.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      widget.onTap(models[index]);
                    },
                    child:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CircleAvatar(backgroundColor: Colors.white,
                        backgroundImage: FirebaseImage('gs://serene-circlet-394113.appspot.com/${models[index].image}'),
                        radius: 60,
                      ),
                    ),

                  );
                },
              ),
            ),
          )
        ]);

  }


}