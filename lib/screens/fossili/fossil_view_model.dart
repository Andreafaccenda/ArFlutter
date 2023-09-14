import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../model/fossil.dart';
import '../../repository/fossil_repository.dart';

class FossilViewModel extends GetxController {
  final homeService = FossilService();

  ValueNotifier<bool> get loading => _loading;
  ValueNotifier<bool> _loading = ValueNotifier(false);

  List<FossilModel> get fossilModel => _fossilModel;
  List<FossilModel> _fossilModel = [];

  FossilViewModel() {
    getFossils();
  }

  getFossils() async {
    _loading.value = true;
    FossilService().getFossils().then((value) {
      for (int i = 0; i < value.length; i++) {
        _fossilModel.add(FossilModel.fromJson(value[i].data() as Map<dynamic, dynamic>));
        _loading.value = false;
      }
      update();
    });
  }
  updateFossil(FossilModel fossile) async{
    await homeService.updateFossils(fossile);
  }
}
