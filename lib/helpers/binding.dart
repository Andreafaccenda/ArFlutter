

import 'package:ar/helpers/ammonite_view_model.dart';
import 'package:get/get.dart';
import 'auth_view_model.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthViewModel());
    Get.lazyPut(() => AmmoniteViewModel());
  }
}