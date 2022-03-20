import 'package:countie/models/Category.dart';
import 'package:countie/models/Procedure.dart';
import 'package:countie/services/ApiManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class AddProcedurePage extends StatefulWidget {
  const AddProcedurePage({Key? key}) : super(key: key);

  @override
  _AddProcedureFormState createState() => _AddProcedureFormState();
}

class _AddProcedureFormState extends State<AddProcedurePage> {
  String? category;
  List<Category>? categories;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  //final

  @override
  void initState() {
    super.initState();
    ApiManager.getCategories().then((categories) {
      this.categories = categories;
      //setState(() {});
    });
  }

  var selectedType;
  var isSelected = false;
  var icon = Icons.favorite_border;

  final formKey = GlobalKey<FormState>();
  String username = '';
  double? price = null;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusScope.of(context).unfocus()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Nowa procedura'),
          actions: <Widget>[
            saveButton(),
          ],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.all(16),
            children: <Widget>[
              buildProcedureName(),
              const SizedBox(
                height: 15,
              ),
              buildProcedurePrice(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: buildCategoryList()),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                  child: Row(
                children: [
                  SizedBox(width: 5),
                  Text('Dodaj procedurę do ulubionych!',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  Spacer(),
                  buildAddToFavouriteButton(),
                ],
              )),
              const SizedBox(height: 20),
              buildProcedureDescription(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryList() => DropdownButton(
        isExpanded: true,
        hint: Text('Wybierz kategorię'),
        value: category,
        items: categories?.map((item) {
          return DropdownMenuItem(
            value: item.name,
            child: Text(item.name.toString()),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            category = value.toString();
            //print()
          });
        },
      );
  Widget buildAddToFavouriteButton() => IconButton(
        icon: Icon(icon),
        iconSize: 35,
        color: Color.fromARGB(255, 223, 70, 121),
        onPressed: () {
          // Respond to icon toggle
          setState(() {
            isSelected = !isSelected;
            if (isSelected) {
              icon = Icons.favorite_rounded;
            } else {
              icon = Icons.favorite_border;
            }
          });
        },
      );
  Widget buildProcedureName() => TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          labelText: 'Nazwa*',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.length < 3 || value.length > 25) {
            return 'Wprowadź 3-25 znaków';
          } else {
            return null;
          }
        },
        onChanged: (value) => setState(() {
          username = value;
        }),
      );

  Widget buildProcedurePrice() => TextFormField(
        controller: priceController,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
        ],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: 'Cena*',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          value = value?.replaceAll(',', '.');
          if (value!.isEmpty || double.tryParse(value) == null) {
            return 'Wprowadź poprawną cenę';
          } else {
            return null;
          }
        },
        onChanged: (value) => setState(() {
          username = value;
        }),
      );

  Widget buildProcedureDescription() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Opis',
          border: OutlineInputBorder(),
        ),
        maxLines: 6,
        minLines: 1,
      );
  Widget saveButton() => TextButton(
        style: TextButton.styleFrom(
          primary: Colors.white,
          textStyle: const TextStyle(
            fontSize: 18,
          ),
        ),
        onPressed: () {
          final isValid = formKey.currentState?.validate();
          if (isValid == true) {
            // Procedure procedure = new Procedure(
            //   name : nameController.text,
//price: double.parse(priceController.value),
            // )

          }
        },
        child: Text('Zapisz'),
      );

  void saveProcedure() async {
    //var saveResponse = await ApiManager.postProcedure(procedure);
  }
}
