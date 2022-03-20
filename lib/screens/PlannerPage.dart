import 'package:countie/screens/AddProceduresToPlannerPage.dart';
import 'package:countie/screens/HomePage.dart';
import 'package:countie/screens/SummaryPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:countie/services/ApiManager.dart';
import 'package:countie/models/Planner.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../widget/RefreshWidget.dart';
import 'AddProcedurePage.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:calendar_strip/calendar_strip.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({Key? key}) : super(key: key);

  @override
  _PlannerPageState createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  Future<Planner>? _planner;
  bool? isLoading;

  CalendarFormat _calendarFormat = CalendarFormat.week;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  DateTime? date;
  DateTime? todayDate = DateTime.now();
  int? counter;

  @override
  void initState() {
    isLoading = true;

    super.initState();
    loadData();
  }

  Future loadData() async {
    Future.delayed(Duration(milliseconds: 800));
    _focusedDay = _selectedDay!;
    _planner = ApiManager().getPlanners(formatter.format(_focusedDay));
    isLoading = false;
    counter = getListLength(0);
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pl-PL', null);

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue,
          centerTitle: true,
          toolbarHeight: 56,
          title: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              setState(() {
                _selectedDay = DateTime.now();
                _planner =
                    ApiManager().getPlanners(formatter.format(todayDate!));
                _focusedDay = _selectedDay!;
              });
            },
            child:
                Text('podliczajka', style: GoogleFonts.pacifico(fontSize: 25)),
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildCalendar(),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                child: FutureBuilder<Planner>(
                  future: _planner,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.plannersList!.isNotEmpty
                          ? RefreshWidget(
                              onRefresh: () => loadData(),
                              child: ListView.builder(
                                itemCount: snapshot.data!.plannersList!.length,
                                itemBuilder: (context, index) {
                                  var planner =
                                      snapshot.data!.plannersList![index];
                                  counter = getListLength(
                                      snapshot.data!.plannersList!.length);
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
                                          planner.procedureName!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        subtitle: Text(
                                            planner.categoryName.toString()),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(),
                                              onPressed: () async {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            AlertDialog(
                                                              title: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .info_outline,
                                                                    size: 60,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  Text(
                                                                    'Czy na pewno chcesz usunąć procedurę?',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      await ApiManager.deleteProcedureFromPlanner(
                                                                          _selectedDay!,
                                                                          planner
                                                                              .plannerId!);
                                                                      Navigator.pop(
                                                                          context);
                                                                      setState(
                                                                          () {
                                                                        _planner =
                                                                            ApiManager().getPlanners(formatter.format(_focusedDay));
                                                                      });
                                                                    },
                                                                    child: Text(
                                                                        'Tak')),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        'Anuluj'))
                                                              ],
                                                            ));
                                              },
                                              icon: Icon(Icons.close),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
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
                                          fontSize: 25,
                                          color: Colors.grey[300])),
                                  Text('naciśnij "+" aby dodać procedurę.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[300]))
                                ],
                              ),
                            );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: goToSummaryBar(),
              ),
              Expanded(
                flex: 3,
                child: addButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int getListLength(int i) {
    counter = i;
    return counter!;
  }

  Widget goToSummaryBar() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
            ),
          ],
        ),
        child: TextButton(
            onPressed: () async {
              date = _selectedDay;
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SummaryPage(date: date),
                ),
              );
            },
            child: Row(children: [
              Icon(Icons.arrow_forward_ios),
              SizedBox(
                width: 10,
              ),
              Icon(MdiIcons.chartDonut),
              SizedBox(
                width: 5,
              ),
              Container(
                  child: FutureBuilder<Planner>(
                      future: _planner,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.plannersList!.length != 0) {
                            return Text(
                              snapshot.data!.plannersList!.length.toString() +
                                  ' procedur',
                              style: TextStyle(fontSize: 20),
                            );
                          } else {
                            return Text('Brak procedur!');
                          }
                        }
                        return Text('Ładowanie procedur...');
                      })),
            ])));
  }

  Widget buildCalendar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      child: TableCalendar(
        rangeSelectionMode: RangeSelectionMode.disabled,
        firstDay: DateTime.utc(2020, 01, 01),
        lastDay: DateTime.utc(2040, 01, 01),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              _planner =
                  ApiManager().getPlanners(formatter.format(_selectedDay!));
            });
          } else {
            showDatePicker(
                    context: context,
                    initialDate: _selectedDay!,
                    firstDate: DateTime.utc(2020, 01, 01),
                    lastDate: DateTime(DateTime.now().year + 10),
                    locale: Locale('pl', ''))
                .then(
              (date) => setState(
                () {
                  if (date == null) {
                    return;
                  }
                  _selectedDay = date;
                  _focusedDay = _selectedDay!;
                  _planner =
                      ApiManager().getPlanners(formatter.format(_focusedDay));
                },
              ),
            );
          }
        },
        headerVisible: false,
        daysOfWeekHeight: 15,
        rowHeight: 50,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: CalendarStyle(
          cellAlignment: Alignment.center,
          cellMargin: EdgeInsets.all(5),
          rowDecoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
          ),
          outsideTextStyle: TextStyle(color: Colors.white),
          defaultTextStyle: TextStyle(color: Colors.white),
          weekendTextStyle: TextStyle(color: Colors.red),
          todayDecoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              shape: BoxShape.circle),
          selectedTextStyle:
              TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          selectedDecoration: BoxDecoration(
            color: Colors.lightBlue[100],
            shape: BoxShape.circle,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          decoration: BoxDecoration(color: Colors.transparent),
          weekdayStyle: TextStyle(color: Colors.white),
          weekendStyle: TextStyle(color: Colors.red),
          dowTextFormatter: (date, locale) =>
              DateFormat.E('pl-PL').format(date)[0].toUpperCase(),
        ),
      ),
    );
  }

  Widget addButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextButton(
        onPressed: () async {
          date = _selectedDay;
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProceduresToPlannerPage(testDate: date),
            ),
          );
          if (result == true) {
            setState(() {
              _planner =
                  ApiManager().getPlanners(formatter.format(_selectedDay!));
            });
          }
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
          Text('Dodaj', style: TextStyle(fontSize: 20, color: Colors.white))
        ]),
      ),
    );
  }
}
