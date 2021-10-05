import 'dart:convert';

import 'package:flutter/cupertino.dart';

class UserRH {
  String fullname;
  String login;
  UserRH({
    @required this.fullname,
     @required this.login,
  });

  UserRH copyWith({
    String fullname,
    String login,
  }) {
    return UserRH(
      fullname: fullname ?? this.fullname,
      login: login ?? this.login,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullname,
      'login': login,
    };
  }

  factory UserRH.fromMap(Map<String, dynamic> map) {
    return UserRH(
      fullname: map['fullname'],
      login: map['login'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRH.fromJson(String source) => UserRH.fromMap(json.decode(source));

  @override
  String toString() => 'UserRH(fullname: $fullname, login: $login)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserRH &&
      other.fullname == fullname &&
      other.login == login;
  }

  @override
  int get hashCode => fullname.hashCode ^ login.hashCode;
}

