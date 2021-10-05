import 'package:flutter/material.dart';
import 'package:flutter_auth/upload.dart';

class typeButton extends StatefulWidget {
  final Upload upload;
  const typeButton({Key key, this.upload}) : super(key: key);

  @override
  _typeButtonState createState() => _typeButtonState();
}

class _typeButtonState extends State<typeButton> {
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
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
            if (newValue == 'PAYSLIP') {
              widget.upload.type = "BP";
            }
            if (newValue == 'WORK CERTIFICATE') {
              widget.upload.type = "AT";
            }
            if (newValue == 'TAX RETURN') {
              widget.upload.type = "DI";
            }
            if (newValue == 'PERSONAL DOCUMENT') {
              widget.upload.type = "DP";
            }


          },
          items: <String>[
            'BULLETIN DE PAIE',
            'ATTESTATION DE TRAVAIL',
            'DÉCLARATION IMPÔT',
            'DOCUMENT PERSONNEL'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          hint: Text(
            "Please Select A Folder",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          )),
    );
  }
}
