import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/validators.dart';
import 'auth_view_model.dart';
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
                          Text( "Crea un account!", style: TextStyle(color: Colors.grey[700],fontSize: 30,fontWeight: FontWeight.w400),),
                          const SizedBox(height: 5,),
                          Text( "Per favore riempi tutti i campi",style: TextStyle(color: Colors.grey[700],fontSize: 14,fontWeight: FontWeight.w400),),],),),
                    Padding(padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: [
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child:TextFormField(style:const TextStyle(color: Colors.black38),textInputAction: TextInputAction.next, validator: validateName, onSaved:(value) {controller.nome=value!;}, decoration: InputDecoration(enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400),), fillColor: Colors.grey.shade200, filled: true, hintText: 'Username', hintStyle: TextStyle(color: Colors.grey[500])),),),
                          const SizedBox(height: 15,),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child:TextFormField(style:const TextStyle(color: Colors.black38),textInputAction: TextInputAction.next, validator: validateEmail, onSaved:(value) {controller.email=value!;}, decoration: InputDecoration(enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400),), fillColor: Colors.grey.shade200, filled: true, hintText: 'Email', hintStyle: TextStyle(color: Colors.grey[500])),),),
                          const SizedBox(height: 15,),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child:TextFormField(style:const TextStyle(color: Colors.black38),textInputAction: TextInputAction.next, validator: validatePassword, onSaved:(value) {controller.password=value!;}, decoration: InputDecoration(enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400),), fillColor: Colors.grey.shade200, filled: true, hintText: 'Password', hintStyle: TextStyle(color: Colors.grey[500])),),),
                          const SizedBox(height: 15,),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child:TextFormField(style:const TextStyle(color: Colors.black38),textInputAction: TextInputAction.next, validator: validateConfirmPassword, onSaved:(value) {controller.password=value!;}, decoration: InputDecoration(enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400),), fillColor: Colors.grey.shade200, filled: true, hintText: 'Conferma password', hintStyle: TextStyle(color: Colors.grey[500])),),),],),),
                    Padding(padding: const EdgeInsets.only(left: 50,right: 50,bottom: 20,top: 15),
                      child: Container(height: 50, width: double.infinity, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),),
                        child: CupertinoButton(onPressed: () {_formKey.currentState!.save();if (_formKey.currentState!.validate()) {controller.createAccountWithEmailAndPassword();}}, borderRadius: const BorderRadius.all(Radius.circular(10)),color: const Color.fromRGBO(210,180,140,1), child: const Text("Registrati", style: TextStyle(color:  Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),),),),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("sei già iscritto?",style: TextStyle(color: Colors.grey[700]),),
                      const SizedBox(width: 5,),
                      GestureDetector(onTap:() {
                        Get.to(LoginView());
                      },child: const Text("Vai al login!",style: TextStyle(color: Color.fromRGBO(210,180,140,1),),),),],),],),),),),),),);}

}
