import 'package:flutter/material.dart';
import 'package:flutter_auth/Role.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/user1.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Screens/Admin/updateScreen/update_screen.dart';

final storage = FlutterSecureStorage();
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  var user = new User(
      activated: false,
      id: 2,
      firstName: "mouadh",
      lastName: "lafi",
      login: "mouadh",
      email: "mouad@talan.com",
      role: {"name": 'User', "description": "USER role"});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EDM',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      //home: UpdateScreen(user: user,),
      home: WelcomeScreen(),
    );
  }
}
