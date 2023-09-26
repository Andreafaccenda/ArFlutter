

class Ammonite {
  String? id,nome,foto_locazione,descrAmmonite,foto,roccia,descrRoccia,zona,lat,long,periodo,indirizzo;

  Ammonite({required this.id,required this.nome,required foto_locazione,required this.descrAmmonite,required this.foto,
            required this.roccia,required this.descrRoccia,required this.zona,
            required this.lat,required this.long,required this.periodo,required this.indirizzo});

  Ammonite.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    id = map['id'];
    nome = map['nome'];
    foto_locazione = map['foto_locazione'];
    descrAmmonite = map['descrAmmonite'];
    foto = map['foto'];
    roccia = map['roccia'];
    descrRoccia = map['descrRoccia'];
    zona = map['zona'];
    lat = map['lat'];
    long = map['long'];
    periodo = map['periodo'];
    indirizzo = map['indirizzo'];
  }

  toJson() {
    return {
      'id' : id,
      'nome': nome,
      'foto_locazione' : foto_locazione,
      'descrAmmonite': descrAmmonite,
      'foto': foto,
      'roccia': roccia,
      'descrRoccia': descrRoccia,
      'zona': zona,
      'lat': lat,
      'long': long,
      'periodo': periodo,
      'indirizzo': indirizzo,
    };
  }
}