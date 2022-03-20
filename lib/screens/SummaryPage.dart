import 'package:countie/models/DailySummaryModel.dart';
import 'package:countie/models/Summary.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../services/ApiManager.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({Key? key, dynamic this.date}) : super(key: key);
  final date;

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Podsumowanie'),
            bottom: TabBar(labelPadding: EdgeInsets.zero, tabs: [
              Tab(
                text: 'Dzienne',
              ),
              Tab(
                text: 'Tygodniowe',
              ),
              Tab(
                text: 'Miesięczne',
              ),
              Tab(
                text: 'Dowolne',
              )
            ]),
          ),
          body: TabBarView(children: [
            DailySummary(
              date: widget.date,
            ),
            Text('Wkrótce dostępne'),
            MonthlySummary(
              date: widget.date,
            ),
            Text('Wkrótce dostępne')
          ]),
        ));
  }
}

class DailySummary extends StatefulWidget {
  const DailySummary({Key? key, dynamic this.date}) : super(key: key);
  final date;

  @override
  _DailySummaryState createState() => _DailySummaryState();
}

class _DailySummaryState extends State<DailySummary> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Future<DailySummaryModel>? _summary;
  bool? isLoading;
  @override
  void initState() {
    isLoading = true;

    super.initState();
    _summary = ApiManager().getDailySummary(formatter.format(widget.date));
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DailySummaryModel>(
          future: _summary,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, right: 20, left: 10),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  '${DateFormat.yMMMMd('pl-PL').format(widget.date)}',
                                  style: GoogleFonts.lato(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 150),
                              SizedBox(
                                child: Text('Ilość',
                                    style: GoogleFonts.lato(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                              ),
                              SizedBox(
                                child: Text('Suma',
                                    style: GoogleFonts.lato(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 180,
                                child: Text('Procedury',
                                    style: GoogleFonts.lato(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                              SizedBox(
                                child: Text('${snapshot.data!.dailyQuantity}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                child: Text(
                                  '${snapshot.data!.dailySum!.toStringAsFixed(2)} zł',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Container(
                          child: ListView.builder(
                            itemCount: snapshot
                                .data!.dailyProcedureSummaryList!.length,
                            itemBuilder: (context, index) {
                              var summary = snapshot
                                  .data!.dailyProcedureSummaryList![index];
                              return ClipRRect(
                                child: Card(
                                  elevation: 0,
                                  child: ListTile(
                                    dense: true,
                                    contentPadding:
                                        EdgeInsets.only(left: 8, right: 15),
                                    tileColor: Colors.transparent,
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          summary.procedureName!,
                                          style: TextStyle(
                                              fontSize: 12,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        Text(
                                          summary.procedurePrice!
                                                  .toStringAsFixed(2) +
                                              ' zł',
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: SizedBox(
                                      width: 100,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            summary.quantity.toString(),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            summary.procedureSum!
                                                    .toStringAsFixed(2) +
                                                ' zł',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class MonthlySummary extends StatefulWidget {
  const MonthlySummary({Key? key, dynamic this.date}) : super(key: key);
  final date;

  @override
  _MonthlySummaryState createState() => _MonthlySummaryState();
}

class _MonthlySummaryState extends State<MonthlySummary> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  Future<Summary>? _summary;

  bool? isLoading;
  @override
  void initState() {
    isLoading = true;

    super.initState();
    _summary = ApiManager().getSummary(formatter.format(widget.date));
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Summary>(
            future: _summary,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${DateFormat.MMMM('pl-PL').format(widget.date).toUpperCase()}',
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 150),
                          SizedBox(
                            child: Text('Ilość',
                                style: GoogleFonts.lato(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          ),
                          SizedBox(
                            child: Text('Suma',
                                style: GoogleFonts.lato(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 180,
                            child: Text('Procedury',
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                          SizedBox(
                            child: Text('${snapshot.data!.periodTotalQuantity}',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            child: Text(
                              '${snapshot.data!.periodTotalSum!.toStringAsFixed(2)} zł',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Container(
                            child: ListView.builder(
                              itemCount: snapshot
                                  .data!.procedureForSummaryList!.length,
                              itemBuilder: (context, index) {
                                var summary = snapshot
                                    .data!.procedureForSummaryList![index];
                                return ClipRRect(
                                  child: Card(
                                    elevation: 0,
                                    child: ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0.0, horizontal: 5.0),
                                      tileColor: Colors.transparent,
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            summary.procedureName!,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            summary.procedurePrice!
                                                    .toStringAsFixed(2) +
                                                ' zł',
                                            style: TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: SizedBox(
                                        width: 100,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              summary.quantity.toString(),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              summary.procedureSum!
                                                      .toStringAsFixed(2) +
                                                  ' zł',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
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
