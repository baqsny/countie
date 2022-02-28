// To parse this JSON data, do
//
//     final dailySummaryModel = dailySummaryModelFromJson(jsonString);

import 'dart:convert';

DailySummaryModel dailySummaryModelFromJson(String str) =>
    DailySummaryModel.fromJson(json.decode(str));

String dailySummaryModelToJson(DailySummaryModel data) =>
    json.encode(data.toJson());

class DailySummaryModel {
  DailySummaryModel({
    this.date,
    this.dailyQuantity,
    this.dailySum,
    this.dailyProcedureSummaryList,
  });

  DateTime? date;
  int? dailyQuantity;
  double? dailySum;
  List<DailyProcedureSummaryList>? dailyProcedureSummaryList;

  factory DailySummaryModel.fromJson(Map<String, dynamic> json) =>
      DailySummaryModel(
        date: DateTime.parse(json["date"]),
        dailyQuantity: json["dailyQuantity"],
        dailySum: json["dailySum"].toDouble(),
        dailyProcedureSummaryList: List<DailyProcedureSummaryList>.from(
            json["dailyProcedureSummaryList"]
                .map((x) => DailyProcedureSummaryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date!.toIso8601String(),
        "dailyQuantity": dailyQuantity,
        "dailySum": dailySum,
        "dailyProcedureSummaryList": List<dynamic>.from(
            dailyProcedureSummaryList!.map((x) => x.toJson())),
      };
}

class DailyProcedureSummaryList {
  DailyProcedureSummaryList({
    this.procedureId,
    this.procedureName,
    this.procedurePrice,
    this.quantity,
    this.procedureSum,
  });

  int? procedureId;
  String? procedureName;
  double? procedurePrice;
  int? quantity;
  double? procedureSum;

  factory DailyProcedureSummaryList.fromJson(Map<String, dynamic> json) =>
      DailyProcedureSummaryList(
        procedureId: json["procedureId"],
        procedureName: json["procedureName"],
        procedurePrice: json["procedurePrice"].toDouble(),
        quantity: json["quantity"],
        procedureSum: json["procedureSum"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "procedureId": procedureId,
        "procedureName": procedureName,
        "procedurePrice": procedurePrice,
        "quantity": quantity,
        "procedureSum": procedureSum,
      };
}
