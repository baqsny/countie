// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:countie/constants/Strings.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ApiUserManager {
//   String? token;
//   Future<bool> Login(String email, String password) async {
//     var response = await http.post(Uri.parse(Strings.login_user),
//         headers: {
//           "Accept": "application/json",
//           "content-type": "application/json"
//         },
//         body: jsonEncode({
//           'email': email,
//           'password': password,
//         }));
//     if (response.statusCode == 200) {
//       final body = await jsonDecode(response.body);
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       var loggedIn = await pref.setString("login", body['token']);
//       return loggedIn;
//     } else {
//       print(response.body);
//       return false;
//     }
//   }
// }
