import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/UserScreen/user_screen.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/main.dart';
import 'package:flutter_auth/userlogin.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

class Login extends StatelessWidget {
  //validator
  final _textpass = TextEditingController();
  final _textlogin = TextEditingController();
  bool _validatepass = false;
  bool _validatelogin = false;
  //http
  User user = User("", "");
  var url = Uri.parse('http://192.168.1.20:9009/user/signin');
  Map<String, String> headers = {"Content-Type": "application/json"};

  Future<String> Signin(String username, String password) async {
    print('Signin start working');
    var res = await http.post(url,
        headers: this.headers,
        body: json.encode({'login': username, 'password': password}));
    print("save is working");
    print(res.body);
    if (res.statusCode == 405) {
      AlertDialog(title: Text("Please Verify your Account"));
      return null;
    } else {
      return (res.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            //login Input
            TextFieldContainer(
              child: TextField(
                onChanged: (val) {
                  user.login = val;
                  print(user.login);
                },
                controller: _textlogin,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: kPrimaryColor,
                  ),
                  errorText: _validatelogin ? 'Login Can\'t Be Empty' : null,
                  hintText: 'Login',
                  border: InputBorder.none,
                ),
              ),
            ),
            //Password Input
            TextFieldContainer(
              child: TextField(
                onChanged: (val) {
                  user.password = val;
                },
                obscureText: true,
                controller: _textpass,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.lock,
                    color: kPrimaryColor,
                  ),
                  suffixIcon: Icon(
                    Icons.visibility,
                    color: kPrimaryColor,
                  ),
                  errorText: _validatepass ? 'Password can not be Empty' : null,
                  hintText: 'Password',
                  border: InputBorder.none,
                ),
              ),
            ),
            RoundedButton(
                text: "LOGIN",
                press: () async {
                  _textlogin.text.isEmpty
                      ? _validatelogin = true
                      : _validatelogin = false;
                  _textpass.text.isEmpty
                      ? _validatepass = true
                      : _validatepass = false;

                  if (!_validatelogin && !_validatepass) {
                    print(this.user.login);
                    print(this.user.password);
                    var jwt = await Signin(user.login, user.password);
                    Map<String, dynamic> payload = Jwt.parseJwt(jwt);
                    print(payload);
                    if (jwt != null) {
                      if (payload['role'] == 'ROLE_USER') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserScreen()));
                      } if(payload['role'] != 'ROLE_USER')
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomeScreen()));
                    } else {
                      AlertDialog(
                          title: Text(
                              "An Error Occurred! NO account was found matching that username and password"));
                    }
                  }
                  ;
                }),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      print('object');
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
