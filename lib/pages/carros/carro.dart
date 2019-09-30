import 'dart:convert' as convert;

import 'package:carros/utils/event_bus.dart';
import 'package:carros/utils/sql/entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CarroEvent extends Event {
  //Salvar, deletar

  String acao;

  //classicos, esportivos, luxos

  String tipo;

  CarroEvent(this.acao, this.tipo);

  @override
  String toString() {
    return 'CarroEvent{acao: $acao, tipo: $tipo}';
  }
}

class Carro extends Entity {
  int id;
  String nome;
  String tipo;
  String descricao;
  String urlFoto;
  String urlVideo;
  String latitude;
  String longitude;

  Carro(
      {this.id,
      this.nome,
      this.tipo,
      this.descricao,
      this.urlFoto,
      this.urlVideo,
      this.latitude,
      this.longitude});

//  Carro.fromJson(Map<String, dynamic> json) {
//    id = json['id'];
//    nome = json['nome'];
//    tipo = json['tipo'];
//    descricao = json['descricao'];
//    urlFoto = json['urlFoto'];
//    urlVideo = json['urlVideo'];
//    latitude = json['latitude'];
//    longitude = json['longitude'];
//  }

  factory Carro.fromJson(Map<String, dynamic> json) {
    return Carro(
      //id: int.parse(json["id"]),
      nome: json["nome"],
      //tipo: json["tipo"],
      descricao: json["descricao"],
      urlFoto: json["urlFoto"],
      //urlVideo: json["urlVideo"],
      //latitude: json["latitude"],
      //longitude: json["longitude"],
    );
  }

  Carro.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    tipo = map['tipo'];
    descricao = map['descricao'];
    urlFoto = map['urlFoto'];
    urlVideo = map['urlVideo'];
    latitude = map['latitude'];
    longitude = map['longitude'];
  }

//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['id'] = this.id;
//    data['nome'] = this.nome;
//    data['tipo'] = this.tipo;
//    data['descricao'] = this.descricao;
//    data['urlFoto'] = this.urlFoto;
//    data['urlVideo'] = this.urlVideo;
//    data['latitude'] = this.latitude;
//    data['longitude'] = this.longitude;
//    return data;
//  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['tipo'] = this.tipo;
    data['descricao'] = this.descricao;
    data['urlFoto'] = this.urlFoto;
    data['urlVideo'] = this.urlVideo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    if (this.id != null) {
      data["id"] = this.id;
    }
    return data;
  }

  String toJson() {
    String json = convert.json.encode(toMap());
    return json;
  }

  get latlng => LatLng(
      latitude == null || latitude.isEmpty ? 0.0 : double.parse(latitude),
      longitude == null || longitude.isEmpty ? 0.0 : double.parse(longitude));
}
