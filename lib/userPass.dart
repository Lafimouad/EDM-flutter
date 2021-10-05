import 'dart:convert';


class User1 {
  int id;
  String firstName;
  String lastName;
  String login;
  String email;
  String password;
  String publicKey;
  String privateKey;
  Map <String,dynamic> role;
  String passphrase;
  String activationKey;
  bool activated;
  User1({
    this.id,
    this.firstName,
    this.lastName,
    this.login,
    this.email,
    this.password,
    this.publicKey,
    this.privateKey,
    this.role,
    this.passphrase,
    this.activationKey,
    this.activated,
  });

  factory User1.fromJSON(Map<String, dynamic> parsedJson) {
    return User1(
        id: parsedJson['id'],
        firstName: parsedJson['firstName'],
        email: parsedJson['email'],
        lastName: parsedJson['lastName'],
        login: parsedJson['login'],
        password: parsedJson['password'],
        role: parsedJson['role'],
        passphrase: parsedJson['password'],
        activationKey: parsedJson['password'],
        activated: parsedJson['activated']);
  }


 



  User1 copyWith({
    int id,
    String firstName,
    String lastName,
    String login,
    String email,
    String password,
    String publicKey,
    String privateKey,
    Map <String,dynamic> role,
    String passphrase,
    String activationKey,
    bool activated,
  }) {
    return User1(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      login: login ?? this.login,
      email: email ?? this.email,
      password: password ?? this.password,
      publicKey: publicKey ?? this.publicKey,
      privateKey: privateKey ?? this.privateKey,
      role: role ?? this.role,
      passphrase: passphrase ?? this.passphrase,
      activationKey: activationKey ?? this.activationKey,
      activated: activated ?? this.activated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'login': login,
      'email': email,
      'password': password,
      'publicKey': publicKey,
      'privateKey': privateKey,
      'role': Map.of(role),
      'passphrase': passphrase,
      'activationKey': activationKey,
      'activated': activated,
    };
  }

  factory User1.fromMap(Map<String, dynamic> map) {
    return User1(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      login: map['login'],
      email: map['email'],
      password: map['password'],
      publicKey: map['publicKey'],
      privateKey: map['privateKey'],
      role: Map <String,dynamic>.from(map['role']),
      passphrase: map['passphrase'],
      activationKey: map['activationKey'],
      activated: map['activated'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User1.fromJson(String source) => User1.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, firstName: $firstName, lastName: $lastName, login: $login, email: $email, password: $password, publicKey: $publicKey, privateKey: $privateKey, role: $role, passphrase: $passphrase, activationKey: $activationKey, activated: $activated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User1 &&
      other.id == id &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.login == login &&
      other.email == email &&
      other.password == password &&
      other.publicKey == publicKey &&
      other.privateKey == privateKey &&
      other.role == role &&
      other.passphrase == passphrase &&
      other.activationKey == activationKey &&
      other.activated == activated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      login.hashCode ^
      email.hashCode ^
      password.hashCode ^
      publicKey.hashCode ^
      privateKey.hashCode ^
      role.hashCode ^
      passphrase.hashCode ^
      activationKey.hashCode ^
      activated.hashCode;
  }
}
