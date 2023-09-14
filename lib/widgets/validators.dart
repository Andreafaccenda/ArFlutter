String? validateEmail(String? value){
  if(value == null || value.isEmpty){
    return 'Indirizzo email richiesto!';
  }else if(!value.contains('@') || !value.contains('.')){
    return 'Indirizzo email non valido';
  }
  return null;
}

String? validateName(String? value){
  if(value == null || value.isEmpty){
    return 'Nome richiesto!';
  }
  return null;
}

String? validatePassword(String? value){
  if(value == null || value.isEmpty){
    return 'Password richiesta!';
  }else if(value.length <= 5){
    return 'Password non valida';
  }
  return null;
}

String? validateConfirmPassword(String? value){
  if(value == null || value.isEmpty){
    return 'Per favore ripeti la password!';
  }else if(validatePassword(value)== value){
    return 'Password diverse';
  }
  return null;
}