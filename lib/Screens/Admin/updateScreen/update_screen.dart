import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Admin/background.dart';
import 'package:flutter_auth/components/user_widgets/button_widget.dart';
import 'package:flutter_auth/components/user_widgets/user_profile.dart';
import 'package:flutter_auth/components/user_widgets/DropdownButton.dart';
import 'package:flutter_auth/user1.dart';
import 'package:http/http.dart' as http;

class UpdateScreen extends StatelessWidget {
  User user;
  //http activation
  Future activate(String login) async {
    print('activate is working');
    var res = await http
        .post(Uri.parse('http://192.168.1.21:9009/user/activateUser/$login'));
    print("save is working");
    print(res.body);
    if (res.statusCode == 200) {
      AlertDialog(title: Text("Account Activated"));
    }

  }
  //http update role
    Map<String, String> headers = {"Content-Type": "application/json"};

    Future updateRole(User user) async {
      print("update is working");
      var res = await http.post(
          Uri.parse(
              'http://192.168.1.21:9009/user/updateUserInfo'),
          headers: headers,
          body: json.encode(user.toMap()));
      print(user.role);
      print(res.body);
      if (res.statusCode == 200) {
        AlertDialog(title: Text("change done"));
      }
      return res.body;
    }

  UpdateScreen({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var a = user.login;
    var bool = user.activated;

    // This size provide us total height and width of our screen
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("Admin"),
        centerTitle: true,
      ),
      body: Background(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(user.firstName[0]),
            ),
            const SizedBox(height: 24),
            buildName(user),
            const SizedBox(height: 24),
            Center(child: buildUpgradeButton()),
            const SizedBox(height: 24),
            const SizedBox(height: 48),
            buildAbout(user),
            changer(user: user),
            const SizedBox(height: 24),
            Center(child: builduButton()),
          ],
        ),
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.firstName + " " + user.lastName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.role["name"],
            style: TextStyle(color: Colors.blueAccent),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          user.activated
              ? Text("Validé",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 20))
              : Text("No Validé",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 20))
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: user.activated ? 'Activated' : 'Activate',
        user: user,
        onClicked: () async {
          if (user.activated == false) {
            activate(user.login);
          }
        },
      );
  Widget builduButton() => ButtonWidget(
        text: 'Confirm',
        user: user,
        onClicked: () async {
          updateRole(user);
        },
      );

  Widget buildAbout(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Role : ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
}
    
