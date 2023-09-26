import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import '../model/user_model.dart';
import '../helpers/auth_view_model.dart';
import 'fossili/home.dart';
import 'fossili/ammonite_list.dart';
import 'fossili/ammonite_backpack.dart';
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
        const Home(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'FOSSILI',
          baseStyle: defaultTextStyle,
          selectedStyle: defaultTextStyle,
          colorLineSelected: Colors.black54,
        ),
        const AmmoniteList(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'ZAINO',
          baseStyle: defaultTextStyle,
          selectedStyle: defaultTextStyle,
          colorLineSelected: Colors.black54,
        ),
          const AmmoniteBackpack(),
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
        const Home(),
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
