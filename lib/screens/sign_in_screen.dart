import 'dart:async';
import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:countie/screens/HomePage.dart';
import 'package:countie/screens/sign_up_screen.dart';
import 'package:countie/services/secure_storage_service.dart';

import '../constants/Strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isDisabled = false;
  bool isLoginng = false;

  final formKey = GlobalKey<FormState>();

  final SecureStorage secureStorage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() => FocusScope.of(context).unfocus()),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            widthFactor: 100,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 80,
                    child: Center(
                      child: Text(
                        'Zaloguj się',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 35),
                      ),
                    ),
                  ),
                  signInForm(),
                  forgetPasswordButton(),
                  buildLoginButton(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Nie masz konta?'),
                      signUpButton()
                    ],
                  ),
                ]),
          ),
        ));
  }

  Widget buildLoginButton() => Container(
        padding: const EdgeInsets.only(right: 40, left: 40, top: 30),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
            onPressed: isLoginng
                ? null
                : () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isLoginng = true;
                      });
                      login(emailController.text, passwordController.text);
                    }
                  },
            style: ElevatedButton.styleFrom(fixedSize: const Size(0, 50)),
            child: isLoginng
                ? const CircularProgressIndicator(color: Colors.grey)
                : const Text(
                    'Zaloguj',
                    style: TextStyle(fontSize: 25),
                  )),
      );

  Widget signInForm() => Form(
        key: formKey,
        child: Column(
          children: [
            emailInputForm(),
            passwordInputForm(),
          ],
        ),
      );

  void login(String email, String password) async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var response = await http.post(Uri.parse(Strings.login_user),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          },
          body: jsonEncode({
            'email': email,
            'password': password,
          }));
      if (response.statusCode == 200) {
        final body = await jsonDecode(response.body);
        await secureStorage.writeSecureData("token", body);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else if (response.statusCode == 502) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Nie udało połączyć się z serwerem :(')));
      } else if (response.statusCode == 400) {
        Timer(const Duration(milliseconds: 1200), () {
          setState(() {
            isLoginng = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
                'Wystąpił problem przy próbie zalogowania się. Sprawdź adres e-mail i hasło.'),
            backgroundColor: Colors.red[600],
          ));
        });
      }
    }
  }

  Widget signUpButton() => TextButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignUpScreen()));
      },
      child: const Text('Zarejestruj się!'));

  Widget forgetPasswordButton() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      margin: EdgeInsets.zero,
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: !isDisabled
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funkcja wkrótce będzie dostępna'),
                    ),
                  );
                  setState(() {
                    isDisabled = true;
                  });
                }
              : null,
          child: const Text('Zapomniałeś hasła?'),
        ),
      ));

  Widget emailInputForm() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.only(top: 10),
          ),
          validator: (value) {
            if (!EmailValidator.validate(value!)) {
              return "Ten adres e-mail jest nieprawidłowy";
            }
            return null;
          },
          onChanged: (value) => setState(
            () {
              email = value;
            },
          ),
        ),
      );

  Widget passwordInputForm() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(
            hintText: 'Hasło (minimum 8 znaków)',
            contentPadding: EdgeInsets.only(top: 10),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'To pole jest wymagane';
            } else if (value.length < 8) {
              return 'Podane hasło jest za krótkie';
            }
            return null;
          },
          onChanged: (value) => setState(() {
            password = value;
          }),
          obscureText: true,
        ),
      );
}
