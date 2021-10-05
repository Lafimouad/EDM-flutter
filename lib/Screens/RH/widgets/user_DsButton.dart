import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/rhuser.dart';

import '../../../upload.dart';
import '../../../user1.dart';
import 'package:http/http.dart' as http;

//url
var url =
    Uri.parse('http://192.168.1.21:9009/user/getRHUsersWithPassphraseFilled');
//get all user

Future getUsers() async {
  final response = await http.get(url);
  if (response.statusCode == 200) {
    var getUsersData = json.decode(response.body) as List;
    print(getUsersData);
    var listUsers = getUsersData.map((i) => User.fromJSON(i)).toList();
    print(listUsers);
    List<UserRH> userlis = [];
    listUsers.forEach((user) => userlis.add(UserRH(
        fullname: user.firstName + " " + user.lastName, login: user.login)));
    print(userlis);
    return userlis;
  } else {
    throw Exception("Invalid Request");
  }
}

class userDropButton extends StatefulWidget {
  Upload upload;
  userDropButton({Key key, this.upload}) : super(key: key);
  @override
  _userDropButtonState createState() => _userDropButtonState();
}

class _userDropButtonState extends State<userDropButton> {
  String dropdownValue;
  Future listUsers;
  // intializing the users
  @override
  void initState() {
    super.initState();
    listUsers = getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: FutureBuilder(
          future: listUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                print((snapshot.data as List<UserRH>));
                print('------------------------------------');

                List<UserRH> rh = (snapshot.data as List<UserRH>);
                List<String> ss = [];
                rh.forEach((element) {
                  String fullname = element.fullname;
                  print(fullname.toLowerCase());
                  ss.add(fullname);
                  print(ss);
                });
                print(rh);
                return Expanded(
                  child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      iconEnabledColor: Colors.black,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                        rh.forEach((element) {
                          if (newValue == element.fullname) {
                            widget.upload.login = element.login;
                          }
                        });
                      },
                      items: ss.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Text(
                        "Please Select A User",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      )),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
            }
            return Container();
          }),
    );
  }
}
