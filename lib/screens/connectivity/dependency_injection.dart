import 'package:ar/screens/connectivity/network_controller.dart';
import 'package:get/get.dart';

class DependencyInjection {

  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent:true);
  }
}