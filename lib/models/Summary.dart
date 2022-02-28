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
  });

  DateTime? date;
  String? period;
  int? periodTotalQuantity;
  double? periodTotalSum;

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        date: DateTime.parse(json["date"]),
        period: json["period"],
        periodTotalQuantity: json["periodTotalQuantity"],
        periodTotalSum: json["periodTotalSum"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "date": date!.toIso8601String(),
        "period": period,
        "periodTotalQuantity": periodTotalQuantity,
        "periodTotalSum": periodTotalSum,
      };
}
