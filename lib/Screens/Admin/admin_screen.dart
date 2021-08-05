import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Admin/background.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AdminScreen extends StatelessWidget {
  var jwt;

   AdminScreen({Key key,@required this.jwt}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var payload = Jwt.parseJwt(jwt);

    return Scaffold(
      body:Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome To Admin interface",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            Container(
            color: Colors.red,
            height: size.height,
            child: ListView.builder(
  itemCount: payload.length,
  itemBuilder: (BuildContext context, int index) {
    String key = payload.keys.elementAt(index);
    return new Column(
      children: <Widget>[
        new ListTile(
          title: new Text("$key"),
          subtitle: new Text("${payload[key]}"),
        ),
        new Divider(
          height: 2.0,
        ),
      ],
    );
  },
),)
              
            
          ],
        ),
      ),
    )
    );
  }
}