import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/UserScreen/components/background.dart';
import 'package:flutter_svg/svg.dart';

class UserScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "USerInterface",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03)
              
            
          ],
        ),
      ),
    );
  }
}
