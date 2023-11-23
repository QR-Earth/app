const String KEYLOGIN = "isLoggedIn";
const String KEYID = "userid";
const String BASEURL = "https://qr-earth-fast-api-server.azurewebsites.net";

User USER = User();

class User {
  late String username;
  late String? email;
  late String? phone_number;
  late String id;
  late int codes_count;
  late String created_at;

  void setFromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    phone_number = json['phone_number'];
    id = json['id'];
    codes_count = json['codes_count'];
    created_at = json['created_at'];
  }
}

class Leaderboard {
  late String username;
  late int codes_count;

  static fromJson(Map<String, dynamic> json) {
    Leaderboard l = Leaderboard();
    l.username = json['username'];
    l.codes_count = json['codes_count'];
    return l;
  }
}

class UserHistory {
  late String id;
  late String redeemed_at;

  static fromJson(Map<String, dynamic> json) {
    UserHistory uh = UserHistory();
    uh.id = json['id'];
    uh.redeemed_at = json['redeemed_at'];
    return uh;
  }
}
