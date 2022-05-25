import 'package:countie/screens/sign_in_screen.dart';
import 'package:countie/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'SummaryPage.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  SecureStorage secureStorage = SecureStorage();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
          color: Colors.grey[200],
          child: ListView(children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            buildMenuItem(
                icon: Icons.person, title: 'Profil', onClicked: () {}),
            buildMenuItem(
              icon: MdiIcons.chartBar,
              title: 'Podsumowanie',
              onClicked: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryPage(date: DateTime.now()),
                  ),
                );
              },
            ),
            buildMenuItem(
                icon: MdiIcons.database,
                title: 'Baza danych',
                onClicked: () {}),
            buildMenuItem(
                icon: Icons.settings, title: 'Ustawienia', onClicked: () {}),
            buildMenuItem(
                icon: Icons.help_outline, title: 'Pomoc', onClicked: () {}),
            Divider(
              color: Colors.blue,
              thickness: 0.8,
              indent: 20,
              endIndent: 20,
            ),
            buildMenuItem(
                icon: MdiIcons.informationVariant,
                title: 'O Autorze',
                onClicked: () {}),
            buildMenuItem(
                icon: Icons.logout_rounded,
                title: 'Wyloguj',
                onClicked: () {
                  secureStorage.deleteSecureData("token").whenComplete(() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  });
                }),
            buildMenuItem(
                icon: Icons.exit_to_app,
                title: 'Wyjdź z aplikacji',
                onClicked: () {
                  SystemNavigator.pop();
                }),
          ])),
    );
  }

  Widget buildMenuItem({
    required String title,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.blue;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      onTap: onClicked,
    );
  }
}
