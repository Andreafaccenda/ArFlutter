

import 'package:ar/model/ammonite.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../repository/ammonite_repository.dart';

class AmmoniteViewModel extends GetxController {
  final service = AmmoniteService();

  ValueNotifier<bool> get loading => _loading;
  ValueNotifier<bool> _loading = ValueNotifier(false);

  List<Ammonite> get ammonite => _ammonite;
  List<Ammonite> _ammonite = [];

  AmmoniteViewModel() {
    getAmmoniti();
  }

  getAmmoniti() async {
    _loading.value = true;
    AmmoniteService().getAmmoniti().then((value) {
      for (int i = 0; i < value.length; i++) {
        _ammonite.add(Ammonite.fromJson(value[i].data() as Map<dynamic, dynamic>));
        _loading.value = false;
      }
      update();
    });
  }
  addAmmonite(Ammonite ammonite) async{
    await service.addAmmonite(ammonite);
  }
  updateAmmonite(Ammonite ammonite) async{
    await service.updateAmmonite(ammonite);
  }
}
