// To parse this JSON data, do
//
//     final procedure = procedureFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/material.dart';

List<Procedure> procedureFromJson(String str) =>
    List<Procedure>.from(json.decode(str).map((x) => Procedure.fromJson(x)));

String procedureToJson(List<Procedure> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Procedure {
  Procedure({
    this.id,
    this.name,
    this.description,
    this.price,
    this.isFavourite,
    this.categoryId,
    this.categoryName,
  });

  int? id;
  String? name;
  dynamic description;
  double? price;
  bool? isFavourite;
  int? categoryId;
  String? categoryName;

  factory Procedure.fromJson(Map<String, dynamic> json) => Procedure(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"].toDouble(),
        isFavourite: json["isFavourite"],
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "isFavourite": isFavourite,
        "categoryId": categoryId,
        "categoryName": categoryName,
      };
}
