import 'package:countie/screens/AddProceduresToPlannerPage.dart';
import 'package:countie/screens/HomePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:countie/services/ApiManager.dart';
import 'package:countie/models/Planner.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'AddProcedurePage.dart';
import 'package:countie/screens/SummaryPage.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final DateFormat niceFormatter = DateFormat('yyyy-MM-dd');

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  DateTime? date;
  DateTime? todayDate = DateTime.now();
  String? selectedDayString;
  String? todayDateString;

  @override
  void initState() {
    isLoading = true;

    super.initState();
    _focusedDay = _selectedDay!;
    _planner = ApiManager().getPlanners(formatter.format(_focusedDay));
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pl-PL', null);
    selectedDayString = niceFormatter.format(_selectedDay!);
    todayDateString = formatter.format(todayDate!);

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue,
          centerTitle: true,
          toolbarHeight: 56,
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(20)))),
          title: InkWell(
            onTap: () {
              setState(() {
                _selectedDay = DateTime.now();
                _planner = ApiManager().getPlanners(todayDateString!);
              });
            },
            child:
                Text('podliczajka', style: GoogleFonts.pacifico(fontSize: 25)),
          )),
      body: Column(
        children: <Widget>[
          buildCalendar(),
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Text('$selectedDayString',
                    style: GoogleFonts.lato(
                        fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 15, top: 5),
          ),
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
                          ? ListView.builder(
                              itemCount: snapshot.data!.plannersList!.length,
                              itemBuilder: (context, index) {
                                var planner =
                                    snapshot.data!.plannersList![index];
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
                                      subtitle:
                                          Text(planner.categoryName.toString()),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            planner.procedurePrice!
                                                    .toStringAsFixed(2) +
                                                ' zł',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                            onPressed: () async {
                                              await ApiManager
                                                  .deleteProcedureFromPlanner(
                                                      _selectedDay!,
                                                      planner.plannerId!);
                                              setState(() {
                                                _planner = ApiManager()
                                                    .getPlanners(formatter
                                                        .format(_focusedDay));
                                              });
                                            },
                                            icon: Icon(Icons.close),
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
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: addButton(),
    );
  }

  Widget buildCalendar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
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
          }
        },
        headerVisible: false,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: CalendarStyle(
          defaultTextStyle: TextStyle(color: Colors.white),
          weekendTextStyle: TextStyle(color: Colors.red),
          selectedTextStyle:
              TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.white),
          weekendStyle: TextStyle(color: Colors.red),
          dowTextFormatter: (date, locale) =>
              DateFormat.E('pl-PL').format(date)[0].toUpperCase(),
        ),
      ),
    );
  }

  Widget addButton() => FloatingActionButton(
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
        elevation: 0,
        backgroundColor: Colors.blue[900],
        child: Icon(
          Icons.add,
          size: 40,
        ),
      );
}
