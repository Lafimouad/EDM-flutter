import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/user1.dart';

class changer extends StatefulWidget {
  final User user;

  const changer({Key key, this.user}) : super(key: key);

  @override
  _changerState createState() => _changerState();
}

class _changerState extends State<changer> {
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          iconEnabledColor: Colors.black,
          elevation: 16,
          style: TextStyle(color: Colors.black),
          underline: Container(
            height: 2,
            color: kPrimaryColor,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });

            if (newValue == 'USER') {
              widget.user.role["name"] = 'USER';
              widget.user.role["description"] = "USER role";
              print(widget.user.role);
            }
            if (newValue == 'ADMIN') {
              widget.user.role["name"] = 'ADMIN';
              widget.user.role["description"] = "ADMIN role";
            }
            if (newValue == 'RH') {
              widget.user.role["name"] = 'RH';
              widget.user.role["description"] = "RH role";
            }
          },
          items: <String>['USER', 'ADMIN', 'RH']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          hint: Text(
            "Please choose your new role",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          )),
    );
  }
}
