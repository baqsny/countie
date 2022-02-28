import 'dart:async';

import 'package:flutter/material.dart';
import 'package:countie/models/Procedure.dart';
import 'package:countie/services/ApiManager.dart';
import 'package:countie/models/AddProcedureToPlannerModel.dart';
import 'package:intl/intl.dart';
import 'package:countie/widget/SearchWidget.dart';

class AddProceduresToPlannerPage extends StatefulWidget {
  final testDate;

  const AddProceduresToPlannerPage({Key? key, this.testDate}) : super(key: key);

  @override
  _AddProceduresToPlannerPageState createState() =>
      _AddProceduresToPlannerPageState();
}

class _AddProceduresToPlannerPageState
    extends State<AddProceduresToPlannerPage> {
  //AddProcedureToPlannerModel? _procedureToPlanner;
  List<Procedure>? _procedures;
  bool? _loading;
  String query = '';
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  Timer? debouncer;

  @override
  void initState() {
    _loading = true;
    super.initState();
    ApiManager.getProcedures(query).then((procedures) {
      _procedures = procedures;
      _loading = false;
      setState(() {});
    });
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 500),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  @override
  Widget build(BuildContext context) {
    String selectedDate = formatter.format(widget.testDate);
    return Scaffold(
      appBar: AppBar(
        title: Text(_loading!
            ? 'Ładowanie procedur...'
            : 'Lista procedur: $selectedDate'),
      ),
      body: Column(
        children: <Widget>[
          buildSearchBar(),
          Expanded(
            child: ListView.builder(
              itemCount: null == _procedures ? 0 : _procedures!.length,
              itemBuilder: (context, index) {
                return _listItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() => SearchWidget(
        text: query,
        hintText: 'Nazwa procedury',
        onChanged: searchProcedure,
      );

  Future searchProcedure(String query) async => debounce((() async {
        final procedures = await ApiManager.getProcedures(query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          this._procedures = procedures;
        });
      }));

  Card _listItem(int index) {
    Procedure procedure = _procedures![index];
    final String testDateString = formatter.format(widget.testDate);

    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        horizontalTitleGap: 5,
        leading: IconButton(
          onPressed: () {},
          icon: procedure.isFavourite == true
              ? Icon(
                  Icons.favorite,
                  color: Colors.pink[300],
                  size: 30,
                )
              : Icon(
                  Icons.favorite_outline,
                  size: 30,
                ),
        ),
        title: Text(
          procedure.name!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(procedure.categoryName.toString(),
            style: TextStyle(fontSize: 16)),
        onTap: () {},
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              procedure.price!.toStringAsFixed(2) + ' zł',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            IconButton(
              onPressed: () async {
                final procedureToAdd = AddProcedureToPlanner(
                    date: testDateString, procedureId: procedure.id);
                final result =
                    await ApiManager.postProcedureToPlanner(procedureToAdd);
                Navigator.pop(context, true);
              },
              icon: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}
