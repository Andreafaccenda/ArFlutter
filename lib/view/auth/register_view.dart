import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/costanti.dart';
import '../../widgets/validators.dart';
import '../../helpers/auth_view_model.dart';
import 'login_view.dart';

class RegisterView extends GetWidget<AuthViewModel> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 25),
                child: Column(
                  children: [
                    Padding(padding: const EdgeInsets.only(bottom: 30,top: 40),
                      child: Column(
                        children: [
                          Text( "Crea un account!", style: TextStyle(color: black54,fontSize: 30,fontWeight: FontWeight.w400,fontFamily: 'PlayfairDisplay'),),
                          const SizedBox(height: 5,),
                          Text( "Per favore riempi tutti i campi",style: TextStyle(color: black54,fontSize: 15,fontWeight: FontWeight.w700,fontFamily: 'PlayfairDisplay'),),],),),
                    Padding(padding: const EdgeInsets.only(bottom: 40,top: 40),
                      child: Column(
                        children: [
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child:TextFormField(style: TextStyle(color: black54),textInputAction: TextInputAction.next, validator: validateName, onSaved:(value) {controller.nome=value!;}, decoration: InputDecoration(enabledBorder:  OutlineInputBorder(borderRadius:BorderRadius.circular(20),borderSide: const BorderSide(color: Colors.white),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400),), fillColor: Colors.grey.shade200, filled: true, hintText: 'Username', hintStyle: TextStyle(color: Colors.grey[500])),),),
                          const SizedBox(height: 20,),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child:TextFormField(style: TextStyle(color: black54),textInputAction: TextInputAction.next, validator: validateEmail, onSaved:(value) {controller.email=value!;}, decoration: InputDecoration(enabledBorder:  OutlineInputBorder(borderRadius:BorderRadius.circular(20),borderSide: const BorderSide(color: Colors.white),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400),), fillColor: Colors.grey.shade200, filled: true, hintText: 'Email', hintStyle: TextStyle(color: Colors.grey[500])),),),
                          const SizedBox(height: 20,),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child:TextFormField(style: TextStyle(color: black54),textInputAction: TextInputAction.next, validator: validatePassword, onSaved:(value) {controller.password=value!;}, decoration: InputDecoration(enabledBorder:  OutlineInputBorder(borderRadius:BorderRadius.circular(20),borderSide: const BorderSide(color: Colors.white),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400),), fillColor: Colors.grey.shade200, filled: true, hintText: 'Password', hintStyle: TextStyle(color: Colors.grey[500])),),),
                          const SizedBox(height: 20,),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child:TextFormField(style: TextStyle(color: black54),textInputAction: TextInputAction.next, validator: validateConfirmPassword, onSaved:(value) {controller.password=value!;}, decoration: InputDecoration(enabledBorder:  OutlineInputBorder(borderRadius:BorderRadius.circular(20),borderSide: const BorderSide(color: Colors.white),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400),), fillColor: Colors.grey.shade200, filled: true, hintText: 'Conferma password', hintStyle: TextStyle(color: Colors.grey[500])),),),],),),
                    Padding(padding: const EdgeInsets.only(left: 50,right: 50,bottom: 20,top: 30),
                      child: Container(height: 50, width: double.infinity, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                        child: CupertinoButton(onPressed: () {_formKey.currentState!.save();if (_formKey.currentState!.validate()) {controller.createAccountWithEmailAndPassword();}}, borderRadius: const BorderRadius.all(Radius.circular(10)),color: marrone, child: const Text("Registrati", style: TextStyle(color:  Colors.white,fontFamily: 'PlayfairDisplay', fontWeight: FontWeight.w700,letterSpacing: 1, fontSize: 16)),),),),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("sei già iscritto?",style: TextStyle(color: Colors.grey[700],fontSize: 12,fontFamily: 'PlayfairDisplay'),),
                      const SizedBox(width: 5,),
                      GestureDetector(onTap:() {
                        Get.to(const LoginView());
                      },child:  Text("Vai al login",style: TextStyle(color: marrone,fontFamily: 'PlayfairDisplay',fontSize:15,fontWeight: FontWeight.w800),),),],),],),),),),),),);}

}
