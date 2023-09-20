import 'package:latlong2/latlong.dart';

import '../main.dart';
import '../model/ammonite.dart';


LatLng getLatLngFromFossilData(int index) {
  return LatLng(double.parse(ammoniti[index].lat.toString()),
      double.parse(ammoniti[index].long.toString()));
}
LatLng getLatLngFromOneFossilData(Ammonite fossil) {
  return LatLng(double.parse(fossil.lat.toString()),
      double.parse(fossil.long.toString()));
}

