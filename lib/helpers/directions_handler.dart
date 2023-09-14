import 'package:ar/model/fossil.dart';
import 'package:latlong2/latlong.dart';
import '../main.dart';
import '../requests/mapbox_requests.dart';

Future<Map> getDirectionsAPIResponse(LatLng currentLatLng, int index) async {
  final response = await getDrivingRouteUsingMapbox(
      currentLatLng,
      LatLng(double.parse(fossili[index].latitudine.toString()),
          double.parse(fossili[index].longitudine.toString())));
  Map geometry = response['routes'][0]['geometry'];
  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];
  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
    "id": fossili[index].id,
  };
  return modifiedResponse;
}
Future<Map> getDirectionsAPIResponseFossil(LatLng currentLatLng,FossilModel fossile) async {
  final response = await getWalkingRouteUsingMapbox(
      currentLatLng,
      LatLng(double.parse(fossile.latitudine.toString()),
          double.parse(fossile.longitudine.toString())));
  Map geometry = response['routes'][0]['geometry'];
  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];
  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
    "id": fossile.id,
  };
  return modifiedResponse;
}

void saveDirectionsAPIResponse(int index, String response) {
  sharedPreferences.setString('fossile--$index', response);
}
