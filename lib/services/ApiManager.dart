import 'dart:convert';

import 'package:countie/models/Summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:countie/models/Category.dart';
import 'package:countie/models/Procedure.dart';
import 'package:countie/models/Planner.dart';
import 'package:countie/models/AddProcedureToPlannerModel.dart';
import 'package:countie/constants/Strings.dart';
import 'package:countie/models/ApiResponseModel.dart';

import '../models/DailySummaryModel.dart';

class ApiManager {
  var planner = null;
  var summary = null;

  static const headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse(Strings.getAllCategoriesUrl));
      if (response.statusCode == 200) {
        List<Category> categoryList = categoryFromJson(response.body);
        return categoryList;
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  static Future<List<Procedure>> getProcedures(String query) async {
    try {
      final response = await http.get(Uri.parse(Strings.getAllProceduresUrl));
      if (response.statusCode == 200) {
        List<Procedure> proceduresList =
            procedureFromJson(response.body).where((procedure) {
          final procedureNameLower = procedure.name!.toLowerCase();
          final searchLower = query.toLowerCase();

          return procedureNameLower.contains(searchLower);
        }).toList();
        return proceduresList;
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  Future<Planner> getPlanners(String date) async {
    try {
      final response = await http.get(Uri.parse(Strings.planner_url + date));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        planner = Planner.fromJson(jsonMap);
      }
    } catch (e) {
      return planner;
    }
    return planner;
  }

  Future<Summary> getSummary(String date) async {
    try {
      final response =
          await http.get(Uri.parse(Strings.summary_url + 'month/' + date));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        summary = Summary.fromJson(jsonMap);
      }
    } catch (e) {
      return summary;
    }
    return summary;
  }

  Future<DailySummaryModel> getDailySummary(String date) async {
    try {
      final response =
          await http.get(Uri.parse(Strings.summary_url + 'day/' + date));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        summary = DailySummaryModel.fromJson(jsonMap);
      }
    } catch (e) {
      return summary;
    }
    return summary;
  }

  static Future<APIResponse<bool>> postProcedureToPlanner(
      AddProcedureToPlanner item) {
    return http
        .post(Uri.parse(Strings.planner_url),
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'error post');
    }).catchError(
            (_) => APIResponse<bool>(error: true, errorMessage: 'error post'));
  }

  static Future<APIResponse<bool>> deleteProcedureFromPlanner(
      DateTime date, int plannerId) {
    return http
        .delete(
            Uri.parse(Strings.planner_url +
                date.toIso8601String() +
                '/' +
                plannerId.toString()),
            headers: headers)
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'error delete');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'error delete'));
  }
}
