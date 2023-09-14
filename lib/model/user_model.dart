import 'fossil.dart';

class UserModel {
  String? userId, nome, email, password;
  List<dynamic>? lista_fossili;

  UserModel({required this.userId, required this.nome, required this.email, required this.password,required this.lista_fossili});

  UserModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    userId = map['userId'];
    nome = map['nome'];
    email = map['email'];
    password=map['password'];
    lista_fossili=map['lista_fossili'];
  }

  toJson() {
    return {
      'userId': userId,
      'nome': nome,
      'email': email,
      'password': password,
      'lista_fossili':lista_fossili,
    };
  }
}
