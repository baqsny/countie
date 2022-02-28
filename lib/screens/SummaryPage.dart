import 'package:countie/models/DailySummaryModel.dart';
import 'package:countie/models/Summary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../services/ApiManager.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Podsumowanie'),
            bottom: TabBar(labelPadding: EdgeInsets.zero, tabs: [
              Tab(
                text: 'Dzienne',
              ),
              Tab(
                text: 'Miesięczne',
              )
            ]),
          ),
          body: TabBarView(children: [
            DailySummary(),
            MonthlySummary(),
          ]),
        ));
  }
}

class DailySummary extends StatefulWidget {
  const DailySummary({Key? key}) : super(key: key);

  @override
  _DailySummaryState createState() => _DailySummaryState();
}

class _DailySummaryState extends State<DailySummary> {
  DateTime date = DateTime.now();
  Future<DailySummaryModel>? _summary;
  bool? isLoading;
  @override
  void initState() {
    isLoading = true;

    super.initState();
    _summary = ApiManager().getDailySummary(date.toIso8601String());
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<DailySummaryModel>(
            future: _summary,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.dailyProcedureSummaryList!.isNotEmpty
                    ? ListView.builder(
                        itemCount:
                            snapshot.data!.dailyProcedureSummaryList!.length,
                        itemBuilder: (context, index) {
                          var summary =
                              snapshot.data!.dailyProcedureSummaryList![index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Card(
                              child: ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 5.0),
                                tileColor: index % 2 == 0
                                    ? Colors.grey[200]
                                    : Colors.grey[300],
                                title: Text(
                                  summary.procedureName!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      summary.procedurePrice!
                                              .toStringAsFixed(2) +
                                          ' zł',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        padding: EdgeInsets.zero,
                        color: Colors.white,
                        constraints: BoxConstraints.expand(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(MdiIcons.playlistRemove,
                                size: 250, color: Colors.grey[300]),
                            Text('Coś pusto tutaj,',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25, color: Colors.grey[300])),
                            Text('naciśnij "+" aby dodać procedurę.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey[300]))
                          ],
                        ),
                      );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}

class MonthlySummary extends StatefulWidget {
  const MonthlySummary({Key? key}) : super(key: key);

  @override
  _MonthlySummaryState createState() => _MonthlySummaryState();
}

class _MonthlySummaryState extends State<MonthlySummary> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('miesieczne'),
    );
  }
}
