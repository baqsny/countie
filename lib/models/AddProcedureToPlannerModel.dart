class AddProcedureToPlanner {
  String? date;
  int? procedureId;

  AddProcedureToPlanner({
    this.date,
    this.procedureId,
  });

  Map<String, dynamic> toJson() {
    return {"date": date, "procedureId": procedureId};
  }
}
