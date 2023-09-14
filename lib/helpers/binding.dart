import 'package:get/get.dart';
import '../screens/auth/auth_view_model.dart';
import '../screens/fossili/fossil_view_model.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthViewModel());
    Get.lazyPut(() => FossilViewModel());
  }
}