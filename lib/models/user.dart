class User {
  late String username;
  late String? email;
  late String? phoneNumber;
  late String id;
  late String fullName;
  late int redeemedCodeCount;
  late int points;
  late DateTime createdAt;

  void setFromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    id = json['id'];
    fullName = json['full_name'];
    redeemedCodeCount = json['redeemed_code_count'];
    points = json['points'];
    createdAt = DateTime.parse(json['created_at']);
  }

  void clear() {
    username = '';
    email = null;
    phoneNumber = null;
    fullName = '';
    id = '';
    redeemedCodeCount = 0;
    points = 0;
    createdAt = DateTime(0);
  }
}

class LeaderboardEntry {
  late String username;
  late int redeemedCodeCount;

  static fromJson(Map<String, dynamic> json) {
    LeaderboardEntry le = LeaderboardEntry();
    le.username = json['username'];
    le.redeemedCodeCount = json['redeemed_code_count'];
    return le;
  }
}

class UserTransactions {
  late String id;
  late String timestamp;
  late int amount;

  static fromJson(Map<String, dynamic> json) {
    UserTransactions ut = UserTransactions();
    ut.id = json['id'];
    ut.timestamp = json['timestamp'];
    ut.amount = json['amount'];
    return ut;
  }
}
