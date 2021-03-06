import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';

import '../../user1.dart';

class ButtonWidget1 extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final User user;
  const ButtonWidget1({
    Key key,
    @required this.text,
    @required this.onClicked,
    this.user
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: kPrimaryColor,
          shape: StadiumBorder(),
          onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: Text(text),
        onPressed:onClicked
      );
}
