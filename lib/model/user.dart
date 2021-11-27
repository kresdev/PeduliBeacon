class User {
  static final User _user  = new User._internal();

  bool checkinStatus = false;
  String checkinPlace = '';

  factory User(){
    return _user;
  }

  User._internal();
}

final user = User();
