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
  FocusNode inputNode = FocusNode();

  List<Procedure>? _procedures;
  int itemQuantity = 1;
  bool? _loading;
  String query = '';
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final TextEditingController itemQuantityController = TextEditingController();

  Timer? debouncer;

  @override
  void initState() {
    _loading = true;
    super.initState();
    ApiManager.getProcedures(query).then(
      (procedures) {
        _procedures = procedures;
        _loading = false;
        setState(() {});
      },
    );
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
    String selectedDate = DateFormat.yMMMMd('pl-PL').format(widget.testDate);
    return Scaffold(
      appBar: AppBar(
        title: Text(_loading! ? 'Ładowanie procedur...' : 'Lista procedur'),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            size: 30,
          ),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          buildSearchBar(),
          Expanded(
            child: ListView.builder(
              itemCount: _procedures != null ? _procedures!.length : 0,
              itemBuilder: (context, index) {
                Procedure procedure = _procedures![index];

                return buildItemCard(index);
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

  Card buildItemCard(int index) {
    Procedure procedure = _procedures![index];
    final String testDateString = formatter.format(widget.testDate);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(procedure.categoryName.toString(),
                style: TextStyle(fontSize: 16)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    itemQuantity = 1;
                    await showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(content: StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              var height =
                                  MediaQuery.of(context).size.height * 0.2;
                              var width =
                                  MediaQuery.of(context).size.width * 0.8;

                              return Container(
                                height: height,
                                width: width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Ilość',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              itemQuantity = itemQuantity - 1;
                                            });
                                          },
                                          icon: Icon(Icons.remove_circle),
                                        ),
                                        Container(
                                          width: 50,
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            controller: itemQuantityController,
                                            keyboardType: TextInputType.none,
                                            decoration: InputDecoration(
                                              hintText: itemQuantity.toString(),
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 3,
                                                    color: Colors.blue),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            readOnly: true,
                                            enabled: false,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              itemQuantity = itemQuantity + 1;
                                            });
                                          },
                                          icon: Icon(Icons.add_circle),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        final procedureToAdd =
                                            AddProcedureToPlanner(
                                                date: testDateString,
                                                procedureId: procedure.id);
                                        final result = await ApiManager
                                            .postProcedureToPlanner(
                                                procedureToAdd);
                                        Navigator.pop(context, true);
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        Navigator.pop(context, true);
                                      },
                                      icon: const Icon(
                                        Icons.keyboard_arrow_right,
                                        size: 35,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ));
                        });
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_right,
                    size: 35,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final procedureToAdd = AddProcedureToPlanner(
                        date: testDateString, procedureId: procedure.id);
                    final result =
                        await ApiManager.postProcedureToPlanner(procedureToAdd);
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(
                    Icons.keyboard_double_arrow_right,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
