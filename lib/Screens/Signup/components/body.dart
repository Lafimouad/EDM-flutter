import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/components/background.dart';
import 'package:flutter_auth/Screens/Signup/components/or_divider.dart';
import 'package:flutter_auth/Screens/Signup/components/social_icon.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/user.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //validator
  final _text = TextEditingController();
  final _textpass = TextEditingController();
  final _textname = TextEditingController();
  final _textlast = TextEditingController();
  final _textlogin = TextEditingController();
  bool _validateadress = false;
  bool _validatepass = false;
  bool _validatename = false;
  bool _validatelast = false;
  bool _validatelogin = false;
  //http
  User user = User("", "", "", "", "");
  var url = Uri.parse('http://192.168.1.20:9009/user/signup');
  Map<String, String> headers = {"Content-Type": "application/json"};

  Future save() async {
    print('save start working');
    var res = await http.post(url,
        headers: this.headers,
        body: json.encode({
          'firstName': user.firstName,
          'lastName': user.lastName,
          'login': user.login,
          'email': user.email,
          'password': user.password
        }));
    print(user.firstName);
    print(user.lastName);
    print("save is working");
    print(res.body);
    if (res.statusCode == 200) {
      print('mou3adh');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            print('object');
            return LoginScreen();
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
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
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.55,
            ),
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
            // Lastname Input
            TextFieldContainer(
              child: TextField(
                onChanged: (val) {
                  user.lastName = val;
                },
                controller: _textlast,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: kPrimaryColor,
                  ),
                  errorText: _validatelast ? 'LastName Can\'t Be Empty' : null,
                  hintText: 'LastName',
                  border: InputBorder.none,
                ),
              ),
            ),
            // Name Input
            TextFieldContainer(
              child: TextField(
                onChanged: (val) {
                  user.firstName = val;
                },
                controller: _textname,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: kPrimaryColor,
                  ),
                  errorText: _validatename ? 'Name Can\'t Be Empty' : null,
                  hintText: 'Name',
                  border: InputBorder.none,
                ),
              ),
            ),
            //Email Input
            TextFieldContainer(
              child: TextField(
                onChanged: (val) {
                  user.email = val;
                },
                controller: _text,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.email_rounded,
                    color: kPrimaryColor,
                  ),
                  errorText: _validateadress ? 'email not @talan.com' : null,
                  hintText: 'Email',
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
                text: "SIGNUP",
                press: () async {
                  setState(() {
                    _text.text.contains('@talan.com')
                        ? _validateadress = false
                        : _validateadress = true;
                    _textlogin.text.isEmpty
                        ? _validatelogin = true
                        : _validatelogin = false;
                    _textname.text.isEmpty
                        ? _validatename = true
                        : _validatename = false;
                    _textpass.text.isEmpty
                        ? _validatepass = true
                        : _validatepass = false;
                    _textlast.text.isEmpty
                        ? _validatelast = true
                        : _validatelast = false;
                  });
                  if (!_validateadress &&
                      !_validatelast &&
                      !_validatename &&
                      !_validatepass) {
                    print(this.user.password);
                    save();
                  }
                }),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      print('object');
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
