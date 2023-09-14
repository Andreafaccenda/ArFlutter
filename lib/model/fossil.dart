class FossilModel{
  String? id, nome,descrizione,immagine,latitudine,longitudine,indirizzo;
  //List<dynamic>? lista_user;




  FossilModel({required this.id, required this.nome,required this.descrizione,required this.immagine,
    required this.latitudine,required this.longitudine,required indirizzo});

  FossilModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    id = map['id'];
    nome = map['nome'];
    descrizione=map['descrizione'];
    immagine = map['immagine'];
    latitudine=map['latitudine'];
    longitudine=map['longitudine'];
    indirizzo = map['indirizzo'];
  }

  toJson() {
    return {
      'id': id,
      'nome': nome,
      'immagine': immagine,
      'descrizione': descrizione,
      'latitudine':latitudine,
      'longitudine':longitudine,
      'indirizzo': indirizzo,
    };
  }
}