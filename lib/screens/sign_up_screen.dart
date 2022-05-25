import 'dart:async';
import 'dart:convert';

import 'package:countie/screens/sign_in_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http_sign_up;

import '../constants/Strings.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email = '';
  String password = '';
  String confrimPassword = '';

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  bool isLoading = false;
  bool isPasswordEightCharacters = false;
  bool hasPasswordOneNumber = false;
  bool hasPasswordOneBigLetter = false;
  bool isConfirmPasswordCorrect = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusScope.of(context).unfocus()),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            iconTheme: const IconThemeData(
              color: Colors.blue,
            )),
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              pageLabel('Utwórz konto'),
              info(),
              const SizedBox(
                height: 20,
              ),
              usernameInput(),
              signUpForm(),
              signUpButton()
            ],
          ),
        ),
      ),
    );
  }

  void toggleConfirmPasswordVisibility() {
    if (isConfirmPasswordHidden == true) {
      isConfirmPasswordHidden = false;
    } else {
      isConfirmPasswordHidden = true;
    }
    setState(() {
      isConfirmPasswordHidden != isConfirmPasswordHidden;
    });
  }

  void togglePasswordVisiblity() {
    if (isPasswordHidden == true) {
      isPasswordHidden = false;
    } else {
      isPasswordHidden = true;
    }

    setState(() {
      isPasswordHidden != isPasswordHidden;
      isConfirmPasswordHidden != isConfirmPasswordHidden;
    });
  }

  Widget pageLabel(String title) => Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(fontSize: 40),
        ),
      );

  Widget info() => const Text(
        'Klikając "Utwórz konto", wyrażasz zgodę na Warunki użytkowania i Politykę w zakresie ochrony prywatności.',
        textAlign: TextAlign.center,
      );

  Widget signUpForm() => Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            emailInputForm(),
            passwordInputForm(),
            confirmPasswordInputForm(),
            passwordValidationCriteria(),
          ],
        ),
      );

  Widget usernameInput() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: TextFormField(
          controller: firstNameController,
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'Nazwa',
            labelStyle: TextStyle(),
            contentPadding: EdgeInsets.only(bottom: 5),
          ),
        ),
      );

  Widget emailInputForm() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'Email',
            contentPadding: EdgeInsets.only(bottom: 5),
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
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Hasło',
            contentPadding: const EdgeInsets.only(top: 10),
            suffixIconConstraints: const BoxConstraints.tightFor(),
            suffixIcon: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: togglePasswordVisiblity,
              icon: Icon(
                  isPasswordHidden ? Icons.visibility : Icons.visibility_off),
            ),
          ),
          onChanged: (value) => onPasswordChange(value),
          validator: (value) {
            if (value!.isEmpty) {
              return 'To pole jest wymagane';
            }
            return null;
          },
          obscureText: isPasswordHidden,
        ),
      );

  Widget confirmPasswordInputForm() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        child: TextFormField(
          controller: confirmPasswordController,
          decoration: InputDecoration(
            labelText: 'Potwierdź hasło',
            contentPadding: const EdgeInsets.only(top: 10),
            suffixIconConstraints: const BoxConstraints.tightFor(),
            suffixIcon: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: toggleConfirmPasswordVisibility,
              icon: Icon(isConfirmPasswordHidden
                  ? Icons.visibility
                  : Icons.visibility_off),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'To pole jest wymagane';
            }
            return null;
          },
          onChanged: (value) {
            isConfirmPasswordCorrect = false;
            if (value == passwordController.text) {
              isConfirmPasswordCorrect = true;
            }
          },
          obscureText: isConfirmPasswordHidden,
        ),
      );

  onPasswordChange(String password) {
    final numericRegex = RegExp(r'[0-9]');
    final bigLetterRegex = RegExp(r'[A-Z]');

    setState(() {
      isPasswordEightCharacters = false;
      if (password.length >= 8) isPasswordEightCharacters = true;

      hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) hasPasswordOneNumber = true;

      hasPasswordOneBigLetter = false;
      if (bigLetterRegex.hasMatch(password)) hasPasswordOneBigLetter = true;

      isConfirmPasswordCorrect = false;
      if (password == confirmPasswordController.text) {
        isConfirmPasswordCorrect = true;
      }
    });
  }

  Widget passwordValidationCriteriaInfo(
          {required String criteriaInfo, required bool criteriaCondition}) =>
      Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                color: criteriaCondition ? Colors.green : Colors.transparent,
                border: criteriaCondition
                    ? Border.all(color: Colors.transparent)
                    : Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(50)),
            child: const Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(criteriaInfo)
        ],
      );

  Widget passwordValidationCriteria() => Container(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
        child: Column(
          children: [
            passwordValidationCriteriaInfo(
                criteriaInfo: "Hasło musi mieć conajmniej 8 znaków",
                criteriaCondition: isPasswordEightCharacters),
            const SizedBox(
              height: 5,
            ),
            passwordValidationCriteriaInfo(
                criteriaInfo: "Hasło musi zawierać conajmniej 1 cyfrę",
                criteriaCondition: hasPasswordOneNumber),
            const SizedBox(
              height: 5,
            ),
            passwordValidationCriteriaInfo(
                criteriaInfo: "Hasło musi zawierać conajmniej 1 dużą literę",
                criteriaCondition: hasPasswordOneBigLetter),
            const SizedBox(
              height: 5,
            ),
            passwordValidationCriteriaInfo(
                criteriaInfo: "Hasło muszą być identyczne",
                criteriaCondition: isConfirmPasswordCorrect),
          ],
        ),
      );

  Widget signUpButton() => Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(right: 40, left: 40, top: 20),
        child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () async {
                    if (formKey.currentState!.validate() &&
                        isPasswordEightCharacters &&
                        hasPasswordOneBigLetter &&
                        hasPasswordOneNumber &&
                        isConfirmPasswordCorrect) {
                      setState(() {
                        isLoading = true;
                      });
                      signUp(
                          firstNameController.text,
                          emailController.text,
                          passwordController.text,
                          confirmPasswordController.text);
                    }
                  },
            style: ElevatedButton.styleFrom(fixedSize: const Size(0, 50)),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.grey)
                : const Text('Utwórz konto', style: TextStyle(fontSize: 20))),
      );

  void signUp(String firstName, String email, String password,
      String confirmPassword) async {
    var response = await http_sign_up.post(Uri.parse(Strings.register_user),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'firstName': firstName
        }));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Pomyślnie utworzono użytkownika. Za chwilę zostaniesz przekierowany na ekran logowania.'),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 800),
      ));
      Timer(const Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    } else if (response.statusCode == 502) {
      Timer(const Duration(milliseconds: 1000), () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Nie udało połączyć się z serwerem :(')));
      });
    } else if (response.statusCode == 400) {
      Timer(const Duration(milliseconds: 1000), () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
              'Wystąpił problem przy próbie zalogowania się. Sprawdź adres e-mail i hasło.'),
          backgroundColor: Colors.red[600],
        ));
        setState(() {
          isLoading = false;
        });
      });
    }
  }
}
