import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/RH/background.dart';
import 'package:flutter_auth/Screens/RH/widgets/typeButton.dart';
import 'package:flutter_auth/main.dart';
import 'package:flutter_auth/upload.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import '../../constants.dart';
import '../../rhuser.dart';
import '../../user1.dart';
import 'package:path/path.dart';

//url
var url = Uri.parse('$BaseUrl/user/getRHUsers');
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

class RhScreen extends StatefulWidget {
  final jwt;

  RhScreen({Key key, this.jwt}) : super(key: key);

  @override
  _RhScreenState createState() => _RhScreenState();
}

class _RhScreenState extends State<RhScreen> {
  String login;
  String type;
  File selectedfile;
  String dropdownValue;
  String dropdownValue1;
  Future listUsers;
  @override
  void initState() {
    super.initState();
    listUsers = getUsers();
  }

  selectFile() async {
    selectedfile = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['docx', 'pdf', 'doc'],

      //allowed extension to choose
    );

    setState(() {});
  }

  //upload file

  Future<int> uploadFile(String path, String url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', path));
    var res = await request.send();
    print(res.statusCode);
    if (res.statusCode == 200) {
      setState(() {
        selectedfile = null;
        dropdownValue = null;
        dropdownValue1 = null;
      });
    }
    return res.statusCode;
  }

  // //upload 2
  // uploadFile1(file, filename, url) async {
  //   var request = http.MultipartRequest('POST', Uri.parse(url));
  //   request.files.add(http.MultipartFile(
  //       'file', file.readAsBytes().asStream(), file.lengthSync(),
  //       filename: filename));
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Authorization": "Bearer " + widget.jwt
  //   };
  //   //add headers
  //   request.headers.addAll(headers);

  //   var res = await request.send();
  //   print(res.statusCode);
  //   print(res.stream);
  //   if (res.statusCode == 200) {
  //     setState(() {
  //       selectedfile = null;
  //       dropdownValue = null;
  //       dropdownValue1 = null;
  //     });
  //   }
  //   return res;
  // }

  // //upload 3

  // upload(file, url) async {
  //   var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
  //   // get file length
  //   var length = await selectedfile.length(); //imageFile is your image file
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Authorization": "Bearer " + widget.jwt
  //   }; // ignore this headers if there is no authentication

  //   // string to uri
  //   var uri = Uri.parse(url);

  //   // create multipart request
  //   var request = new http.MultipartRequest("POST", uri);

  //   // multipart that takes file
  //   var multipartFileSign = new http.MultipartFile(
  //       'profile_pic', stream, length,
  //       filename: basename(file.path));

  //   // add file to multipart
  //   request.files.add(multipartFileSign);

  //   //add headers
  //   request.headers.addAll(headers);

  //   // send
  //   var response = await request.send();

  //   print(response.statusCode);

  //   // listen for response
  //   response.stream.transform(utf8.decoder).listen((value) {
  //     print(value);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
          child: Column(
            children: <Widget>[
              SizedBox(height: 120),
              Text(
                "Welcome To RH interface",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                    fontSize: 20),
              ),
              SizedBox(height: size.height * 0.03),
              SizedBox(height: size.height * 0.03),
              Container(
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
                                  color: kPrimaryColor,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                  rh.forEach((element) {
                                    if (newValue == element.fullname) {
                                      login = element.login;
                                    }
                                  });
                                },
                                items: ss.map<DropdownMenuItem<String>>(
                                    (String value) {
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
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: DropdownButton<String>(
                    value: dropdownValue1,
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
                        dropdownValue1 = newValue;
                      });
                      if (newValue == 'PAYSLIP') {
                        type = "BP";
                      }
                      if (newValue == 'WORK CERTIFICATE') {
                        type = "AT";
                      }
                      if (newValue == 'TAX RETURN') {
                        type = "DI";
                      }
                    },
                    items: <String>[
                      'PAYSLIP',
                      'WORK CERTIFICATE',
                      'TAX RETURN',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text(
                      "Please Select A Folder",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    )),
              ),
              Container(
                margin: EdgeInsets.all(10),
                //show file name here
                child: selectedfile == null
                    ? Text("")
                    : Text((selectedfile.path)),
                //basename is from path package, to get filename from path
                //check if file is selected, if yes then show file name
              ),
              Container(
                  child: RaisedButton.icon(
                onPressed: () async {
                  selectFile();
                },
                icon: Icon(Icons.folder_open),
                label: Text(
                  "CHOOSE FILE",
                  style: TextStyle(color: kPrimaryLightColor),
                ),
                color: kPrimaryColor,
                colorBrightness: Brightness.dark,
              )),
              selectedfile == null
                  ? Container()
                  : Container(
                      child: ElevatedButton.icon(
                      onPressed: () async {
                        print('$BaseUrl/file/uploadMultipleFiles/$type/$login');
                        int res = await uploadFile(selectedfile.path,
                            '$BaseUrl/file/uploadFile/$type/$login');
                        print(res);
                        if (res == 200) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialog(context),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialogf(context),
                          );
                        }
                      },
                      icon: Icon(Icons.folder_open),
                      label: Text("UPLOAD FILE"),
                    ))
            ],
          ),
        ));
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: Center(child: const Text('Well Done')),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(child: Text('the file has been uploaded')),
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

Widget _buildPopupDialogf(BuildContext context) {
  return new AlertDialog(
    title: Center(child: const Text('Oppps !!')),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(child: Text('Upload Failed')),
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
