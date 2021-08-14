import 'package:flutter/material.dart';
import 'package:flutter_auth/user1.dart';

class UpdateScreen extends StatefulWidget {
  UpdateScreen({Key key, @required this.user}) : super(key: key);
  final User user;

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  Widget build(BuildContext context) {
    // This size provide us total height and width of our screen
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('hello'),
      ),
    );
  }
}
