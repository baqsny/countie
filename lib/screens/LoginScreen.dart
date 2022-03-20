import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusScope.of(context).unfocus()),
      child: Scaffold(
          body: Form(
              key: formKey,
              child: ListView(
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  SizedBox(
                    height: 80,
                    child: Center(
                      child: Text(
                        'Zaloguj się',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  buildUsernameInput(),
                  SizedBox(
                    height: 5,
                  ),
                  buildPasswordInput(),
                  buildLoginButton(),
                  Row(children: <Widget>[
                    Expanded(
                        child: Divider(
                      thickness: 1,
                      indent: 5,
                      endIndent: 10,
                    )),
                    Text("lub"),
                    Expanded(
                        child: Divider(
                      thickness: 1,
                      indent: 10,
                      endIndent: 5,
                    )),
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 150,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: SignInButton(
                          Buttons.Google,
                          text: "Google",
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        width: 150,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: SignInButton(
                          Buttons.Facebook,
                          text: "Facebook",
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Nie masz konta?'),
                      TextButton(
                          onPressed: () {}, child: Text('Zarejestruj się!'))
                    ],
                  )
                ],
              ))),
    );
  }

  Widget buildLoginButton() =>
      TextButton(onPressed: () {}, child: Text('Zaloguj'));

  Widget buildSocialmediaLoginButton({
    required String title,
    required IconData icon,
    required Color backgroundColor,
    VoidCallback? onPress,
  }) {
    return ListTile(
      tileColor: backgroundColor,
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onTap: onPress,
    );
  }

  Widget buildUsernameInput() => TextFormField(
        controller: usernameController,
        decoration: InputDecoration(
          labelText: 'Nazwa użytkownika lub email',
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

  Widget buildPasswordInput() => TextFormField(
        controller: passwordController,
        decoration: InputDecoration(
          labelText: 'Hasło',
        ),
        validator: (value) {
          if (value!.length < 3 || value.length > 25) {
            return 'Wprowadź 3-25 znaków';
          } else {
            return null;
          }
        },
        onChanged: (value) => setState(() {
          password = value;
        }),
      );
}
