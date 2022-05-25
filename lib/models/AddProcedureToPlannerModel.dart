class AddProcedureToPlanner {
  String? date;
  int? procedureId;
  int? itemQuantity = 1;

  AddProcedureToPlanner({
    this.date,
    this.procedureId,
    this.itemQuantity,
  });

  Map<String, dynamic> toJson() {
    return {"date": date, "procedureId": procedureId};
  }
}
