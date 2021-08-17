import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Admin/background.dart';
import 'package:flutter_auth/Screens/Admin/updateScreen/update_screen.dart';
import 'package:flutter_auth/user1.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;

//url
var url = Uri.parse('http://192.168.1.21:9009/user/getRHUsers');
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var payload = Jwt.parseJwt(widget.jwt);
    //http
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome to Admin Interface",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Background(
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
            Container(
              height: size.height,
              padding: EdgeInsets.all(20.0),
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
                        child: Container(
                          child: ListView.builder(
                            itemCount: (snapshot.data as List<User>).length,
                            itemBuilder: (BuildContext context, int index) {
                              var user = (snapshot.data as List<User>)[index];
                              print(user);
                              print((user.activated));
                              return InkWell(
                                onTap: () {},
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
                                      backgroundColor: Colors.blue,
                                      child: Text(user.firstName[0]),
                                    ),
                                    title: Row(children: <Widget>[
                                      Expanded(
                                          child: Text(user.firstName +
                                              " " +
                                              user.lastName)),
                                      Expanded(
                                          child: user.activated
                                              ? Text("activé")
                                              : Text("no activé")),
                                      Expanded(child: Text(user.email)),
                                      // Expanded(child: Text(snapshot.data[index].role)),
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
            )
          ])),
        ));
  }
}
