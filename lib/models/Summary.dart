// To parse this JSON data, do
//
//     final summary = summaryFromJson(jsonString);

import 'dart:convert';

Summary summaryFromJson(String str) => Summary.fromJson(json.decode(str));

String summaryToJson(Summary data) => json.encode(data.toJson());

class Summary {
  Summary({
    this.date,
    this.period,
    this.periodTotalQuantity,
    this.periodTotalSum,
    this.procedureForSummaryList,
  });

  DateTime? date;
  String? period;
  int? periodTotalQuantity;
  double? periodTotalSum;
  List<ProcedureForSummaryList>? procedureForSummaryList;

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        date: DateTime.parse(json["date"]),
        period: json["period"],
        periodTotalQuantity: json["periodTotalQuantity"],
        periodTotalSum: json["periodTotalSum"].toDouble(),
        procedureForSummaryList: List<ProcedureForSummaryList>.from(
            json["procedureForSummaryList"]
                .map((x) => ProcedureForSummaryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date!.toIso8601String(),
        "period": period,
        "periodTotalQuantity": periodTotalQuantity,
        "periodTotalSum": periodTotalSum,
      };
}

class ProcedureForSummaryList {
  ProcedureForSummaryList({
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

  factory ProcedureForSummaryList.fromJson(Map<String, dynamic> json) =>
      ProcedureForSummaryList(
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
