import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Admin/background.dart';
import 'package:flutter_auth/components/user_widgets/button_widget.dart';
import 'package:flutter_auth/components/user_widgets/button_widget1.dart';
import 'package:flutter_auth/components/user_widgets/DropdownButton.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/main.dart';
import 'package:flutter_auth/user1.dart';
import 'package:http/http.dart' as http;

class UpdateScreen extends StatefulWidget {
  User user;
  //http activation
  UpdateScreen({Key key, @required this.user}) : super(key: key);

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  void updateUI() {
    setState(() {
      //You can also make changes to your state here.
    });
  }

  Future<int> activate(String login) async {
    print('activate is working');
    var res = await http
        .post(Uri.parse('$BaseUrl/user/activateUser/$login'));
    print("save is working");
    print(res.body);
    if (res.statusCode == 200) {
      return (res.statusCode);
    }
  }

  Map<String, String> headers = {"Content-Type": "application/json"};

  Future updateRole(User user) async {
    print("update is working");
    var res = await http.post(
        Uri.parse('$BaseUrl/user/updateUserInfo'),
        headers: headers,
        body: json.encode(user.toMap()));
    print(user.role);
    print(res.body);
    if (res.statusCode == 200) {
      return res.statusCode;
    }
    return res.body;
  }

  @override
  Widget build(BuildContext context) {
    var a = widget.user.login;
    var bool = widget.user.activated;

    // This size provide us total height and width of our screen
    return Scaffold(
      body: Background(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),
            CircleAvatar(
              backgroundColor: kPrimaryColor,
              child: Text(widget.user.firstName[0]),
            ),
            const SizedBox(height: 24),
            buildName(widget.user),
            const SizedBox(height: 24),
            Center(child: buildUpgradeButton()),
            const SizedBox(height: 24),
            const SizedBox(height: 48),
            buildAbout(widget.user),
            changer(user: widget.user),
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
              ? Text("Validated",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 20))
              : Text("Not Validated",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 20))
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: widget.user.activated ? 'Activated' : 'Activate',
        user: widget.user,
        onClicked: () async {
          if (widget.user.activated == false) {
            activate(widget.user.login);
            widget.user.activated = true;
            updateUI();
          }
        },
      );

  Widget builduButton() => ButtonWidget1(
        text: 'Confirm',
        user: widget.user,
        onClicked: () async {
          var res = updateRole(widget.user);
          if (res == 200) {
            print("jawwek bien ye bro");
            print(res);
            widget.user.activated = true;
          }
          updateUI();
        },
      );

  Widget buildAbout(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change Role : ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
}
