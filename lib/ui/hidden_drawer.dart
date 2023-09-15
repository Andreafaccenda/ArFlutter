import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import '../model/user_model.dart';
import '../screens/auth/auth_view_model.dart';
import '../screens/fossili/fossils_home.dart';
import '../screens/fossili/fossils_list.dart';
import '../screens/fossili/fossil_bag.dart';
import '../widgets/progressBar.dart';
import '../widgets/costanti.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key? key}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _screens = [];
  final viewModel = AuthViewModel();
  UserModel user = UserModel(userId: "", nome: "", email: "", password: "",lista_fossili: []);

  _getuser() async {
    var prefId = await viewModel.getIdSession();
    var user = await viewModel.getUserFormId(prefId);
    if (user != null) {setState(() {this.user=user;});}

  }

  final defaultTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: Colors.white,
    letterSpacing: 5,
    fontFamily: 'PlayfairDisplay'
  );
  @override
  void initState() {
    super.initState();
    _getuser();
    _screens = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'HOME',
          baseStyle: defaultTextStyle,
          selectedStyle: defaultTextStyle,
          colorLineSelected: Colors.black54,
        ),
        const FossilHome(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'FOSSILI',
          baseStyle: defaultTextStyle,
          selectedStyle: defaultTextStyle,
          colorLineSelected: Colors.black54,
        ),
        const FossilsList(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'ZAINO',
          baseStyle: defaultTextStyle,
          selectedStyle: defaultTextStyle,
          colorLineSelected: Colors.black54,
        ),
          const FossilBag(),
      ),

      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'ESCI',
          onTap: () async {
            await viewModel.removeSession();
            exit(0);
          },
          baseStyle: defaultTextStyle,
          selectedStyle: defaultTextStyle,
          colorLineSelected: Colors.black54,
        ),
        const FossilHome(),
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: const Color.fromRGBO(222,184,135, 1),
      backgroundColorAppBar: marrone,
      screens: _screens,
      isTitleCentered: true,
      initPositionSelected: 0,
      slidePercent: 60,
      styleAutoTittleName: defaultTextStyle,
    );
  }
}
