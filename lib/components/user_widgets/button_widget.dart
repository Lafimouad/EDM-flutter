import 'package:flutter/material.dart';

import '../../user1.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final User user;
  const ButtonWidget({
    Key key,
    @required this.text,
    @required this.onClicked,
    this.user
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: Text(text),
        onPressed:user.activated==false? onClicked:null,
      );
}
