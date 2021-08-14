class User {
  int id;
  String firstName;
  String lastName;
  String login;
  String email;
  String password;
  String publicKey;
  String privateKey;
  dynamic role;
  String passphrase;
  String activationKey;
  bool activated;
  User({
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

  factory User.fromJSON(Map<String, dynamic> parsedJson) {
    return User(
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
}
