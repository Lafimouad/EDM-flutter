import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/User/components/background.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/main.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

//http
Future<List<dynamic>> getDocument(String login, String folder) async {
  final res =
      await http.get(Uri.parse('$BaseUrl/file/getDocumentList/$login/$folder'));
  if (res.statusCode == 200) {
    print(res.statusCode);
    var documentData = json.decode(res.body) as List;
    print("test http");
    print(documentData[0]);
    return documentData;
  } else {
    print(res.statusCode);

    throw Exception("Invalid Request");
  }
}

//down

void downloadFileUsingStreamPipe(
    String pass, int id, String name, String type) {
  HttpClient client = new HttpClient();
  client
      .getUrl(Uri.parse('$BaseUrl/file/downloadFile/$id/$pass'))
      .then((HttpClientRequest request) {
    return request.close();
  }).then((HttpClientResponse response) {
    response.pipe(new File('/storage/emulated/0/EDM/$name.$type').openWrite());
  });
}

class UserScreen extends StatefulWidget {
  var jwt;

  UserScreen({Key key, @required this.jwt}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Future<List<dynamic>> listDocDI;
  Future<List<dynamic>> listDocAT;
  Future<List<dynamic>> listDocBP;
  Future<List<dynamic>> listDocDP;
  String up;
  File selectedfile;

// intializing the users
  @override
  void initState() {
    super.initState();
    var payload = Jwt.parseJwt(widget.jwt);
    listDocDI = getDocument(payload['sub'], 'DI');
    listDocAT = getDocument(payload['sub'], 'AT');
    listDocBP = getDocument(payload['sub'], 'BP');
    listDocDP = getDocument(payload['sub'], 'DP');
    up = payload['sub'];
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

  uploadFile(String path, String url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', path));
    var res = await request.send();
    print(res.statusCode);
    if (res.statusCode == 200) {
      setState(() {
        selectedfile = null;
      });
    }
    return res.statusCode;
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var payload = Jwt.parseJwt(widget.jwt);
    var name = payload['sub'];
    return DefaultTabController(
      length: 5,
      child: Scaffold(
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
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Text('Welcome $name'),
            automaticallyImplyLeading: false,
            bottom: const TabBar(
              tabs: [
                Tab(
                    icon: ImageIcon(
                  AssetImage('assets/images/tax.png'),
                  size: 100,
                  color: kPrimaryLightColor,
                )),
                Tab(
                    icon: ImageIcon(
                  AssetImage('assets/images/workcertificate.png'),
                  size: 100,
                  color: kPrimaryLightColor,
                )),
                Tab(
                    icon: ImageIcon(
                  AssetImage('assets/images/payslip.png'),
                  size: 100,
                  color: kPrimaryLightColor,
                )),
                Tab(
                    icon: ImageIcon(
                  AssetImage('assets/images/doc.png'),
                  size: 100,
                  color: kPrimaryLightColor,
                )),
                Tab(
                    icon: ImageIcon(
                  AssetImage('assets/images/upload.png'),
                  size: 100,
                  color: kPrimaryLightColor,
                )),
              ],
            ),
          ),
          body: Background(
              child: TabBarView(
            children: [
              Container(
                  child: Center(
                      child: FutureBuilder<List<dynamic>>(
                future: listDocDI,
                builder: (context, snapshot) {
                  // If the connection is done,
                  // check for response data or an error.
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: (snapshot.data).length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              // return the header
                              return new Card(
                                child: ListTile(
                                    trailing: Expanded(
                                        child: Text(
                                      '          ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    //return new ListTile(
                                    leading: Expanded(
                                        child: Text(
                                      '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    title: Expanded(
                                        child: Text(
                                      '              TAX RETURNS',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))),
                              );
                            }
                            index -= 1;

                            var doc = snapshot.data[index];
                            var usert = doc['user'];
                            // files info
                            int id = doc['id'];
                            String fileName = doc['fileName'];
                            double size = doc['size'] / 1024;
                            String lastModifiedBy = doc['lastModifiedBy'];
                            String createdBy = doc['createdBy'];
                            String createdDate = doc['createdDate'];
                            String lastModifiedDate = doc['lastModifiedDate'];
                            String fileExtension = doc['fileExtension'];
                            //date creation manip
                            int idx = createdDate.indexOf("T");
                            int idx1 = createdDate.indexOf("Z");
                            List parts = [
                              createdDate.substring(0, idx).trim(),
                              createdDate.substring(idx + 1, idx1 - 7).trim()
                            ];
                            //date creation manip

                            int idx2 = lastModifiedDate.indexOf("T");
                            int idx3 = lastModifiedDate.indexOf("Z");
                            List parts1 = [
                              lastModifiedDate.substring(0, idx).trim(),
                              lastModifiedDate
                                  .substring(idx2 + 1, idx3 - 7)
                                  .trim()
                            ];

                            String datec = parts[0] + ' ' + parts[1];
                            String datem = parts1[0] + ' ' + parts1[1];

                            print("test before card");
                            print(size);
                            print(doc['id']);

                            return Card(
                              child: ListTile(
                                trailing: IconButton(
                                    icon: new Icon(Icons.download),
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildPopupDialog1(
                                                context,
                                                doc['id'],
                                                fileName,
                                                fileExtension),
                                      );
                                    }),
                                title: Expanded(
                                    child: IconButton(
                                        icon: new Icon(
                                          IconData(0xe33c,
                                              fontFamily: 'MaterialIcons'),
                                          color: Colors.amber,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                _buildPopupDialog(
                                                    context,
                                                    fileName,
                                                    fileExtension,
                                                    size,
                                                    createdBy,
                                                    lastModifiedBy,
                                                    datec,
                                                    datem),
                                          );
                                        })),

                                //return new ListTile(
                                onTap: () {},
                                leading: Expanded(
                                    child:
                                        Text(fileName + '.' + fileExtension)),
                              ),
                            );
                          }, //itemBuilder
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
              ))),
              Container(
                  child: Center(
                      child: FutureBuilder<List<dynamic>>(
                future: listDocAT,
                builder: (context, snapshot) {
                  // If the connection is done,
                  // check for response data or an error.
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: (snapshot.data).length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return new Card(
                                child: ListTile(
                                    trailing: Expanded(
                                        child: Text(
                                      '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    //return new ListTile(
                                    leading: Expanded(
                                        child: Text(
                                      '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    title: Expanded(
                                        child: Text(
                                      '        WORK CERTIFICATES',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))),
                              );
                            }
                            index -= 1;
                            var doc = snapshot.data[index];
                            // files info
                            String fileName = doc['fileName'];
                            double size = doc['size'] / 1024;
                            String lastModifiedBy = doc['lastModifiedBy'];
                            String createdBy = doc['createdBy'];
                            String createdDate = doc['createdDate'];
                            String lastModifiedDate = doc['lastModifiedDate'];
                            String fileExtension = doc['fileExtension'];
                            //date creation manip
                            int idx = createdDate.indexOf("T");
                            int idx1 = createdDate.indexOf("Z");
                            List parts = [
                              createdDate.substring(0, idx).trim(),
                              createdDate.substring(idx + 1, idx1 - 7).trim()
                            ];
                            //date creation manip

                            int idx2 = lastModifiedDate.indexOf("T");
                            int idx3 = lastModifiedDate.indexOf("Z");
                            List parts1 = [
                              lastModifiedDate.substring(0, idx).trim(),
                              lastModifiedDate
                                  .substring(idx2 + 1, idx3 - 7)
                                  .trim()
                            ];

                            String datec = parts[0] + ' ' + parts[1];
                            String datem = parts1[0] + ' ' + parts1[1];

                            print("test before card");
                            print(size);
                            print(doc['id']);

                            return Card(
                              child: ListTile(
                                trailing: IconButton(
                                    icon: new Icon(Icons.download),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildPopupDialog1(
                                                context,
                                                doc['id'],
                                                fileName,
                                                fileExtension),
                                      );
                                    }),
                                title: Expanded(
                                    child: IconButton(
                                        icon: new Icon(
                                          IconData(0xe33c,
                                              fontFamily: 'MaterialIcons'),
                                          color: Colors.amber,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                _buildPopupDialog(
                                                    context,
                                                    fileName,
                                                    fileExtension,
                                                    size,
                                                    createdBy,
                                                    lastModifiedBy,
                                                    datec,
                                                    datem),
                                          );
                                        })),

                                //return new ListTile(
                                onTap: () {},
                                leading: Expanded(
                                    child:
                                        Text(fileName + '.' + fileExtension)),
                              ),
                            );
                          }, //itemBuilder
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
              ))),
              Container(
                  child: Center(
                      child: FutureBuilder<List<dynamic>>(
                future: listDocBP,
                builder: (context, snapshot) {
                  // If the connection is done,
                  // check for response data or an error.
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: (snapshot.data).length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              // return the header
                              return new Card(
                                child: ListTile(
                                    trailing: Expanded(
                                        child: Text(
                                      '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    //return new ListTile(
                                    leading: Expanded(
                                        child: Text(
                                      '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    title: Expanded(
                                        child: Text(
                                      '                  PAYSLIPS',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))),
                              );
                            }
                            index -= 1;
                            var doc = snapshot.data[index];
                            // files info
                            String fileName = doc['fileName'];
                            double size = doc['size'] / 1024;
                            String lastModifiedBy = doc['lastModifiedBy'];
                            String createdBy = doc['createdBy'];
                            String createdDate = doc['createdDate'];
                            String lastModifiedDate = doc['lastModifiedDate'];
                            String fileExtension = doc['fileExtension'];
                            String taille = '$size';

                            //date creation manip
                            int idx = createdDate.indexOf("T");
                            int idx1 = createdDate.indexOf("Z");
                            List parts = [
                              createdDate.substring(0, idx).trim(),
                              createdDate.substring(idx + 1, idx1 - 7).trim()
                            ];
                            //date creation manip

                            int idx2 = lastModifiedDate.indexOf("T");
                            int idx3 = lastModifiedDate.indexOf("Z");
                            List parts1 = [
                              lastModifiedDate.substring(0, idx).trim(),
                              lastModifiedDate
                                  .substring(idx2 + 1, idx3 - 7)
                                  .trim()
                            ];

                            String datec = parts[0] + ' ' + parts[1];
                            String datem = parts1[0] + ' ' + parts1[1];

                            print("test before card");
                            print(size);
                            print(doc['id']);

                            return Card(
                              child: ListTile(
                                trailing: IconButton(
                                    icon: new Icon(Icons.download),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildPopupDialog1(
                                                context,
                                                doc['id'],
                                                fileName,
                                                fileExtension),
                                      );
                                    }),
                                title: Expanded(
                                    child: IconButton(
                                        icon: new Icon(
                                          IconData(0xe33c,
                                              fontFamily: 'MaterialIcons'),
                                          color: Colors.amber,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                _buildPopupDialog(
                                                    context,
                                                    fileName,
                                                    fileExtension,
                                                    size,
                                                    createdBy,
                                                    lastModifiedBy,
                                                    datec,
                                                    datem),
                                          );
                                        })),

                                //return new ListTile(
                                onTap: () {},
                                leading: Expanded(
                                    child:
                                        Text(fileName + '.' + fileExtension)),
                              ),
                            );
                          }, //itemBuilder
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
              ))),
              Container(
                child: Center(
                    child: FutureBuilder<List<dynamic>>(
                  future: listDocDP,
                  builder: (context, snapshot) {
                    // If the connection is done,
                    // check for response data or an error.
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: (snapshot.data).length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                // return the header
                                return new Card(
                                  child: ListTile(
                                      trailing: Expanded(
                                          child: Text(
                                        '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      //return new ListTile(
                                      leading: Expanded(
                                          child: Text(
                                        '',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      title: Expanded(
                                          child: Text(
                                        '      PERSONAL DOCUMENTS',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ))),
                                );
                              }
                              index -= 1;
                              print(snapshot.data);
                              var doc = snapshot.data[index];
                              // files info
                              print(doc);
                              String fileName = doc['fileName'];
                              double size = doc['size'] / 1024;
                              String lastModifiedBy = doc['lastModifiedBy'];
                              String createdBy = doc['createdBy'];
                              String createdDate = doc['createdDate'];
                              String lastModifiedDate = doc['lastModifiedDate'];
                              String fileExtension = doc['fileExtension'];
                              //date creation manip
                              int idx = createdDate.indexOf("T");
                              int idx1 = createdDate.indexOf("Z");
                              List parts = [
                                createdDate.substring(0, idx).trim(),
                                createdDate.substring(idx + 1, idx1 - 7).trim()
                              ];
                              //date creation manip

                              int idx2 = lastModifiedDate.indexOf("T");
                              int idx3 = lastModifiedDate.indexOf("Z");
                              List parts1 = [
                                lastModifiedDate.substring(0, idx).trim(),
                                lastModifiedDate
                                    .substring(idx2 + 1, idx3 - 7)
                                    .trim()
                              ];

                              String datec = parts[0] + ' ' + parts[1];
                              String datem = parts1[0] + ' ' + parts1[1];

                              print("test before card");
                              print(size);
                              print(doc['id']);

                              return Card(
                                child: ListTile(
                                  trailing: IconButton(
                                      icon: new Icon(Icons.download),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              _buildPopupDialog1(
                                                  context,
                                                  doc['id'],
                                                  fileName,
                                                  fileExtension),
                                        );
                                      }),
                                  title: Expanded(
                                      child: IconButton(
                                          icon: new Icon(
                                            IconData(0xe33c,
                                                fontFamily: 'MaterialIcons'),
                                            color: Colors.amber,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildPopupDialog(
                                                      context,
                                                      fileName,
                                                      fileExtension,
                                                      size,
                                                      createdBy,
                                                      lastModifiedBy,
                                                      datec,
                                                      datem),
                                            );
                                          })),

                                  //return new ListTile(
                                  onTap: () {},
                                  leading: Expanded(
                                      child:
                                          Text(fileName + '.' + fileExtension)),
                                ),
                              );
                            }, //itemBuilder
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
                )),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        //show file name here
                        child: selectedfile == null
                            ? Text("Choose File")
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
                        label: Text("CHOOSE FILE"),
                        color: kPrimaryColor,
                        colorBrightness: Brightness.dark,
                      )),
                      selectedfile == null
                          ? Container()
                          : Container(
                              child: ElevatedButton.icon(
                              onPressed: () async {
                                var payload = Jwt.parseJwt(widget.jwt);
                                var log = payload['sub'];
                                print(
                                    '$BaseUrl/file/uploadMultipleFiles/DP/$log');
                                int res = await uploadFile(selectedfile.path,
                                    '$BaseUrl/file/uploadFile/DP/$log');
                                setState(() {
                                  listDocDP = getDocument(payload['sub'], 'DP');
                                });
                           if (res == 200) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialogs(context),
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
                            )),
                    ],
                  ),
                ),
              )
            ],
          ))),
    );
  }

  Widget _stackedContainers() {
    return Expanded(
      child: IndexedStack(
        index: index,
        children: <Widget>[
          Container(
              child: Center(
                  child: FutureBuilder<List<dynamic>>(
            future: listDocDI,
            builder: (context, snapshot) {
              // If the connection is done,
              // check for response data or an error.
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: (snapshot.data).length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          // return the header
                          return new Card(
                            child: ListTile(
                              trailing: Expanded(
                                  child: Text(
                                'DOWNLOAD',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                              //return new ListTile(
                              leading: Expanded(
                                  child: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ),
                          );
                        }
                        index -= 1;

                        var doc = snapshot.data[index];
                        var usert = doc['user'];
                        // files info
                        int id = doc['id'];
                        String fileName = doc['fileName'];
                        double size = doc['size'] / 1024;
                        String lastModifiedBy = doc['lastModifiedBy'];
                        String createdBy = doc['createdBy'];
                        String createdDate = doc['createdDate'];
                        String lastModifiedDate = doc['lastModifiedDate'];
                        String fileExtension = doc['fileExtension'];
                        //date creation manip
                        int idx = createdDate.indexOf("T");
                        int idx1 = createdDate.indexOf("Z");
                        List parts = [
                          createdDate.substring(0, idx).trim(),
                          createdDate.substring(idx + 1, idx1 - 7).trim()
                        ];
                        //date creation manip

                        int idx2 = lastModifiedDate.indexOf("T");
                        int idx3 = lastModifiedDate.indexOf("Z");
                        List parts1 = [
                          lastModifiedDate.substring(0, idx).trim(),
                          lastModifiedDate.substring(idx2 + 1, idx3 - 7).trim()
                        ];

                        String datec = parts[0] + ' ' + parts[1];
                        String datem = parts1[0] + ' ' + parts1[1];

                        print("test before card");
                        print(size);
                        print(doc['id']);

                        return Card(
                          child: ListTile(
                            trailing: IconButton(
                                icon: new Icon(Icons.download),
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog1(context, doc['id'],
                                            fileName, fileExtension),
                                  );
                                }),
                            title: Expanded(
                                child: IconButton(
                                    icon: new Icon(
                                      IconData(0xe33c,
                                          fontFamily: 'MaterialIcons'),
                                      color: Colors.amber,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildPopupDialog(
                                                context,
                                                fileName,
                                                fileExtension,
                                                size,
                                                createdBy,
                                                lastModifiedBy,
                                                datec,
                                                datem),
                                      );
                                    })),

                            //return new ListTile(
                            onTap: () {},
                            leading: Expanded(
                                child: Text(fileName + '.' + fileExtension)),
                          ),
                        );
                      }, //itemBuilder
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
          ))),
          Container(
              child: Center(
                  child: FutureBuilder<List<dynamic>>(
            future: listDocAT,
            builder: (context, snapshot) {
              // If the connection is done,
              // check for response data or an error.
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: (snapshot.data).length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          // return the header
                          return new Card(
                            child: ListTile(
                              trailing: Expanded(
                                  child: Text(
                                'DOWNLOAD',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                              //return new ListTile(
                              leading: Expanded(
                                  child: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ),
                          );
                        }
                        index -= 1;
                        var doc = snapshot.data[index];
                        // files info
                        String fileName = doc['fileName'];
                        double size = doc['size'] / 1024;
                        String lastModifiedBy = doc['lastModifiedBy'];
                        String createdBy = doc['createdBy'];
                        String createdDate = doc['createdDate'];
                        String lastModifiedDate = doc['lastModifiedDate'];
                        String fileExtension = doc['fileExtension'];
                        //date creation manip
                        int idx = createdDate.indexOf("T");
                        int idx1 = createdDate.indexOf("Z");
                        List parts = [
                          createdDate.substring(0, idx).trim(),
                          createdDate.substring(idx + 1, idx1 - 7).trim()
                        ];
                        //date creation manip

                        int idx2 = lastModifiedDate.indexOf("T");
                        int idx3 = lastModifiedDate.indexOf("Z");
                        List parts1 = [
                          lastModifiedDate.substring(0, idx).trim(),
                          lastModifiedDate.substring(idx2 + 1, idx3 - 7).trim()
                        ];

                        String datec = parts[0] + ' ' + parts[1];
                        String datem = parts1[0] + ' ' + parts1[1];

                        print("test before card");
                        print(size);
                        print(doc['id']);

                        return Card(
                          child: ListTile(
                            trailing: IconButton(
                                icon: new Icon(Icons.download),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog1(context, doc['id'],
                                            fileName, fileExtension),
                                  );
                                }),
                            title: Expanded(
                                child: IconButton(
                                    icon: new Icon(
                                      IconData(0xe33c,
                                          fontFamily: 'MaterialIcons'),
                                      color: Colors.amber,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildPopupDialog(
                                                context,
                                                fileName,
                                                fileExtension,
                                                size,
                                                createdBy,
                                                lastModifiedBy,
                                                datec,
                                                datem),
                                      );
                                    })),

                            //return new ListTile(
                            onTap: () {},
                            leading: Expanded(
                                child: Text(fileName + '.' + fileExtension)),
                          ),
                        );
                      }, //itemBuilder
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
          ))),
          Container(
              child: Center(
                  child: FutureBuilder<List<dynamic>>(
            future: listDocBP,
            builder: (context, snapshot) {
              // If the connection is done,
              // check for response data or an error.
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: (snapshot.data).length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          // return the header
                          return new Card(
                            child: ListTile(
                              trailing: Expanded(
                                  child: Text(
                                'DOWNLOAD',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                              //return new ListTile(
                              leading: Expanded(
                                  child: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            ),
                          );
                        }
                        index -= 1;
                        var doc = snapshot.data[index];
                        // files info
                        String fileName = doc['fileName'];
                        double size = doc['size'] / 1024;
                        String lastModifiedBy = doc['lastModifiedBy'];
                        String createdBy = doc['createdBy'];
                        String createdDate = doc['createdDate'];
                        String lastModifiedDate = doc['lastModifiedDate'];
                        String fileExtension = doc['fileExtension'];
                        String taille = '$size';

                        //date creation manip
                        int idx = createdDate.indexOf("T");
                        int idx1 = createdDate.indexOf("Z");
                        List parts = [
                          createdDate.substring(0, idx).trim(),
                          createdDate.substring(idx + 1, idx1 - 7).trim()
                        ];
                        //date creation manip

                        int idx2 = lastModifiedDate.indexOf("T");
                        int idx3 = lastModifiedDate.indexOf("Z");
                        List parts1 = [
                          lastModifiedDate.substring(0, idx).trim(),
                          lastModifiedDate.substring(idx2 + 1, idx3 - 7).trim()
                        ];

                        String datec = parts[0] + ' ' + parts[1];
                        String datem = parts1[0] + ' ' + parts1[1];

                        print("test before card");
                        print(size);
                        print(doc['id']);

                        return Card(
                          child: ListTile(
                            trailing: IconButton(
                                icon: new Icon(Icons.download),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog1(context, doc['id'],
                                            fileName, fileExtension),
                                  );
                                }),
                            title: Expanded(
                                child: IconButton(
                                    icon: new Icon(
                                      IconData(0xe33c,
                                          fontFamily: 'MaterialIcons'),
                                      color: Colors.amber,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildPopupDialog(
                                                context,
                                                fileName,
                                                fileExtension,
                                                size,
                                                createdBy,
                                                lastModifiedBy,
                                                datec,
                                                datem),
                                      );
                                    })),

                            //return new ListTile(
                            onTap: () {},
                            leading: Expanded(
                                child: Text(fileName + '.' + fileExtension)),
                          ),
                        );
                      }, //itemBuilder
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
          ))),
          Container(
            child: Center(
                child: FutureBuilder<List<dynamic>>(
              future: listDocDP,
              builder: (context, snapshot) {
                // If the connection is done,
                // check for response data or an error.
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: (snapshot.data).length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            // return the header
                            return new Card(
                              child: ListTile(
                                trailing: Expanded(
                                    child: Text(
                                  'DOWNLOAD',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                //return new ListTile(
                                leading: Expanded(
                                    child: Text(
                                  'Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ),
                            );
                          }
                          index -= 1;
                          print(snapshot.data);
                          var doc = snapshot.data[index];
                          // files info
                          print(doc);
                          String fileName = doc['fileName'];
                          double size = doc['size'] / 1024;
                          String lastModifiedBy = doc['lastModifiedBy'];
                          String createdBy = doc['createdBy'];
                          String createdDate = doc['createdDate'];
                          String lastModifiedDate = doc['lastModifiedDate'];
                          String fileExtension = doc['fileExtension'];
                          //date creation manip
                          int idx = createdDate.indexOf("T");
                          int idx1 = createdDate.indexOf("Z");
                          List parts = [
                            createdDate.substring(0, idx).trim(),
                            createdDate.substring(idx + 1, idx1 - 7).trim()
                          ];
                          //date creation manip

                          int idx2 = lastModifiedDate.indexOf("T");
                          int idx3 = lastModifiedDate.indexOf("Z");
                          List parts1 = [
                            lastModifiedDate.substring(0, idx).trim(),
                            lastModifiedDate
                                .substring(idx2 + 1, idx3 - 7)
                                .trim()
                          ];

                          String datec = parts[0] + ' ' + parts[1];
                          String datem = parts1[0] + ' ' + parts1[1];

                          print("test before card");
                          print(size);
                          print(doc['id']);

                          return Card(
                            child: ListTile(
                              trailing: IconButton(
                                  icon: new Icon(Icons.download),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildPopupDialog1(context, doc['id'],
                                              fileName, fileExtension),
                                    );
                                  }),
                              title: Expanded(
                                  child: IconButton(
                                      icon: new Icon(
                                        IconData(0xe33c,
                                            fontFamily: 'MaterialIcons'),
                                        color: Colors.amber,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              _buildPopupDialog(
                                                  context,
                                                  fileName,
                                                  fileExtension,
                                                  size,
                                                  createdBy,
                                                  lastModifiedBy,
                                                  datec,
                                                  datem),
                                        );
                                      })),

                              //return new ListTile(
                              onTap: () {},
                              leading: Expanded(
                                  child: Text(fileName + '.' + fileExtension)),
                            ),
                          );
                        }, //itemBuilder
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
            )),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    //show file name here
                    child: selectedfile == null
                        ? Text("Choose File")
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
                    label: Text("CHOOSE FILE"),
                    color: kPrimaryColor,
                    colorBrightness: Brightness.dark,
                  )),
                  selectedfile == null
                      ? Container()
                      : Container(
                          child: ElevatedButton.icon(
                          onPressed: () async {
                            var payload = Jwt.parseJwt(widget.jwt);
                            var log = payload['sub'];
                            print('$BaseUrl/file/uploadMultipleFiles/DP/$log');
                            var res = uploadFile(selectedfile.path,
                                '$BaseUrl/file/uploadFile/DP/$log');
                            setState(() {});
                          },
                          icon: Icon(Icons.folder_open),
                          label: Text("UPLOAD FILE"),
                        )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _navigationButtons() {
    return Wrap(
      spacing: 4.0, // gap between adjacent chips
      runSpacing: 2.0, // gap between lines
      direction: Axis.horizontal, // main axis (rows or columns)
      children: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: kPrimaryColor,
            onPrimary: kPrimaryLightColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
          child: Text(
            'DÉCLARATION IMPÔT',
            style: TextStyle(fontSize: 10.0, color: kPrimaryLightColor),
          ),
          onPressed: () {
            setState(() {
              index = 0;
            });
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: kPrimaryColor,
            onPrimary: kPrimaryLightColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
          child: Text(
            'ATTESTATION DE TRAVAIL',
            style: TextStyle(fontSize: 10.0, color: kPrimaryLightColor),
          ),
          onPressed: () {
            setState(() {
              index = 1;
            });
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: kPrimaryColor,
            onPrimary: kPrimaryLightColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
          child: Text(
            'BULLETIN DE PAIE',
            style: TextStyle(fontSize: 10.0, color: kPrimaryLightColor),
          ),
          onPressed: () {
            setState(() {
              index = 2;
            });
          },
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: kPrimaryColor,
              onPrimary: kPrimaryLightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
            child: Text(
              'DOCUMENT PERSONNEL',
              style: TextStyle(fontSize: 10.0, color: kPrimaryLightColor),
            ),
            onPressed: () {
              setState(() {
                index = 3;
              });
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 80),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: kPrimaryColor,
              onPrimary: kPrimaryLightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
            child: Text(
              'Upload Files',
              style: TextStyle(fontSize: 10.0, color: kPrimaryLightColor),
            ),
            onPressed: () {
              setState(() {
                index = 4;
              });
            },
          ),
        ),
      ],
    );
  }
}

Widget _buildPopupDialog(BuildContext context, String nom, String fileExtension,
    dynamic taille, String creater, String mod, dynamic datec, dynamic datem) {
  String tal = '$taille';
  String size = tal.substring(0, 7);
  return new AlertDialog(
    title: const Text('Your file information : '),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text("Name               : ",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(nom + '.' + fileExtension)
        ]),
        Row(children: <Widget>[
          Text("Size                  : ",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(size + ' KO'),
        ]),
        Row(children: <Widget>[
          Text("Created By      : ",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(creater),
        ]),
        Row(children: <Widget>[
          Text("Modified By    : ",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(mod),
        ]),
        Row(children: <Widget>[
          Text("Creation Date : ",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(datec)),
        ]),
        Row(children: <Widget>[
          Text("Modification\n       Date : ",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(' ' + datem)),
        ]),
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

Widget _buildPopupDialog1(
    BuildContext context, int id, String name, String type) {
  var pass = '';
  return new AlertDialog(
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextFieldContainer(
            child: TextField(
          onChanged: (val) {
            pass = val;
            print(pass);
          },
          cursorColor: kPrimaryColor,
          decoration: InputDecoration(
            icon: Icon(
              Icons.document_scanner,
              color: kPrimaryColor,
            ),
            hintText: 'PassPhrase',
            border: InputBorder.none,
          ),
        )),
        RoundedButton(
            text: 'Confirm',
            press: () async {
              print(pass);
              print(id);
              //download(pass, id);
              downloadFileUsingStreamPipe(pass, id, name, type);
              Navigator.of(context).pop();
            })
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
Widget _buildPopupDialogs(BuildContext context) {
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

