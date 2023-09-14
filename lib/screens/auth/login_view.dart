import 'dart:io';
import 'package:ar/screens/auth/register_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/costanti.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/square_tile.dart';
import '../../widgets/validators.dart';
import 'auth_view_model.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final viewModel = AuthViewModel();
  bool _obscureText =true;
  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();
  TextEditingController _controllerResetPassword = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthViewModel>(
        builder: (controller)
        {
          return Scaffold(
            backgroundColor: Colors.grey[300],
            body: SafeArea(
              child: SingleChildScrollView(
                child: WillPopScope(onWillPop: showExitDialog,
                    child: Form(key: _formKey,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Container(height: 150, width: 150, padding: const EdgeInsets.all(21), decoration: BoxDecoration(border: Border.all(color: Colors.white), shape: BoxShape.circle, color: const Color.fromRGBO(210, 180, 140, 1),),
                              child: Image.asset('assets/image/logo.png', height: 35, width: 35,),),
                            const SizedBox(height: 10),
                            Text('Benvenuto nel mondo dei fossili!', style: TextStyle(color: Colors.grey[700], fontSize: 16,),),
                            const SizedBox(height: 25),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: TextFormField(style:const TextStyle(color: Colors.black38),controller: _controllerEmail, textInputAction: TextInputAction.next, validator: validateEmail, onSaved: (value) {controller.email = value!;},
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400),), fillColor: Colors.grey.shade200, filled: true, hintText: "Email", hintStyle: TextStyle(color: Colors.grey[500]),),),),
                            const SizedBox(height: 10),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: TextFormField(style:const TextStyle(color: Colors.black38),controller: _controllerPassword, textInputAction: TextInputAction.next, validator: validatePassword, onSaved:(value) {controller.password=value!;}, decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () {setState(() {
                                      _obscureText=!_obscureText;
                                    });
                                      },
                                    child: Icon(_obscureText ? Icons.visibility: Icons.visibility_off,color: Colors.black38,),
                                  ),
                                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400),), fillColor: Colors.grey.shade200, filled: true, hintText: "Password", hintStyle: TextStyle(color: Colors.grey[500])),
                                  obscureText: _obscureText),),
                            const SizedBox(height: 10),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
                              child: GestureDetector(
                                onTap: (){
                                  bottomSheet(context);
                                },
                                child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [Text('Password dimentica?', style: TextStyle(color: Colors.grey[600]),),],),),),
                            const SizedBox(height: 25),
                            CupertinoButton(borderRadius: const BorderRadius.all(Radius.circular(10)), color: const Color.fromRGBO(210, 180, 140, 1), onPressed: (){_formKey.currentState!.save();if(_formKey.currentState!.validate()){controller.signInWithEmailAndPassword(true);}}, child: const Text('Accedi', style: style16White,),),
                            const SizedBox(height: 35),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                children: [Expanded(
                                  child: Divider(thickness: 0.5, color: Colors.grey[400],),),
                                  Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Text('Oppure continua con', style: TextStyle(color: Colors.grey[700]),),),
                                  Expanded(
                                    child: Divider(thickness: 0.5, color: Colors.grey[400],),),],),),
                            const SizedBox(height: 50),
                            Row(mainAxisAlignment: MainAxisAlignment.center,
                              children:  [
                                GestureDetector(onTap: () {viewModel.signInWithGoogle();},
                                  child: const SquareTile(imagePath: 'assets/image/google.png',),),
                                const SizedBox(width: 25),
                                GestureDetector(onTap: () {viewModel.signInWithGoogle();},
                                  child: const SquareTile(imagePath: 'assets/image/facebook.jpeg'),),],),
                            const SizedBox(height: 50),
                            Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text('Non sei iscritto?', style: TextStyle(color: Colors.grey[700]),),
                                const SizedBox(width: 4),
                                GestureDetector(onTap: () {Get.to(RegisterView());},
                                  child: const Text('Registrati ora!', style: TextStyle(color: Color.fromRGBO(210, 180, 140, 1), fontWeight: FontWeight.bold,),),),],)],),
                      ),),),),),);});
  }
  Future<bool> showExitDialog()async {
    return await showDialog(barrierDismissible: false,context: context, builder: (context)=>
        AlertDialog(shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('USCITA APP'),
              Container(height: 50, width: 50, padding: const EdgeInsets.all(7), decoration: BoxDecoration(border: Border.all(color: Colors.white), shape: BoxShape.circle, color: const Color.fromRGBO(210, 180, 140, 1),),
                child: Image.asset('assets/image/logo.png', height: 8, width: 8,),),
            ],
          ), content: const Text("Vuoi uscire dall'applicazione ?",),
          actions: [
            ElevatedButton(style: ElevatedButton.styleFrom( backgroundColor: Colors.white), onPressed: (){Navigator.of(context).pop(false);},
              child: const Text("NO",style: TextStyle(color:Color.fromRGBO(210, 180, 140, 1) ),),),
            ElevatedButton(style: ElevatedButton.styleFrom( backgroundColor: const Color.fromRGBO(210, 180, 140, 1)),
                onPressed: (){exit(0);},
                child: const Text("SI",style:TextStyle(color: Colors.white),))],));
  }
  void bottomSheet(context) {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true, builder: (context) => Container(padding: const EdgeInsets.fromLTRB(20, 40, 20, 10), height: 260, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: const BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25),),),
      child: Column(
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(text: 'Inserendo la tua email,ti verrà inviata un email per ripristinare la password del tuo account',fontSize: 14,color: Colors.black,),],),
          const SizedBox(height: 10,),
          Padding(padding: const EdgeInsets.all(20),
            child: TextFormField(controller: _controllerResetPassword, textInputAction: TextInputAction.next, validator: validatePassword, onSaved:(value) {_controllerResetPassword=value! as TextEditingController;}, decoration: formDecoration('Email',Icons.email_outlined,),),),
          const SizedBox(height: 10,),
          CupertinoButton(padding: const EdgeInsets.all(10), borderRadius:  const BorderRadius.all(Radius.circular(10)), onPressed: (){viewModel.sendPasswordResetEmail(_controllerResetPassword.text.toString());}, color: const Color.fromRGBO(210, 180, 140, 1),
            child: const Text('Reset Password', style: style16White,),),],),),);
  }

}