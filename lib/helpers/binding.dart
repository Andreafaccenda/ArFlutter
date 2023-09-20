import 'package:ar/screens/fossili/ammonite_view_model.dart';
import 'package:get/get.dart';
import '../screens/auth/auth_view_model.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthViewModel());
    Get.lazyPut(() => AmmoniteViewModel());
  }
}