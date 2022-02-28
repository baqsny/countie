import 'package:flutter/material.dart';
import 'package:countie/screens/AddProcedurePage.dart';
import 'SummaryPage.dart';
import 'AddProceduresToPlannerPage.dart';
import 'PlannerPage.dart';
import 'MorePage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  int _selectedIndex = 0;

  final pages = [
    PlannerPage(),
    SummaryPage(),
    MorePage(),
    MorePage(),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 10)
          ]),
      child: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        items: [
          BottomNavigationBarItem(
              label: 'Główna',
              icon: Icon(
                MdiIcons.toothOutline,
                size: 30,
              ),
              activeIcon: Icon(
                MdiIcons.tooth,
                size: 30,
              )),
          BottomNavigationBarItem(
            label: 'Podsumowanie',
            icon: Icon(
              Icons.pie_chart_outline,
              size: 30,
            ),
            activeIcon: Icon(
              Icons.pie_chart,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Baza',
            icon: Icon(
              MdiIcons.databaseOutline,
              size: 30,
            ),
            activeIcon: Icon(
              MdiIcons.database,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Więcej',
            icon: Icon(
              Icons.menu,
              size: 40,
            ),
          ),
        ],
        currentIndex: _selectedIndex,
      ),
    );
  }
}
