import 'dart:convert';
import 'package:flutter/material.dart';

List<Category> categoryFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

class Category {
  Category({
    this.name,
    this.procedures,
  });
  String? name;
  List<dynamic>? procedures;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        procedures: List<dynamic>.from(json["procedures"].map((x) => x)),
      );
}
