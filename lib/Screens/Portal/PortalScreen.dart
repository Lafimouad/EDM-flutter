import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Portal/Background.dart';
import 'package:flutter_auth/Screens/User/user_screen.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/main.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

//http
Map<String, String> headers = {"Content-Type": "application/json"};

void updateUserPassphrase(String login, String passphrase) async {
  var res = await http.post(Uri.parse('$BaseUrl/user/updatePassPhrase/$login'),
      headers: headers, body: json.encode({'passphrase': passphrase}));
  if (res.statusCode == 200) {
    print("jawwak behi ye mou");
  } else
    print(res.body);
}

class PortalScreen extends StatefulWidget {
  final jwt;
  PortalScreen({Key key, this.jwt}) : super(key: key);

  @override
  _PortalScreenState createState() => _PortalScreenState();
}

class _PortalScreenState extends State<PortalScreen> {
  final _text = TextEditingController();
  bool _validate = false;
  String passphrase;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map<String, dynamic> payload = Jwt.parseJwt(widget.jwt);
    String login = payload['sub'];
    return Scaffold(
        body: Background(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
          Text(
            "Welcome $login",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          TextFieldContainer(
            child: TextField(
              onChanged: (val) {
                setState(() {
                  _validate = false;
                  passphrase = val;
                  print(passphrase);
                });
              },
              controller: _text,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.document_scanner,
                  color: kPrimaryColor,
                ),
                errorText: _validate ? 'Passphrase Can\'t Be Empty' : null,
                hintText: 'Passphrase',
                border: InputBorder.none,
              ),
            ),
          ),
          RoundedButton(
              text: "Confirm",
              press: () async {
                updateUserPassphrase(login, passphrase);
                Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserScreen(jwt: widget.jwt)));
              })
        ]))));
  }
}
