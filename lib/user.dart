import 'dart:convert';

class User {
  String firstName;
  String lastName;
  String login;
  String email;
  String password;
  User(this.firstName , this.lastName, this.login, this.email,this.password);


  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'login': login,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['firstName'],
      map['lastName'],
      map['login'],
      map['email'],
      map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(firstName: $firstName, lastName: $lastName, login: $login, email: $email, password: $password)';
  }
}
