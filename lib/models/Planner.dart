// To parse this JSON data, do
//
//     final planner = plannerFromJson(jsonString);

import 'dart:convert';

Planner plannerFromJson(String str) => Planner.fromJson(json.decode(str));

String plannerToJson(Planner data) => json.encode(data.toJson());

class Planner {
  Planner({
    this.date,
    this.plannersList,
  });

  DateTime? date;
  List<PlannersList>? plannersList;

  factory Planner.fromJson(Map<String, dynamic> json) => Planner(
        date: DateTime.parse(json["date"]),
        plannersList: List<PlannersList>.from(
            json["plannersList"].map((x) => PlannersList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date!.toIso8601String(),
        "plannersList":
            List<dynamic>.from(plannersList!.map((x) => x.toJson())),
      };
}

class PlannersList {
  PlannersList({
    this.plannerId,
    this.procedureName,
    this.procedurePrice,
    this.categoryName,
  });

  int? plannerId;
  String? procedureName;
  double? procedurePrice;
  String? categoryName;

  factory PlannersList.fromJson(Map<String, dynamic> json) => PlannersList(
        plannerId: json["plannerId"],
        procedureName: json["procedureName"],
        procedurePrice: json["procedurePrice"],
        categoryName: json["categoryName"],
      );

  Map<String, dynamic> toJson() => {
        "plannerId": plannerId,
        "procedureName": procedureName,
        "procedurePrice": procedurePrice,
        "categoryName": categoryName,
      };
}
