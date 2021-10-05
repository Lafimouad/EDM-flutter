import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Admin/background.dart';
import 'package:flutter_auth/Screens/Admin/updateScreen/update_screen.dart';
import 'package:flutter_auth/Screens/Login/components/body.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/RH/rh_screen.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/main.dart';
import 'package:flutter_auth/user1.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

//url
var url = Uri.parse('$BaseUrl/user/getRHUsers');
//get all user

Future<List<User>> getUsers() async {
  final response = await http.get(url);
  if (response.statusCode == 200) {
    var getUsersData = json.decode(response.body) as List;
    print(getUsersData);
    var listUsers = getUsersData.map((i) => User.fromJSON(i)).toList();
    print(listUsers);
    return listUsers;
  } else {
    throw Exception("Invalid Request");
  }
}

class AdminScreen extends StatefulWidget {
  var jwt;

  AdminScreen({Key key, this.jwt}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  Future<List<User>> listUsers;
// intializing the users
  @override
  void initState() {
    super.initState();
    listUsers = getUsers();
  }

  Future<Null> _refresh() {
    setState(() {
      listUsers = getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map<String, dynamic> payload = Jwt.parseJwt(widget.jwt);
    String name = payload['sub'];
    //http
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
            backgroundColor: kPrimaryColor,
              child: new Icon(
                Icons.logout,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              }),
        body: Background(
      child: Column(children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
          children: [            
            Text('Welcome $name',style:TextStyle(color: kPrimaryColor,fontSize: 16 )),
            SizedBox(width: 10)
          ],
        )),
        Text(
          "User Managment",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        Expanded(
          child: Container(
            height: size.height,
            padding: EdgeInsets.all(1.0),
            width: size.width,
            margin: new EdgeInsets.symmetric(horizontal: 1, vertical: 20),
            child: FutureBuilder<List<User>>(
              future: listUsers,
              builder: (context, snapshot) {
                // If the connection is done,
                // check for response data or an error.
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: (snapshot.data as List<User>).length,
                          itemBuilder: (BuildContext context, int index) {
                            var user = (snapshot.data as List<User>)[index];
                            print(user);
                            print((user.activated));

                            return Card(
                              child: ListTile(

                                  //return new ListTile(
                                  onTap: () {
                                    print(user.lastName);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdateScreen(
                                                user: user,
                                              )),
                                    );
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: kPrimaryLightColor,
                                    child: Text(user.firstName[0]),
                                  ),
                                  title: Row(children: <Widget>[
                                    Expanded(
                                        child: Text(user.firstName +
                                            " " +
                                            user.lastName)),
                                    Expanded(
                                        child: user.activated
                                            ? Icon(
                                                IconData(0xe159,
                                                    fontFamily:
                                                        'MaterialIcons'),
                                                color: Colors.green,
                                              )
                                            : Icon(
                                                IconData(0xee2c,
                                                    fontFamily:
                                                        'MaterialIcons'),
                                                color: Colors.red,
                                              )),
                                    Expanded(
                                        child: IconButton(
                                            icon: new Icon(
                                              IconData(0xe22a,
                                                  fontFamily: 'MaterialIcons'),
                                              color: Colors.amber,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                barrierLabel: user.email,
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        _buildPopupDialog(
                                                            context,
                                                            user.email),
                                              );
                                            })),
                                  ])),
                            );
                          }, //itemBuilder
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("${snapshot.error}"),
                    );
                  }
                }

                // By default, show a loading spinner.
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.cyanAccent,
                  ),
                );
              },
            ),
          ),
        )
      ]),
    ));
  }
}

Widget _buildPopupDialog(BuildContext context, String email) {
  return new AlertDialog(
    title: const Text('Email : '),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(email),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Close'),
      ),
    ],
  );
}
