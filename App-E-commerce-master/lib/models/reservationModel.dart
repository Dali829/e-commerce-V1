import 'dart:convert';

List<ReservationModel> ReservationModelFromJson(String str) =>
    List<ReservationModel>.from(
        json.decode(str).map((x) => ReservationModel.fromMap(x)));

class ReservationModel {
  String id;
  String datedebut;
  String datefin;
  int prix;
  String productName;
  String statut;
  String emailAgent;
  int numbrJour;
  String nameAgent;
  ReservationModel(
      {required this.id,
      required this.productName,
      required this.prix,
      required this.datedebut,
      required this.datefin,
      required this.emailAgent,
      required this.numbrJour,
      required this.statut,
      required this.nameAgent});
  factory ReservationModel.fromMap(Map<String, dynamic> json) {
    return ReservationModel(
        statut: json['statut'],
        id: json['_id'],
        productName: json['product']['productName'],
        datedebut: json['datedebut'],
        datefin: json['datefin'],
        prix: json['prix'],
        emailAgent: json['agent']['email'],
        numbrJour: json['numbrJour'],
        nameAgent: json["agent"]["name"]);
  }
}
